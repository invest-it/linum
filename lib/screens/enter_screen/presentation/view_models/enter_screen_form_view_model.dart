import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/common/interfaces/translator.dart';
import 'package:linum/common/utils/keyboard_state_listener.dart';
import 'package:linum/screens/enter_screen/presentation/models/default_values.dart';
import 'package:linum/screens/enter_screen/presentation/models/enter_screen_form_data.dart';
import 'package:linum/screens/enter_screen/presentation/utils/form_data_updater.dart';

class EnterScreenFormViewModel extends ChangeNotifier {
  final KeyboardStateListener keyboardStateListener = KeyboardStateListener();
  final DefaultValues defaultValues;
  final ITranslator _translator;
  // late final bool withExistingData; // TODO: ????

  final _streamController = StreamController<EnterScreenFormData>();
  late Stream<EnterScreenFormData> stream = _streamController.stream;

  EnterScreenFormData _data;

  EnterScreenFormData get data => _data;
  set data(EnterScreenFormData data) {
    _data = FormDataUpdater(oldData: _data, newData: data, translator: _translator).update();
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
    required ITranslator translator,
  }) : _data = initialData, _entryType = entryType, _translator = translator {
    keyboardStateListener.subscribe(KeyboardStateEvent.changed, () {
      setOverlayEntry(null);
    });
  }


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
