import 'package:src/domain/repositories/story_repository.dart';

import '../entities/story.dart';
import '../entities/story_group.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GroupStoriesUseCase {
  final StoryRepository storyRepository;
  final UserRepository userRepository;

  GroupStoriesUseCase(this.storyRepository, this.userRepository);

  Future<List<User>> getAllUsers () async {
    return userRepository.getUsers();
  }

  Future<StoryGroup> getStoryGroup(User user) async {
    List<Story> stories = await storyRepository.getStories(user);
    return StoryGroup(user, stories);
  }
}
