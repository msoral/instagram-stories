import 'package:equatable/equatable.dart';

abstract class StoryEvent extends Equatable{

  @override
  List<Object> get props => [];
}

class StoryStartedEvent extends StoryEvent {}
class PauseStoryEvent extends StoryEvent {}
class NextStoryEvent extends StoryEvent {}
class PreviousStoryEvent extends StoryEvent {}
class NextStoryGroupEvent extends StoryEvent {}
class PreviousStoryGroupEvent extends StoryEvent {}