import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/core/settings/data/settings_data.dart';
import 'package:linum/core/settings/domain/settings_storage.dart';

class SettingsStorageImpl implements ISettingsStorage {
  final FirebaseFirestore _firestore;
  SettingsStorageImpl(this._firestore);

  DocumentReference<SettingsData> _getDocRef(String? userId)
    => _firestore.collection("account_settings").doc(userId);

  Future<DocumentSnapshot<SettingsData>> _getSnapshot(String? userId) async {
    final snapshot = await _getSnapshot(userId);
    /* if (!snapshot.exists) {
      await snapshot.reference.set({});
      return _getSnapshot(userId);
    } */
    // TODO: Check if even necessary
    return snapshot;
  }

  @override
  Future<SettingsData> getDataForUser(String? userId) async {
    final snapshot = await _getSnapshot(userId);
    final map = snapshot.data();
    return map ?? {};
  }

  @override
  Stream<SettingsData> getDataStreamForUser(String? userId) async* {
    final docRef = _getDocRef(userId);
    yield* docRef.snapshots().map((event) {
      return event.data() ?? {};
    });
  }

  @override
  Future<void> updateUserData(String? userId, SettingsData data) async {
    final docRef = _getDocRef(userId);
    await docRef.set(data, SetOptions(merge: true));
  }
}
