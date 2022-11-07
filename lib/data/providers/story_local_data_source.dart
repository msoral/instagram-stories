import 'dart:collection';

import '../../domain/entities/story.dart';

class StoryLocalDataSource {
  static final StoryLocalDataSource _instance = StoryLocalDataSource._internal();
  late HashMap<int, Story> cachedStories;
  late HashMap<int, int> pausedStoryTime;
  factory StoryLocalDataSource() {
    return _instance;
  }

  StoryLocalDataSource._internal() {
    cachedStories = HashMap();
  }

  void add (Story story) {
    cachedStories[story.id] = story;
  }
}