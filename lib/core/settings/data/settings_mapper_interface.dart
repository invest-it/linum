abstract class ISettingsMapper<T> {

  T toModel(Map<String, dynamic> map);
  Map<String, dynamic> toMap(T model);
}
