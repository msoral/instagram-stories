import 'dart:core';

class Constants {

  static final Constants _instance = Constants._internal();
  factory Constants() => _instance;
  Constants._internal();

  static const String rootConfigPath = "../../config.yaml";
  static const String rootDataPath = "../../data.json";
  static const String resourcesPath = "../resources/";
}