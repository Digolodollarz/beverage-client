import 'package:beverage_app/auth/auth_models.dart';
import 'package:beverage_app/chats/chats_models.dart';
import 'package:beverage_app/payments/payments_models.dart';

class AppState {
  final AppUser user;
  final bool isLoading;
  final dynamic error;
  final Payment currentPayment;
  final List<Payment> currentPayments;
  final Chat currentChat;
  final List<Chat> chats;
  final String ecocashPhone;

  AppState(
      {this.user,
      this.isLoading,
      this.error,
      this.currentPayment,
      this.currentPayments,
      this.currentChat,
      this.chats,
      this.ecocashPhone});

  AppState copyWith({
    bool isLoading,
    AppUser user,
    error,
    currentPayment,
    currentPayments,
    currentChat,
    chats,
    ecocashPhone,
  }) {
    return new AppState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
      currentPayment: currentPayment ?? this.currentPayment,
      currentPayments: currentPayments ?? this.currentPayments,
      currentChat: currentChat ?? this.currentChat,
      chats: chats ?? this.chats,
      ecocashPhone: ecocashPhone ?? this.ecocashPhone,
    );
  }

  static AppState fromJson(dynamic json) {
    if (json == null) return AppState();
    return AppState(
      user: json['user'] != null ? AppUser.fromJson(json['user']) : null,
      ecocashPhone: json['ecocashPhone'],
    );
  }

  dynamic toJson() {
    return {
      'user': user?.toJson(),
      'ecocashPhone': ecocashPhone,
    };
  }

  @override
  String toString() {
    return "AppState ${isLoading ? 'loading' : 'loaded'}";
  }
}
