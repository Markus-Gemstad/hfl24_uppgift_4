abstract interface class RepositoryInterface<T> {
  Future<T?> create(T item);
  Future<T?> update(T item);
  Future<T?> getById(int id);
  Future<List<T>> getAll([int Function(T a, T b)? compare]);
  Future<bool> delete(int id);
}
