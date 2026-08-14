abstract interface class Repository<T> {
  Future<List<T>> getAll();

  Future<T?> getById(int id);

  Future<void> save(T item);

  Future<void> update(int id, T item);

  Future<void> delete(int id);
}
