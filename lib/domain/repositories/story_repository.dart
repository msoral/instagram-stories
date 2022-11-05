import 'package:src/domain/entities/user.dart';
import 'package:src/domain/entities/story.dart';

abstract class StoryRepository {
  Future<List<Story>> getStories (User user);
}