abstract class IMappable<T> {
  Map<String, dynamic> toMap();
}

abstract class IMappableFactory<T> {
  T fromMap(Map<String, dynamic> map);
}
