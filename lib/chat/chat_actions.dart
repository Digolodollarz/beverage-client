import 'package:beverage_app/chats/chats_models.dart';

class GetChat {
  final int id;

  GetChat(this.id);
}

class GetChatSuccessful {
  final Chat chat;

  GetChatSuccessful(this.chat);
}

class GetChatError {
  final dynamic error;

  GetChatError(this.error);
}

class PostChatMessage {
  ChatMessageForm form;
}

class PostChatMessageSuccessful {
  final ChatMessage message;

  PostChatMessageSuccessful({this.message});
}

class PostMessageError {
  final dynamic error;

  PostMessageError(this.error);
}
