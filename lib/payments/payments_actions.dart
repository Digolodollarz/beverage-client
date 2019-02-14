import 'package:beverage_app/payments/payments_models.dart';
import 'package:flutter/cupertino.dart';

class MakePayment {
  PaymentRequest request;
  BuildContext context;

  MakePayment(
    this.request,
    this.context,
  );
}

class LoadPayments {
  final BuildContext context;

  LoadPayments({this.context});
}

class LoadPaymentsSuccessful {
  List<Payment> payments;

  LoadPaymentsSuccessful({this.payments});
}

class MakePaymentSuccessful {
  final PaymentRequest payment;

  MakePaymentSuccessful(this.payment);
}

class GetPayment {
  String reference;
}

class GetPaymentSuccessful {
  Payment payment;
}
