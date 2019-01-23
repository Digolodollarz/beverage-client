import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/auth/user_reducer.dart';
import 'package:beverage_app/chat/chat_reducer.dart';
import 'package:beverage_app/chats/chats_reducer.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    isLoading: false,
    user: userReducer(state.user, action),
    chats: chatsReducer(state.chats, action),
    currentChat: currentChatReducer(state.currentChat, action),
  );
}
