import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linum/core/settings/data/settings_data.dart';
import 'package:linum/core/settings/domain/settings_storage.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class SettingsStorageImpl implements ISettingsStorage {
  final FirebaseFirestore _firestore;
  final String? _userId;
  final StreamController<SettingsData> _controller = BehaviorSubject<SettingsData>();
  StreamSubscription<SettingsData>? _streamSubscription;

  SettingsStorageImpl(this._firestore, String? userId): _userId = userId {
    _controller.onListen = () {
      final docRef = _getDocRef();

      print("Subscribing now");

      _streamSubscription = docRef.snapshots().map((event) => event.data() ?? {}).listen((event) {
        print("Snapshots: $event");
        _controller.add(event);
      });

    };

    _controller.onCancel = () {
      _streamSubscription?.cancel();
    };
  }

  DocumentReference<SettingsData> _getDocRef()
    => _firestore.collection("account_settings").doc(_userId);

  @override
  Future<SettingsData?> getDataForUser() async {
    final snapshot = await _getDocRef().snapshots().first;
    final map = snapshot.data();
    return map;
  }

  @override
  Stream<SettingsData> getDataStreamForUser() {
    return _controller.stream.asBroadcastStream();
  }

  @override
  Future<void> updateUserData(SettingsData data) async {
    try {
      final docRef = _getDocRef();
      await docRef.set(data, SetOptions(merge: true));
    } on Exception catch(e) {
      Logger().e(e);
      _controller.sink.add(data);
    }
  }

  void dispose() {
    print("Disposed of SettingsStorage");
    _streamSubscription?.cancel();
    _controller.close();
  }
}
