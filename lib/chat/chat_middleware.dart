import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:beverage_app/api_endpoints.dart';
import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/auth/auth_actions.dart';
import 'package:beverage_app/chat/chat_actions.dart';
import 'package:beverage_app/chats/chats_models.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createChatMiddleware() {
  return [
    new TypedMiddleware<AppState, GetChat>(_createGetChatMiddleware()),
    new TypedMiddleware<AppState, PostChatMessage>(_createPostChatMessageMiddleware()),
  ];
}

Middleware<AppState> _createGetChatMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is GetChat) {
      try {
        var response = await http.get('$apiUrl/chats/${action.id}', headers: {
          'Authorization': 'Bearer ${store.state.user.authToken}',
        });
        final dynamic chatResponse = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          print("Chat Pons $chatResponse");
          final chat = Chat.fromJson(chatResponse);
          print('Chat $chat');
          store.dispatch(GetChatSuccessful(chat));
        } else if (response.statusCode == 401) {
          store.dispatch(LoginFail(chatResponse['message']));
        } else {
          print('Sum Ting Wong $chatResponse');
          store.dispatch(GetChatError(chatResponse['message']));
        }
      } on Exception catch (error) {
        store.dispatch(LoginFail(error));
      }
    }
    next(action);
  };
}

Middleware<AppState> _createPostChatMessageMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is PostChatMessage) {
      try {
        var response = await http.post('$apiUrl/chats',
            body: json.encode(action.form.toJson()),
            headers: {
              'Content-type': 'application/json',
              'Authorization': 'Bearer ${store.state.user.authToken}',
            });
        final dynamic chatResponse = json.decode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Message posted');
          store.dispatch(PostChatMessageSuccessful());
        } else if (response.statusCode == 401) {
          store.dispatch(LoginFail(chatResponse['message']));
        } else {
          print('Sum Ting Wong $chatResponse');
          store.dispatch(GetChatError(chatResponse['message']));
        }
      } on Exception catch (error) {
        store.dispatch(LoginFail(error));
      }
    }
    next(action);
  };
}
