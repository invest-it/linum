import 'package:linum/common/interfaces/service_interface.dart';

abstract class ISettingsRepository<TSettings> with NotifyReady {
  Stream<TSettings> get settingsStream;
  TSettings get settings;
  Future<void> update(TSettings settings);
}
