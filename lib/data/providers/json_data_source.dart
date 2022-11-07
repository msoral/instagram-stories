import 'package:src/data/dto/story_dto.dart';
import 'package:src/data/dto/user_dto.dart';
import 'package:src/data/json_data_provider.dart';

import '../../constants.dart';

class JsonDataSource {
  static const String storyDataPath = "${Constants.rootDataPath}story.json";
  static const String userDataPath = "${Constants.rootDataPath}user.json";

  Future<List<StoryDTO>> getStories (int userId) async {
    try {
      final JsonDataProvider jsonDataProvider = JsonDataProvider<StoryDTO>(storyDataPath);

      final response = await jsonDataProvider.readData();
      List<StoryDTO> result = [];
      for (dynamic item in response) {
        StoryDTO storyDTO = StoryDTO.fromJson(item);
        if (storyDTO.creatorId == userId) {
          result.add(storyDTO);
        }
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserDTO>> getUsers () async {
    try {
      final JsonDataProvider jsonDataProvider = JsonDataProvider<UserDTO>(userDataPath);
      final response = await jsonDataProvider.readData();
      List<UserDTO> result = [];
      for (dynamic item in response) {
        UserDTO userDTO = UserDTO.fromJson(item);
        result.add(userDTO);
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }
}