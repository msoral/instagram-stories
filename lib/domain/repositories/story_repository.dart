import 'package:src/domain/entities/user.dart';
import 'package:src/domain/entities/story.dart';

import '../entities/story_group.dart';

abstract class StoryRepository {
  Future<List<Story>> getStories (User user);
  Future<List<StoryGroup>> getStoryGroups ();
}