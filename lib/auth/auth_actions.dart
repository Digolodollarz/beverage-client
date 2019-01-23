import 'package:flutter/material.dart';
import 'package:beverage_app/auth/auth_models.dart';

class LogIn {
  final UserForm form;
  final BuildContext context;

  LogIn(this.form, this.context);
}

class LoginSuccessful {
  final AppUser user;
  final String token;

  LoginSuccessful({this.user, this.token});

  @override
  String toString() {
    return "Logged in ${this.user}";
  }
}

class LoginFail {
  final dynamic error;

  LoginFail(this.error);

  @override
  String toString() {
    return "There was an error loggin in $error";
  }
}

class LogOut {}

class LogOutSuccessful {
  LogOutSuccessful();

  @override
  String toString() {
    return 'LogOut{user: null}';
  }
}

class RequestReset {
  final UserForm form;
  final BuildContext context;

  RequestReset(this.form, this.context);
}

class Reset {
  final UserForm form;
  final BuildContext context;

  Reset(this.form, this.context);
}

class RequestResetSuccessful {}
class ResetSuccessful {}

class Signup {
  final UserForm form;
  final BuildContext context;

  Signup(this.form, this.context);
}

class SignupSuccessful {}
