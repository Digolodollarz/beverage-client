import 'package:beverage_app/auth/auth_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payments_models.g.dart';

@JsonSerializable(includeIfNull: false)
class Payment {
  int id;
  AppUser user;
  String reference;
  String pollUrl;
  String link;
  String instructions;
  DateTime createdAt;
  double amount;
  DateTime updatedAt;
  bool paid;
  DateTime datePaid;

  Payment(
      {this.id,
      this.user,
      this.reference,
      this.pollUrl,
      this.link,
      this.instructions,
      this.createdAt,
      this.amount,
      this.updatedAt,
      this.paid,
      this.datePaid});

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable(includeIfNull: false)
class PaymentRequest {
  AppUser user;
  Map<String, double> items;
  String reference;
  String method;
  String email;
  String phone;

  PaymentRequest({
    this.user,
    this.items,
    this.reference,
    this.method,
    this.email,
    this.phone,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}

enum PaymentStatus {
  PENDING,
  PAID,
  Created,
  Sent,
  Cancelled,
  Disputed,
  Refunded
}

enum PaymentMethod { ECOCASH, ONEWALLET, TELECASH, VISA }
