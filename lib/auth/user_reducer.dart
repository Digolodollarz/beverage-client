import 'package:beverage_app/auth/auth_actions.dart';
import 'package:beverage_app/auth/auth_models.dart';

/// User Reducer accepts login/out action and sets the user appropriately on
/// the scope. If the user logged out, the user is set to null.
/// For @class LoginAction, the user is passed as part of the action.
userReducer(AppUser user, action) {
//  return authReducer;
  if (action is LoginSuccessful) {
    return action.user;
  } else if (action is LogOut) {
    return null;
  } else {
    return user;
  }
}

