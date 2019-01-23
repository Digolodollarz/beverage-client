import 'package:beverage_app/payments/payments_models.dart';

class MakePayment {
  PaymentRequest request;

  MakePayment(this.request);

}

class MakePaymentSuccessful {
  Payment payment;
}

class GetPayment {
  String reference;
}

class GetPaymentSuccessful {
  Payment payment;
}

class GetPayments {}

class GetPaymentsSuccessful {
  List<Payment> payments;
}
