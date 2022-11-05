import 'dart:convert' show json;
import 'dart:io' show File;

import 'data_provider.dart';

import 'package:src/constants.dart';


class FileDataProvider<T> implements DataProvider {
  final String notImplementedMsg = "This feature is not yet implemented.";

  FileDataProvider();

  @override
  Future<T> readData() {
    throw UnimplementedError(notImplementedMsg);
  }

  @override
  Future<int> createData(data) {
    // TODO: implement createData
    throw UnimplementedError(notImplementedMsg);
  }

  @override
  Future<void> deleteData(int id) {
    // TODO: implement deleteData
    throw UnimplementedError(notImplementedMsg);
  }

  @override
  Future<void> updateData(int id, data) {
    // TODO: implement updateData
    throw UnimplementedError(notImplementedMsg);
  }


  Future<List<Map>> readJsonFile(String filePath) async {

    var input = await File(filePath).readAsString();
    return json.decode(input);
  }


}
