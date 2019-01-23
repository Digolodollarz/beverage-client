import 'package:beverage_app/chats/chats_actions.dart';
import 'package:beverage_app/chats/chats_models.dart';

chatsReducer(List<Chat> chats, action) {
  if (action is GetChatsSuccessful) {
    return action.chats;
  } else
    return chats;
}
