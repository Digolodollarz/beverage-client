import 'package:beverage_app/chats/chats_models.dart';

class GetChats {}

class GetChatsSuccessful {
  final List<Chat> chats;

  GetChatsSuccessful(this.chats);
}

class GetChatsError {
  final dynamic error;

  GetChatsError(this.error);
}
