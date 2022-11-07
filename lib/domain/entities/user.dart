import 'package:equatable/equatable.dart';

class User extends Equatable{
  final int id;
  final String name;
  final String profileImageUrl;

  const User(this.id, this.name, this.profileImageUrl);

  @override
  List<Object?> get props => [id, name];
}
