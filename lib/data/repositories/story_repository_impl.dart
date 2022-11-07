import 'package:src/data/dto/story_dto.dart';
import 'package:src/data/providers/json_data_source.dart';
import 'package:src/domain/entities/story.dart';
import 'package:src/domain/entities/story_group.dart';
import 'package:src/domain/entities/user.dart';
import 'package:src/domain/repositories/story_repository.dart';

import '../dto/user_dto.dart';

class StoryRepositoryImpl implements StoryRepository {
  final JsonDataSource _fileDataSource = JsonDataSource();


  StoryRepositoryImpl();

  @override
  Future<List<Story>> getStories(User user) async {
    try {
      List<StoryDTO> storyDTO = await _fileDataSource.getStories(user.id);
      List<Story> result = storyDTO.map((e) => e.toEntity()).toList();
      return result;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<List<StoryGroup>> getStoryGroups() async {
    List<StoryGroup> result = [];
    List<User> users = await _getUsers();
    for (User user in users) {
      List<Story> stories = await getStories(user);
      result.add(StoryGroup(user, stories));
    }
    return result;
  }


  Future<List<User>> _getUsers () async {
    try {
      List<UserDTO> userDTOList = await _fileDataSource.getUsers();
      List<User> result = userDTOList.map((e) => e.toEntity()).toList();
      return result;
    } on Exception catch (e) {
      print (e);
      rethrow;
    }
  }


}