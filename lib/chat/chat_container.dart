import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:beverage_app/api_endpoints.dart';
import 'package:beverage_app/app_state.dart';
import 'package:beverage_app/auth/auth_models.dart';
import 'package:beverage_app/chat/chat_actions.dart';
import 'package:beverage_app/chats/chats_models.dart';
import 'package:beverage_app/chats/widgets/chat_list_item.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

class ChatPageContainer extends StatelessWidget {
  final chat;

  const ChatPageContainer({Key key, this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) => ChatPage(
            vm: vm,
            chat: chat,
          ),
    );
  }
}

class _ViewModel {
  final AppUser user;
  final Chat chat;
  final Function getChat;

  _ViewModel({this.user, this.chat, this.getChat});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        user: store.state.user,
        chat: store.state.currentChat,
        getChat: () => store.dispatch(GetChat(store.state.currentChat.id)));
  }
}

class ChatPage extends StatefulWidget {
  final _ViewModel vm;
  final Chat chat;

  const ChatPage({Key key, this.vm, this.chat}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController newMessageController = TextEditingController();
  final _chatScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Le Chat'),
      ),
      body: Container(
        color: Colors.blueGrey[100],
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: _getChat(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      controller: _chatScrollController,
                      itemBuilder: (BuildContext context, int index) {
                        final partner = widget.chat.users
                            .firstWhere((user) => user.id != widget.vm.user.id);
                        return ChatMessageItem(
                            snapshot.data.messages.content[index],
                            widget.vm.user.id);
                      },
                      itemCount: snapshot.data.messages.totalElements,
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error');
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(4.0),
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: new ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 80.0,
                      ),
                      child: new Scrollbar(
                        child: new SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          reverse: true,
                          child: new TextField(
                            decoration:
                                _inputDecoration('Enter your message...'),
                            maxLines: null,
                            controller: newMessageController,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _postMessage();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Chat> _getChat() async {
    try {
      var response =
          await http.get('$apiUrl/chats/${widget.chat.id}', headers: {
        'Authorization': 'Bearer ${widget.vm.user.authToken}',
      });
      final dynamic chatsResponse = json.decode(response.body);
      print("Chat Pons $chatsResponse");
//    final user = AppUser.fromJson(chatsResponse);
      final chat = Chat.fromJson(chatsResponse);
      print('Chat $chat');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
      return chat;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future _postMessage() async {
    print('Pano');
    if (newMessageController.text.isEmpty) return;
    var text = newMessageController.text;
    newMessageController.clear();
    var response = await http.post('$apiUrl/chats',
        body: json.encode({
          "text": text,
          "recipientChatId": widget.chat.id,
        }),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${widget.vm.user.authToken}',
        });
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      setState(() {
        var scrollPosition = _chatScrollController.position;
        if (scrollPosition.viewportDimension < scrollPosition.maxScrollExtent) {
          _chatScrollController.animateTo(
            scrollPosition.maxScrollExtent,
            duration: new Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
          print('Should have scrolled to ${scrollPosition.maxScrollExtent}');
        }
      });
    } else
      print(response.statusCode);
  }
}

InputDecoration _inputDecoration(final String text) {
  return InputDecoration(
    hintText: text,
    filled: false,
    fillColor: const Color(0x33ffffff),
    border: InputBorder.none,
  );
}
