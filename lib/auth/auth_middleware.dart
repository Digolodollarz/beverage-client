//import 'dart:_http';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:beverage_app/api_endpoints.dart';
import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/auth/auth_actions.dart';
import 'package:beverage_app/auth/auth_models.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

List<Middleware<AppState>> createAuthMiddleware() {
  final logIn = _createLogInMiddleware();
  final logOut = _createLogOutMiddleware();

  // Built in redux method that tells your store that these
  // are middleware methods.
  //
  // As the app grows, we can add more Auth related middleware
  // here.
  return [
    new TypedMiddleware<AppState, LogIn>(logIn),
    new TypedMiddleware<AppState, LogOut>(logOut),
    new TypedMiddleware<AppState, Signup>(_createSignupMiddleware()),
    new TypedMiddleware<AppState, RequestReset>(_createRequestResetMiddleware()),
    new TypedMiddleware<AppState, Reset>(_createResetMiddleware()),
  ];
}

Middleware<AppState> _createLogInMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is LogIn) {
      try {
        print(json.encode(action.form.toJson()));
        print("fetchin resp");
        _showLoadingDialog(action.context);
        var response = await http.post('$apiUrl/auth/login',
            body: json.encode(action.form.toJson()),
            headers: {'Content-type': 'application/json'});
        final Map<String, dynamic> loginResponse = json.decode(response.body);
        if (response.statusCode == 401 || loginResponse['status'] == '401') {
          print("error ${loginResponse['error']}");
          Navigator.of(action.context).pop();

          if (loginResponse['exception']
              .toString()
              .contains("BadCredentials")) {
            simpleSnack(action.context, "Wrong username or password");
          }
          store.dispatch(LoginFail(loginResponse));
        } else if (loginResponse['token'] != null) {
          final token = loginResponse['token'];
          print("fetchin resp");
          response = await http.get('$apiUrl/user', headers: {
            'Authorization': 'Bearer $token',
          });
          final Map<String, dynamic> userResponse = json.decode(response.body);
          final user = AppUser.fromJson(userResponse);
          user.authToken = token;

          Navigator.of(action.context).pop();

          store.dispatch(LoginSuccessful(user: user, token: token));
        } else {
          print(loginResponse);
          simpleSnack(action.context, "${loginResponse['message']}");
          Navigator.of(action.context).pop();
        }
      } on Exception catch (error) {
        store.dispatch(LoginFail(error));
      }
    }
    next(action);
  };
}

_showLoadingDialog(BuildContext context, {text = "Please Wait"}) {
  showDialog(
    context: context,
    builder: (_) => new AlertDialog(
          title: new Text(text),
          content: CircularProgressIndicator(),
        ),
  );
}

simpleSnack(BuildContext context, String text, {Function action}) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}

Middleware<AppState> _createLogOutMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    // YOUR LOGIC HERE
    if (action is LogOut) {
      try {
        store.dispatch(LogOutSuccessful());
      } on Exception catch (error) {
        print(error);
      }
    }

    next(action);
  };
}

Middleware<AppState> _createSignupMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    if (action is Signup) {
      _showLoadingDialog(action.context, text: "Creating account");
      try {
        print(json.encode(action.form.toJson()));
        var response = await http.post('$apiUrl/auth/register',
            body: json.encode(action.form.toJson()),
            headers: {'Content-type': 'application/json'});
        final Map<String, dynamic> signupResponse = json.decode(response.body);
        print(signupResponse);

        if (response.statusCode == 401 || signupResponse['status'] == '401') {
          print(signupResponse['error']);
          simpleSnack(action.context, "Error creating user");
          Navigator.of(action.context).pop();
          store.dispatch(LoginFail(signupResponse));
        } else if (response.statusCode == 201 || response.statusCode == 200) {
          simpleSnack(action.context, "User created, please log in");
          Navigator.of(action.context).pop();
          store.dispatch(SignupSuccessful());
        } else {
          simpleSnack(action.context, "${signupResponse['message']}");
          Navigator.of(action.context).pop();
        }
      } on Exception catch (error) {
        Navigator.of(action.context).pop();
        store.dispatch(LoginFail(error));
      }
    }
    next(action);
  };
}

Middleware<AppState> _createRequestResetMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    if (action is RequestReset) {
      _showLoadingDialog(action.context, text: "Requesting Reset");
      try {
        var response = await http.post('$apiUrl/auth/reset/request',
            body: json.encode(action.form.toJson()),
            headers: {'Content-type': 'application/json'});

        final Map<String, dynamic> signupResponse = json.decode(response.body);

        if (response.statusCode == 401 || signupResponse['status'] == '401') {
          print(signupResponse['error']);
          simpleSnack(action.context, "Error sending email");
          Navigator.of(action.context).pop();
          store.dispatch(LoginFail(signupResponse));
        } else if (response.statusCode == 201 || response.statusCode == 200) {
          simpleSnack(action.context, "Reset email sent. Expires soon");
          Navigator.of(action.context).pop();
          print(signupResponse);
          store.dispatch(RequestResetSuccessful());
        } else {
          simpleSnack(action.context, "${signupResponse['message']}");
          Navigator.of(action.context).pop();
        }
      } on Exception catch (error) {
        Navigator.of(action.context).pop();
        store.dispatch(LoginFail(error));
      }
    }
    next(action);
  };
}
Middleware<AppState> _createResetMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    if (action is Reset){
      _showLoadingDialog(action.context, text: "Updating password");
      try {
        print("FOrm ${action.form.toJson()}");
        var response = await http.post('$apiUrl/auth/reset/update',
            body: json.encode(action.form.toJson()),
            headers: {'Content-type': 'application/json'});

        final Map<String, dynamic> signupResponse = json.decode(response.body);

        if (response.statusCode == 401 || signupResponse['status'] == '401') {
          print(signupResponse['error']);
          simpleSnack(action.context, "Error ${signupResponse['message']}");
          Navigator.of(action.context).pop();
          store.dispatch(LoginFail(signupResponse));
        } else if (response.statusCode == 201 || response.statusCode == 200) {
          simpleSnack(action.context, "Reset successful, log in now");
          Navigator.of(action.context).pop();
          print(signupResponse);
          store.dispatch(RequestResetSuccessful());
        } else {
          print(signupResponse);
          simpleSnack(action.context, "${signupResponse['message']}");
          Navigator.of(action.context).pop();
        }
      } on Exception catch (error) {
        Navigator.of(action.context).pop();
        store.dispatch(LoginFail(error));
      }
    }
    next(action);
  };
}
