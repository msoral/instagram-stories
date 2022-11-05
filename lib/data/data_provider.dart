abstract class DataProvider<T> {
  Future<int> createData(T data); // returns the id of created data.
  Future<T> readData();
  Future<void> updateData(int id, T data);
  Future<void> deleteData(int id);
}