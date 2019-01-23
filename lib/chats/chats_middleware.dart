import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:beverage_app/api_endpoints.dart';
import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/auth/auth_actions.dart';
import 'package:beverage_app/chat/chat_actions.dart';
import 'package:beverage_app/chats/chats_actions.dart';
import 'package:beverage_app/chats/chats_models.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createChatsMiddleware() {
  return [
    new TypedMiddleware<AppState, GetChats>(_createGetChatsMiddleware()),
  ];
}

Middleware<AppState> _createGetChatsMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is GetChats) {
      print('We are getting chats from server');
      try {
        var response = await http.get('$apiUrl/chats', headers: {
          'Authorization': 'Bearer ${store.state.user.authToken}',
        });
        final dynamic chatResponse = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final List<dynamic> chatsResponse = json.decode(response.body);
          final chatList =
              chatsResponse.map((chat) => Chat.fromJson(chat)).toList();
          print('Chats retrieved from server');
          store.dispatch(GetChatsSuccessful(chatList));
        } else if (response.statusCode == 401) {
          store.dispatch(LoginFail(chatResponse['message']));
        } else {
          print('Sum Ting Wong $chatResponse');
          store.dispatch(GetChatsError(chatResponse['message']));
        }
      } on Exception catch (error) {
        store.dispatch(GetChatsError(error));
      }
    }
    next(action);
  };
}
