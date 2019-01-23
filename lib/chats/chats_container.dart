import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:beverage_app/api_endpoints.dart';
import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/auth/auth_models.dart';
import 'package:beverage_app/chat/chat_actions.dart';
import 'package:beverage_app/chat/chat_container.dart';
import 'package:beverage_app/chats/chats_actions.dart';
import 'package:beverage_app/chats/chats_models.dart';
import 'package:redux/redux.dart';

class ChatsPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return ChatsPage(vm: vm);
      },
    );
  }
}

class _ViewModel {
  final AppUser user;
  final List<Chat> chats;
  final Function(int) loadChatCallback;

  _ViewModel({this.user, this.chats, this.loadChatCallback});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      user: store.state.user,
      chats: store.state.chats,
      loadChatCallback: (int id) => store.dispatch(GetChat(id)),
    );
  }
}

class ChatsPage extends StatefulWidget {
  final _ViewModel vm;

  const ChatsPage({Key key, this.vm}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ChatList(
                userId: widget.vm.user.id,
                chats: widget.vm.chats,
                loadCallback: widget.vm.loadChatCallback,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _getChats() async {
    try {
      var response = await http.get('$apiUrl/chats', headers: {
        'Authorization': 'Bearer ${widget.vm.user.authToken}',
      });
      final List<dynamic> chatsResponse = json.decode(response.body);
      final chatList =
          chatsResponse.map((chat) => Chat.fromJson(chat)).toList();
      return chatList;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

class ChatList extends StatelessWidget {
  final int userId;
  final List<Chat> chats;
  final Function(int) loadCallback;

  const ChatList({Key key, this.chats, this.userId, this.loadCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final partner =
            chats[index].users.firstWhere((user) => user.id != userId);
        return ChatListItem(
          chatName: partner.firstname + partner.lastname,
          lastMessage: chats[index].lastMessage,
          selectCallback: () {
            loadCallback(chats[index].id);
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return ChatPageContainer(
                  chat: chats[index],
                );
              },
            ));
          },
        );
      },
      itemCount: chats?.length ?? 0,
    );
  }
}

class ChatListItem extends StatelessWidget {
  final Function selectCallback;
  final String chatName;
  final ChatMessage lastMessage;

  const ChatListItem({
    Key key,
    this.selectCallback,
    this.chatName,
    this.lastMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: ListTile(
        onTap: selectCallback,
        title: Text(chatName),
        subtitle: Text(lastMessage.text),
      ),
    );
  }
}
