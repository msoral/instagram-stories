import '../../domain/entities/story.dart';

class StoryDTO {
  StoryDTO({
    required this.id,
    this.url,
    this.media,
    this.duration,
    this.creatorId,
  });

  int id;
  String? url;
  String? media;
  String? duration;
  int? creatorId;

  factory StoryDTO.fromJson(Map<String, dynamic> json) => StoryDTO(
      id: json['id'],
      url: json['url'],
      media: json['media'],
      duration: json['duration'],
      creatorId: json['creatorId']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'media': media,
        'duration': duration,
        'creatorId': creatorId
      };

  Story toEntity() {
    MediaType mediaType = MediaType.values.firstWhere((e) => e.toString().toLowerCase() == 'MediaType.$media', orElse: () => MediaType.image);
    Duration duration = Duration(seconds: this.duration as int);
    return Story(
      id,
      url!,
      mediaType,
      duration,
      creatorId!
    );
  }
}
