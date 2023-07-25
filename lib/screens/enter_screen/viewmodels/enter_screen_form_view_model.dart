import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/screens/enter_screen/models/default_values.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_form_data.dart';
import 'package:linum/screens/enter_screen/utils/form_data_updater.dart';

class EnterScreenFormViewModel extends ChangeNotifier {
  final DefaultValues defaultValues;
  // late final bool withExistingData; // TODO: ????
  final _streamController = StreamController<EnterScreenFormData>();
  late Stream<EnterScreenFormData> stream = _streamController.stream;

  EnterScreenFormData _data;

  EnterScreenFormData get data => _data;
  set data(EnterScreenFormData data) {
    _data = FormDataUpdater(oldData: _data, newData: data).update();
    print(_data.parsed.currency);
    print(_data.options.currency);
    _streamController.add(_data);
    notifyListeners();
  }

  EntryType? _entryType;

  OverlayEntry? _currentOverlay;
  OverlayEntry? get currentOverlay => _currentOverlay;
  void setOverlayEntry(OverlayEntry? overlayEntry) {
    _currentOverlay?.remove();
    _currentOverlay = overlayEntry;
  }

  EnterScreenFormViewModel({
    required this.defaultValues,
    required EntryType entryType,
    required EnterScreenFormData initialData,
  }) : _data = initialData, _entryType = entryType;


  void handleUpdate(EntryType entryType) {
    if (entryType != _entryType) {
      _entryType = entryType;
      // TODO: Check if this is enough
      notifyListeners();
    }
  }


  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _currentOverlay?.remove();
  }
}