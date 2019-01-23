// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserForm _$UserFormFromJson(Map<String, dynamic> json) {
  return UserForm(
      userName: json['userName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      token: json['token'] as String)
    ..username = json['username'] as String
    ..firstname = json['firstname'] as String
    ..lastname = json['lastname'] as String
    ..newPassword = json['newPassword'] as String;
}

Map<String, dynamic> _$UserFormToJson(UserForm instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('userName', instance.userName);
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  writeNotNull('confirmPassword', instance.confirmPassword);
  writeNotNull('firstName', instance.firstName);
  writeNotNull('lastName', instance.lastName);
  writeNotNull('token', instance.token);
  writeNotNull('username', instance.username);
  writeNotNull('firstname', instance.firstname);
  writeNotNull('lastname', instance.lastname);
  writeNotNull('newPassword', instance.newPassword);
  return val;
}

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return AppUser(
      id: json['id'] as int,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      email: json['email'] as String)
    ..authToken = json['authToken'] as String;
}

Map<String, dynamic> _$AppUserToJson(AppUser instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('firstname', instance.firstname);
  writeNotNull('lastname', instance.lastname);
  writeNotNull('email', instance.email);
  writeNotNull('authToken', instance.authToken);
  return val;
}
