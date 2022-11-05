import 'package:src/domain/entities/story.dart';
import 'package:src/domain/entities/user.dart';

class StoryGroup {
  final User user;
  final List<Story> stories;

  StoryGroup(this.user, this.stories);
}