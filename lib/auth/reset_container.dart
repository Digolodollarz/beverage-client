import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/auth/auth_actions.dart';
import 'package:beverage_app/auth/auth_models.dart';
import 'package:beverage_app/auth/widgets/reset_form.dart';

class ResetPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (_, _vm) => ResetPage(vm: _vm),
    );
  }
}

class ResetPage extends StatelessWidget {
  final _ViewModel vm;

  const ResetPage({Key key, this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ResetForm(
          error: vm.error,
        ),
      ),
    );
  }
}

class _ViewModel {
  final AppUser user;
  final dynamic error;
  final Function(UserForm, BuildContext) resetCallback;
  final Function(UserForm, BuildContext) requestResetCallback;

  _ViewModel({
    this.user,
    this.resetCallback,
    this.requestResetCallback,
    this.error,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user,
      error: store.state.error,
      requestResetCallback: (UserForm user, BuildContext context) {
        store.dispatch(RequestReset(user, context));
      },
      resetCallback: (UserForm user, BuildContext context) {
        store.dispatch(Reset(user, context));
      },
    );
  }
}
