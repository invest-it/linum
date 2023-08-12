abstract class ISettingsRepository<TSettings> {
  Stream<TSettings> get settingsStream;
  TSettings get settings;

  Future<void> update(TSettings settings);
}
