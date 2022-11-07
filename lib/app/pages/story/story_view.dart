import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/app/pages/story/story_bloc.dart';
import 'package:src/app/pages/story/story_bloc.dart';
import 'package:src/app/pages/story/story_event.dart';
import 'package:src/app/pages/story/story_state.dart';
import 'package:src/app/widgets/user_profile_icon.dart';
import 'package:video_player/video_player.dart';

import '../../../data/repositories/story_repository_impl.dart';
import '../../../domain/entities/story.dart';
import '../../widgets/animated_bar.dart';

class StoryView extends StatefulWidget {
  const StoryView({super.key});

  @override
  State<StatefulWidget> createState() => StoryViewState();
}

class StoryViewState extends State<StoryView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  late VideoPlayerController _videoController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    StoryBloc bloc = StoryBloc(StoryRepositoryImpl());
    _pageController = PageController();
    _animController = AnimationController(vsync: this);

    _loadStory(story: bloc.state.story, animateToPage: false);
    _videoController = VideoPlayerController.network(bloc.state.story.url)
      ..initialize().then((value) => {setState(() {})});

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.stop();
        _animController.reset();
        bloc.add(NextStoryEvent());
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StoryState state = context.watch<StoryBloc>().state;
    final Story story = state.story;

    return RepositoryProvider(
      create: (context) => StoryRepositoryImpl(),
      child: BlocProvider(
        create: (BuildContext context) => StoryBloc(context.read<StoryRepositoryImpl>()),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTapDown: (details) => _onTapDown(context, details),
            child: Stack(
              children: <Widget>[
                PageView.builder(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.stories.length,
                  itemBuilder: (context, i) {
                    final Story story = state.story;
                    switch (story.media) {
                      case MediaType.image:
                        return CachedNetworkImage(
                          imageUrl: story.url,
                          fit: BoxFit.cover,
                        );
                      case MediaType.video:
                        if (_videoController != null &&
                            _videoController.value.isInitialized) {
                          return FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _videoController.value.size.width,
                              height: _videoController.value.size.height,
                              child: VideoPlayer(_videoController),
                            ),
                          );
                        }
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Positioned(
                  top: 40.0,
                  left: 10.0,
                  right: 10.0,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: state.stories
                            .asMap()
                            .map((i, e) {
                          return MapEntry(
                              i,
                              _createAnimatedBar(
                                  state, _animController, i, _currentIndex));
                        })
                            .values
                            .toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 1.5,
                          vertical: 10.0,
                        ),
                        child: UserProfileIcon(
                            Key(state.user.name), state.user),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapDown(BuildContext context, TapDownDetails details) {
    final storyBloc = context.read<StoryBloc>();
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      storyBloc.add(PreviousStoryEvent());
    } else if (dx > 2 * screenWidth / 3) {
      storyBloc.add(NextStoryEvent());

    } else {
      storyBloc.add(PauseStoryEvent());
    }
  }

  void _loadStory({required Story story, bool animateToPage = true}) {
    _animController.stop();
    _animController.reset();
    switch (story.media) {
      case MediaType.image:
        _animController.duration = story.duration;
        _animController.forward();
        break;
      case MediaType.video:
        _videoController.dispose();
        _videoController = VideoPlayerController.network(story.url)
          ..initialize().then((_) {
            setState(() {});
            if (_videoController.value.isInitialized) {
              _animController.duration = _videoController.value.duration;
              _videoController.play();
              _animController.forward();
            }
          });
        break;
    }
    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}

AnimatedBar _createAnimatedBar(StoryState state, AnimationController controller,
    int index, int currentIndex) {
  return AnimatedBar(
      Key(state.stories[index].url), controller, index, currentIndex);
}
