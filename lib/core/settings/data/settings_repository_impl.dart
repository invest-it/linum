import 'package:linum/core/settings/data/settings_mapper_interface.dart';
import 'package:linum/core/settings/domain/settings_repository.dart';
import 'package:linum/core/settings/domain/settings_storage.dart';
import 'package:rxdart/rxdart.dart';

class SettingsRepositoryImpl<TSettings> extends ISettingsRepository<TSettings> {
  final ISettingsStorage _adapter;
  final ISettingsMapper<TSettings> _mapper;
  final String? userId;

  final BehaviorSubject<TSettings> _settings = BehaviorSubject();

  SettingsRepositoryImpl({
    this.userId,
    required ISettingsStorage adapter,
    required ISettingsMapper<TSettings> mapper,
  }): _adapter = adapter, _mapper = mapper {
    _settings.add(mapper.toModel({}));

    var previous = _settings.value;
    final modifiedStream = adapter.getDataStreamForUser(userId).map((event) {
      return mapper.toModel(event);
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
    final map = _mapper.toMap(settings);
    await _adapter.updateUserData(userId, map);
  }
}
