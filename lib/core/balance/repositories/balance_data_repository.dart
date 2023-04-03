import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:linum/core/balance/models/balance_document.dart';
import 'package:logger/logger.dart';

class BalanceDataRepository {
  final String _userId;
   DocumentReference<BalanceDocument>? _docRef;
  Future <DocumentReference<BalanceDocument>> get docRef async {
    if (_docRef == null) {
      final ref = await getDocumentReference(_userId);
      if (ref == null) {
        throw Exception("A doc ref can never be null for an existing user");
      }
      _docRef = ref;
      return Future.value(ref);
    }
    return Future.value(_docRef);
  }
  
  Stream <DocumentSnapshot<BalanceDocument>>? get stream {
    return docRef.asStream().asyncExpand((event) {

      event.snapshots().asyncMap((event) => Logger().d(event.data()));
      return event.snapshots();
    });
  }

  Stream<BalanceDocument?> get balanceDocument {
    return docRef.asStream().asyncMap((event) async {
      final snapshot = await event.get();
      return snapshot.data();
    });
  }
  
  BalanceDataRepository({required String userId}) : _userId = userId;

  Future<void> set(BalanceDocument data) async {
    final ref = await docRef;
    await ref.set(data);
  }

  Future<void> update(Map<String, Object?> data) async {
    final ref = await docRef;
    await ref.update(data);
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
          _userId: [ref.id]
        }),
    );
    return [ref.id];
  }

  Future <DocumentReference<BalanceDocument>?> getDocumentReference(String userId) async {
    if (userId == "") {
      return null;
    }
    final  DocumentSnapshot<Map<String, dynamic>> documentToUser =
    await  FirebaseFirestore.instance
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
      final doc =  FirebaseFirestore.instance
          .collection('balance')
          .withConverter<BalanceDocument>(
        fromFirestore: (snapshot, _) =>
            BalanceDocument.fromMap(snapshot.data()!),
        toFirestore: (doc, _) => doc.toMap(),
      ).doc(docs[0] as String);

      return doc;
    } else {
      Logger().wtf("no data found in documentToUser");
    }
    return null;
  }
}
