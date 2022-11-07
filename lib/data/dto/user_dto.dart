import 'package:src/domain/entities/user.dart';

class UserDTO {
  UserDTO({required this.id, this.name, this.profileImageUrl});

  int id;
  String? name;
  String? profileImageUrl;

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
      id: json['id'], name: json['name'], profileImageUrl: json['profile']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'profile': profileImageUrl};

  User toEntity() => User(id, name!, profileImageUrl!);
}
