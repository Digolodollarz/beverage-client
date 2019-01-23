import 'package:flutter/material.dart';
import 'package:beverage_app/chats/chats_models.dart';
import 'package:intl/intl.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage _message;
  final int userId;

  ChatMessageItem(this._message, this.userId);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
//          ImageIcon(AssetImage('')),
          Visibility(
            visible: userId != _message.senderId,
            child: Icon(Icons.person_outline),
            replacement: Expanded(child: Container()),
          ),
          Column(
            children: <Widget>[
              Text(
                '${DateFormat('HH:mm').format(_message.timeSent())}',
                style: Theme.of(context).textTheme.body1.copyWith(
                      fontSize: 11.0,
                    ),
              ),
              Card(
                color: userId == _message.senderId
                    ? Colors.white10
                    : Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                    bottomRight:
                        Radius.circular(userId == _message.senderId ? 0 : 16.0),
                    bottomLeft:
                        Radius.circular(userId == _message.senderId ? 16.0 : 0),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    _message.text,
                    style: Theme.of(context).textTheme.body1.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
