import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/app/pages/story/story_event.dart';
import 'package:src/app/pages/story/story_state.dart';
import 'package:src/app/pages/story/story_view.dart';

import '../../../domain/entities/story.dart';
import '../../../domain/entities/story_group.dart';
import '../../../domain/repositories/story_repository.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryRepository _repository;

  StoryBloc(this._repository) : super(StoryState()) {
    on<StoryStartedEvent>(_onStoryStarted);
    on<NextStoryEvent>(_nextStory);
    on<PreviousStoryEvent>(_onPreviousStory);
  }

  void _onStoryStarted (StoryStartedEvent event, Emitter<StoryState> emit) async {
    List<StoryGroup> storyGroups = await _repository.getStoryGroups();
    emit(StoryState(storyGroups: storyGroups));
  }

  void _nextStory(NextStoryEvent event, Emitter<StoryState> emit) {
    print("Getting next story");
    state.nextStory();
    emit(state);
  }

  void _onPreviousStory (PreviousStoryEvent event, Emitter<StoryState> emit) {
    state.previousStory();
    emit(state);
  }


}