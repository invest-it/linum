enum ChangeType {
  create,
  update,
  delete,
}


class ModelChange<T> {
  final ChangeType type;
  final T model;

  ModelChange(this.type, this.model);

  @override
  String toString() {
    return "ModelChange<$T>($type)";
  }
}
