import 'dart:convert' show json;
import 'dart:io' show File;

import 'data_provider.dart';

class JsonDataProvider<T> extends DataProvider {
  final String notImplementedMsg = "This feature is not yet implemented.";
  final String _path;

  JsonDataProvider(this._path);

  @override
  Future<T> readData() async {
    var input = await File(_path).readAsString();
    return json.decode(input);
  }

  @override
  Future<int> createData(data) async {
    /* Out of scope but I will briefly explain what to do.
    encode given data to json string. Parse the json file with a given path to see if
    data with same id exists. Throw exception if it does, otherwise append the data to the json file.
    If no id is given increment the largest id and assign it to this object.
    */
    throw UnimplementedError(notImplementedMsg);
  }

  @override
  Future<void> deleteData(int id) async {
    /* Out of scope but I will briefly explain what to do.
    Find the data with the given id and delete that json block. Throw exception if
    data with given id does not exist.
     */
    throw UnimplementedError(notImplementedMsg);
  }

  @override
  Future<void> updateData(int id, data) async {
    /* Out of scope but I will briefly explain what to do.
    Similar to createData function but throws exception if the id is not found.
     */
    throw UnimplementedError(notImplementedMsg);
  }
}
