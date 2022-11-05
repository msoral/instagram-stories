import 'package:src/domain/entities/story.dart';
import 'package:src/domain/entities/user.dart';
import 'package:src/domain/repositories/story_repository.dart';

class DataStoryRepository implements StoryRepository {
  static final DataStoryRepository _instance = DataStoryRepository._internal();

  factory DataStoryRepository() => _instance;

  DataStoryRepository._internal();

  @override
  Future<List<Story>> getStories(User user) async {
    // TODO: implement getStories
    throw UnimplementedError();
  }
}