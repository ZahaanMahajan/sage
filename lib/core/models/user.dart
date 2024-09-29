import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String age;
  final String uid;
  final String email;
  final String username;
  final String profession;
  final bool hadCounsellingBefore;

  const UserModel({
    required this.age,
    required this.uid,
    required this.email,
    required this.username,
    required this.profession,
    required this.hadCounsellingBefore,
  });

  @override
  List<Object?> get props =>
      [age, uid, email, username, profession, hadCounsellingBefore];
}
