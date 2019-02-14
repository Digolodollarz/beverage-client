// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment(
      id: json['id'] as int,
      user: json['user'] == null
          ? null
          : AppUser.fromJson(json['user'] as Map<String, dynamic>),
      reference: json['reference'] as String,
      pollUrl: json['pollUrl'] as String,
      link: json['link'] as String,
      instructions: json['instructions'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      amount: (json['amount'] as num)?.toDouble(),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      paid: json['paid'] as bool,
      datePaid: json['datePaid'] == null
          ? null
          : DateTime.parse(json['datePaid'] as String));
}

Map<String, dynamic> _$PaymentToJson(Payment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('user', instance.user);
  writeNotNull('reference', instance.reference);
  writeNotNull('pollUrl', instance.pollUrl);
  writeNotNull('link', instance.link);
  writeNotNull('instructions', instance.instructions);
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  writeNotNull('amount', instance.amount);
  writeNotNull('updatedAt', instance.updatedAt?.toIso8601String());
  writeNotNull('paid', instance.paid);
  writeNotNull('datePaid', instance.datePaid?.toIso8601String());
  return val;
}

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) {
  return PaymentRequest(
      user: json['user'] == null
          ? null
          : AppUser.fromJson(json['user'] as Map<String, dynamic>),
      items: (json['items'] as Map<String, dynamic>)
          ?.map((k, e) => MapEntry(k, (e as num)?.toDouble())),
      reference: json['reference'] as String,
      method: json['method'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String);
}

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user', instance.user);
  writeNotNull('items', instance.items);
  writeNotNull('reference', instance.reference);
  writeNotNull('method', instance.method);
  writeNotNull('email', instance.email);
  writeNotNull('phone', instance.phone);
  return val;
}
