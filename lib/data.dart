

import 'domain/entities/story.dart';
import 'domain/entities/user.dart';

const User user = User(
  1,
  'John Doe',
  'https://wallpapercave.com/wp/AYWg3iu.jpg',
);
final List<Story> stories = [
  Story(
    'https://images.unsplash.com/photo-1534103362078-d07e750bd0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
    MediaType.image,
    const Duration(seconds: 10),
    user,
  ),
  Story(
    'https://media.giphy.com/media/moyzrwjUIkdNe/giphy.gif',
    MediaType.image,
    const Duration(seconds: 7),
    user
  ),
  Story(
    'https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4',
    MediaType.video,
    const Duration(seconds: 0),
    user,
  ),
  Story(
    'https://images.unsplash.com/photo-1531694611353-d4758f86fa6d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=564&q=80',
    MediaType.image,
    const Duration(seconds: 5),
    user,
  ),
  Story(
    'https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4',
    MediaType.video,
    const Duration(seconds: 0),
    user,
  ),
  Story(
    'https://media2.giphy.com/media/M8PxVICV5KlezP1pGE/giphy.gif',
    MediaType.image,
    const Duration(seconds: 8),
    user,
  ),
];