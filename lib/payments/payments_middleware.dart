import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/payments/payments_actions.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createPaymentMiddleware() {
  return [
    TypedMiddleware<AppState, GetPayment>(_getPaymentMiddleware()),
    TypedMiddleware<AppState, GetPayment>(_makePaymentMiddleware())
  ];
}

Middleware<AppState> _getPaymentMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    if (action is GetPayment) {}
    next(action);
  };
}

Middleware<AppState> _makePaymentMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    if (action is MakePayment) {
      print('Pano');
      action.request.items.forEach((k, v) => print('$k $v'));
    }
    next(action);
  };
}
