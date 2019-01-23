import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/auth/auth_actions.dart';
import 'package:beverage_app/auth/auth_models.dart';
import 'package:beverage_app/auth/widgets/signup_form.dart';

class SignUpPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (_, _vm) => SignUpPage(vm: _vm),
    );
  }
}

class SignUpPage extends StatelessWidget {
  final _ViewModel vm;

  const SignUpPage({Key key, this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SignupForm(
          error: vm.error,
          signupCallback: vm.signupCallback,
        ),
      ),
    );
  }
}

class _ViewModel {
  final AppUser user;
  final dynamic error;
  final Function(UserForm, BuildContext) signupCallback;

  _ViewModel({
    this.user,
    this.signupCallback,
    this.error,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user,
      error: store.state.error,
      signupCallback: (UserForm user, BuildContext context) {
        store.dispatch(Signup(user, context));
      },
    );
  }
}
