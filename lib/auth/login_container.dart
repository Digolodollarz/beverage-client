import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/auth/auth_actions.dart';
import 'package:beverage_app/auth/auth_models.dart';
import 'package:beverage_app/auth/widgets/carousel_widget.dart';
import 'package:beverage_app/auth/widgets/login_form.dart';
import 'package:beverage_app/auth/widgets/reset_form.dart';
import 'package:beverage_app/auth/widgets/signup_form.dart';
import 'package:redux/redux.dart';

class LoginPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (_, _ViewModel vm) => LoginPage(vm: vm),
    );
  }
}

class LoginPage extends StatelessWidget {
  final _ViewModel vm;

  const LoginPage({Key key, this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Beverage',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.display2.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            Expanded(
              child: LoginForm(
                error: vm.error,
                loginCallback: vm.loginCallback,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewModel {
  final AppUser user;
  final dynamic error;
  final Function(UserForm, BuildContext) loginCallback;

  _ViewModel({
    this.user,
    this.loginCallback,
    this.error,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user,
      error: store.state.error,
      loginCallback: (UserForm user, BuildContext context) {
        store.dispatch(LogIn(user, context));
      },
    );
  }
}
