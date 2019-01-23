import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@JsonSerializable(includeIfNull: false)
class UserForm {
  String userName;
  String email;
  String password;
  String confirmPassword;
  String firstName;
  String lastName;
  String token;

  set username(username) {}

  String get username => email;

  set firstname(username) {}

  String get firstname => firstName;

  set lastname(username){}

  String get lastname => lastName;

  set newPassword(pwd) {}

  String get newPassword => password;

  UserForm(
      {this.userName,
      this.email,
      this.password,
      this.confirmPassword,
      this.firstName,
      this.lastName,
      this.token});

  factory UserForm.fromJson(Map<String, dynamic> json) =>
      _$UserFormFromJson(json);

  Map<String, dynamic> toJson() => _$UserFormToJson(this);

  @override
  String toString() {
    return "UserForm username:$userName email:$email "
        "firstName:$firstName lastName$lastName";
  }
}

//TODO: Rename to camelCase
@JsonSerializable(includeIfNull: false)
class AppUser {
  int id;
  String firstname;
  String lastname;
  String email;
  String authToken;

  AppUser({this.id, this.firstname, this.lastname, this.email});

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  @override
  String toString() {
    return 'AppUser firstName:$firstname lastName:$lastname';
  }
}

class Validators {
  static bool email(String email) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return email != null && regex.hasMatch(email);
  }
}
