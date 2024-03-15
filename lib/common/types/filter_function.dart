typedef Filter<T> = bool Function(T item);

bool applyFilter<T>(Filter<T>? filter, T element) {
  if (filter == null) {
    return true;
  }
  return filter(element);
}
