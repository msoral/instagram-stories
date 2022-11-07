import 'package:equatable/equatable.dart';

enum MediaType { image, video }

class Story extends Equatable {
  final int id;
  final String url;
  final MediaType media;
  final Duration duration;
  final int creatorId;

  Story(
    this.id,
    this.url,
    this.media,
    this.duration,
    this.creatorId,
  );

  @override
  List<Object?> get props => [id, url];
}
