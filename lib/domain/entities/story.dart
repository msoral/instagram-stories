import 'package:src/domain/entities/user.dart';

enum MediaType {
  image,
  video
}

class Story {
  final String url;
  final MediaType media;
  final Duration duration;
  final User creator;

  Story (
      this.url,
      this.media,
      this.duration,
      this.creator,
      );
}