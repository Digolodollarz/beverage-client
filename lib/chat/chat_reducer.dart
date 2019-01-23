import 'package:beverage_app/chat/chat_actions.dart';
import 'package:beverage_app/chats/chats_models.dart';

currentChatReducer(Chat chat, action) {
  if (action is GetChatSuccessful) {
    return action.chat;
  } else
    return chat;
}

