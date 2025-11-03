import 'package:uuid/uuid.dart';

const uid = Uuid();

class BaseAppUser {
  BaseAppUser({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
  }) : uuid = uid.v4(),
       createdDate = DateTime.now().toIso8601String();

  BaseAppUser.fromData({
    required this.uuid,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.createdDate,
  });

  final String uuid;
  final String createdDate;
  final String username;
  final String password;
  final String firstName;
  final String lastName;

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'createdDate': createdDate,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory BaseAppUser.fromJson(Map<String, dynamic> json) {
    return BaseAppUser.fromData(
      uuid: json['uuid'] ?? uid.v4(),
      createdDate: json['createdDate'] ?? DateTime.now().toIso8601String(),
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}
