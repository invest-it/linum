import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:jiffy/jiffy.dart';
import 'package:linum/common/interfaces/time_span.dart';
import 'package:linum/core/balance/domain/balance_data_adapter.dart';
import 'package:linum/core/balance/domain/models/serial_transaction.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/balance/ports/firebase/balance_document.dart';
import 'package:linum/core/budget/domain/models/changes.dart';
import 'package:logger/logger.dart';

class FirebaseBalanceAdapter implements IBalanceDataAdapter {
  final String _userId;
  DocumentReference<BalanceDocument>? _cachedDocRef;
  Future <DocumentReference<BalanceDocument>> get _docRef async {
    if (_cachedDocRef == null) {
      final ref = await getDocumentReference(_userId);
      if (ref == null) {
        throw Exception("A doc ref can never be null for an existing user");
      }
      _cachedDocRef = ref;
      return Future.value(ref);
    }
    return Future.value(_cachedDocRef);
  }

  FirebaseBalanceAdapter({required String userId}) : _userId = userId;

  Future<void> set(BalanceDocument data) async {
    final ref = await _docRef;
    await ref.set(data);
  }

  Future<void> update(Map<String, Object?> data) async {
    final ref = await _docRef;
    await ref.update(data);
  }

  @override
  Future<void> executeSerialTransactionChanges(List<ModelChange<SerialTransaction>> changes) async {
    final data = await getSnapshot() ?? BalanceDocument();
    for (final change in changes) {
      switch (change.type) {
        case ChangeType.create:
          data.serialTransactions.add(change.model);
        case ChangeType.update:
          final index = data.serialTransactions.indexWhere((s) => s.id == change.model.id);
          if (index < 0) {
            data.serialTransactions.add(change.model);
            break;
          }
          data.serialTransactions[index] = change.model;
        case ChangeType.delete:
          data.serialTransactions.removeWhere((s) => s.id == change.model.id);
      }
    }
    await set(data);
  }

  @override
  Future<void> executeTransactionChanges(List<ModelChange<Transaction>> changes) async {
    final data = await getSnapshot() ?? BalanceDocument();
    for (final change in changes) {
      switch (change.type) {
        case ChangeType.create:
          data.transactions.add(change.model);
        case ChangeType.update:
          final index = data.transactions.indexWhere((s) => s.id == change.model.id);
          if (index < 0) {
            data.transactions.add(change.model);
            break;
          }
          data.transactions[index] = change.model;
        case ChangeType.delete:
          data.transactions.removeWhere((s) => s.id == change.model.id);
      }
    }
    await set(data);
  }

  @override
  Future<List<SerialTransaction>> getAllSerialTransactions() async {
    final data = await getSnapshot();
    if (data == null) {
      return [];
    }
    return data.serialTransactions;
  }

  @override
  Future<List<SerialTransaction>> getAllSerialTransactionsForMonth(DateTime month) async {
    final data = await getSnapshot();

    if (data == null) {
      return [];
    }
    return data.serialTransactions
        .where((s) => s.containsDate(month))
        .toList();
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final data = await getSnapshot();
    if (data == null) {
      return [];
    }
    return data.transactions;
  }

  @override
  Future<List<Transaction>> getAllTransactionsForMonth(DateTime month) async {
    final data = await getSnapshot();
    if (data == null) {
      return [];
    }
    final yMMM = Jiffy.parseFromDateTime(month).yMMM;
    return data.transactions
      .where((t) => Jiffy.parseFromDateTime(t.date).yMMM == yMMM)
      .toList();
  }

  Future<BalanceDocument?> getSnapshot() async {
    return _docRef.then((ref) => ref.get()).then((snap) => snap.data());
  }

  /// Creates Document if it doesn't exist
  Future<List<dynamic>> createDoc() async {
    Logger().i("creating document");
    final  DocumentSnapshot<Map<String, dynamic>> doc = await
    FirebaseFirestore.instance
        .collection('balance')
        .doc("documentToUser")
        .get();
    final Map<String, dynamic>? docData = doc.data();
    Map<String, dynamic> docDataNullSafe = {};
    if (docData != null) {
      docDataNullSafe = docData;
    }

    final  DocumentReference<Map<String, dynamic>> ref =
    await  FirebaseFirestore.instance.collection('balance').add({
      "balanceData": [],
      "repeatedBalance": [],
      "settings": {},
    });

    await  FirebaseFirestore.instance
        .collection('balance')
        .doc("documentToUser")
        .set(
      docDataNullSafe
        ..addAll({
          _userId: [ref.id],
        }),
    );
    return [ref.id];
  }

  Future<DocumentReference<BalanceDocument>?> getDocumentReference(String userId) async {
    if (userId == "") {
      return null;
    }
    final  DocumentSnapshot<Map<String, dynamic>> documentToUser =
    await FirebaseFirestore.instance
        .collection('balance')
        .doc("documentToUser")
        .get();

    if (documentToUser.exists) {
      List<dynamic>? docs;
      try {
        docs = documentToUser.get(userId) as List<dynamic>?;
      } catch (e) {
        docs = await createDoc();
      }
      if (docs == null) {
        //docs = await _createDoc();
        Logger().e("error getting doc id");
        return null;
      }
      if (docs.isEmpty) {
        docs = await createDoc();
      }
      // Future support multiple docs per user
      final doc = FirebaseFirestore.instance
          .collection('balance')
          .withConverter<BalanceDocument>(
        fromFirestore: (snapshot, _) =>
            BalanceDocument.fromMap(snapshot.data()!),
        toFirestore: (doc, _) => doc.toMap(),
      ).doc(docs[0] as String);

      return doc;
    } else {
      Logger().f("no data found in documentToUser");
    }
    return null;
  }
}
