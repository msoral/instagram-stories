import 'dart:core';

class Constants {

  static final Constants _instance = Constants._internal();
  factory Constants() => _instance;
  Constants._internal();

  static const String projectRoot = "../..";
  static const String rootConfigPath = "$projectRoot/config.yaml";
  static const String rootDataPath = "$projectRoot/data/";
  static const String resourcesPath = "$projectRoot/resources/";
}