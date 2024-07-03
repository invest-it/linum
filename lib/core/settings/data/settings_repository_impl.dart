import 'package:linum/core/settings/data/pref_adapter.dart';
import 'package:linum/core/settings/data/settings_mapper_interface.dart';
import 'package:linum/core/settings/domain/settings_repository.dart';
import 'package:linum/core/settings/domain/settings_storage.dart';
import 'package:rxdart/rxdart.dart';

class SettingsRepositoryImpl<TSettings> extends ISettingsRepository<TSettings> {
  final ISettingsStorage _adapter;
  final ISettingsMapper<TSettings> _mapper;
  final IPrefAdapter<TSettings>? _prefAdapter;

  final BehaviorSubject<TSettings> _settings = BehaviorSubject();

  SettingsRepositoryImpl({
    required ISettingsStorage adapter,
    required ISettingsMapper<TSettings> mapper,
    IPrefAdapter<TSettings>? prefAdapter,
  }): _adapter = adapter, _mapper = mapper, _prefAdapter = prefAdapter {
    _init();
  }

  Future<void> _init() async {
    var defaultVal = _prefAdapter?.load();

    // TODO: This might cause stream state errors, but for now it seems to work
    final settings = await _adapter.getDataForUser();
    if (settings != null) {
      defaultVal = _mapper.toModel(settings);
    }
    _settings.add(defaultVal ?? _mapper.toModel({}));

    var previous = _settings.value;
    final modifiedStream = _adapter.getDataStreamForUser().map((event) {
      return _mapper.toModel(event);
    }).where((element) {
      final equals = element.toString() != previous.toString();
      previous = element;
      return equals;
    });

    _settings.addStream(modifiedStream);
  }

  @override
  Stream<TSettings> get settingsStream => _settings.stream;
  @override
  TSettings get settings => _settings.value;

  @override
  Future<void> update(TSettings settings) async {
    _prefAdapter?.store(settings);
    final map = _mapper.toMap(settings);
    await _adapter.updateUserData(map);
  }
}
