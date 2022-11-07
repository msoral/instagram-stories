import 'package:equatable/equatable.dart';
import 'package:src/domain/repositories/story_repository.dart';

import '../../../domain/entities/story.dart';
import '../../../domain/entities/story_group.dart';
import '../../../domain/entities/user.dart';

enum StoryStatus {initial, viewed, paused }

class StoryState extends Equatable {
  final StoryStatus status;
  final Map<StoryGroup, int> _storyGroupAndIndexMap = {};
  late List<StoryGroup> storyGroups;
  late StoryGroup _currentStoryGroup;
  late List<Story> stories;
  late Story story;
  late User user;
  int index = 0;
  int storyIndex = 0;

  StoryState({this.status = StoryStatus.initial, this.storyGroups = const []}) {
    _initState();
  }

  void setValues () {
    user = _currentStoryGroup.user;
    stories = _currentStoryGroup.stories;
    storyIndex = _storyGroupAndIndexMap[_currentStoryGroup] ?? 0;
    story = stories[storyIndex];
  }

  void _initState () {
    if (storyGroups.isEmpty) {
      return;
    }
    _currentStoryGroup = storyGroups[index];
    setValues();
  }

  void nextStoryGroup () {
    if (index == storyGroups.length) {
      return;
    }
    index++;
    setValues();
  }

  void previousStoryGroup () {
    if (index == 0) {
      return;
    }
    index--;
    setValues();
  }

  void nextStory () {
    try {
      storyIndex++;
      story = stories[storyIndex];
      _storyGroupAndIndexMap[_currentStoryGroup] = storyIndex;
    } on RangeError {
      nextStoryGroup();
    }
  }

  void previousStory () {
    try {
      storyIndex--;
      story = stories[storyIndex];
      _storyGroupAndIndexMap[_currentStoryGroup] = storyIndex;
    } on RangeError {
      previousStoryGroup();
    }
  }

  @override
  List<Object?> get props => [status, story, user];
}
