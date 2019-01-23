import 'package:json_annotation/json_annotation.dart';
import 'package:beverage_app/auth/auth_models.dart';

part 'chats_models.g.dart';

@JsonSerializable(includeIfNull: false)
class ChatMessage {
  int id;
  int chatId;
  int senderId;
  String senderEmail;
  String text;
  String attachmentUrl;
  String attachmentThumbnail;

  DateTime _sentTime;
  DateTime deliveryTime;
  DateTime readTime;

  set sentTime(int timestamp) =>
      this._sentTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

  int get sentTime => this._sentTime.millisecondsSinceEpoch;

  ChatMessage({
    this.senderId,
    this.chatId,
    this.senderEmail,
    this.text,
    this.attachmentUrl,
    this.attachmentThumbnail,
  });

  DateTime timeSent() => _sentTime;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Chat {
  int id;
  List<AppUser> users;
  ChatMessagesPage messages;
  ChatMessage lastMessage;
  bool isGroup;

  Chat({
    this.id,
    this.users,
    this.messages,
    this.lastMessage,
    this.isGroup,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

@JsonSerializable(includeIfNull: false)
class ChatMessagesPage {
  List<ChatMessage> content;
  bool last;
  int totalPages;
  int totalElements;
  dynamic sort;
  bool first;
  int numberOfElements;
  int size;
  int number;

  ChatMessagesPage(
      {this.content,
      this.last,
      this.totalPages,
      this.totalElements,
      this.sort,
      this.first,
      this.numberOfElements,
      this.size,
      this.number});

  factory ChatMessagesPage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessagesPageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessagesPageToJson(this);
}

@JsonSerializable(includeIfNull: false)
class ChatMessageForm {
  String text;
  List<dynamic> attachments;
  String recipientChatId;
  String recipientUsername;

  ChatMessageForm(
      {this.text,
      this.attachments,
      this.recipientChatId,
      this.recipientUsername});

  factory ChatMessageForm.fromJson(json) => _$ChatMessageFormFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageFormToJson(this);
}

//List<ChatMessage> getSampleMessages() {
//  return <ChatMessage>[
//    ChatMessage(senderId: '1', text: 'Madii Chibaba'),
//    ChatMessage(senderId: '2', text: 'Nyanyirosi wadii'),
//    ChatMessage(
//        senderId: '1',
//        text: 'Ndiri baba vako. Ndini ndakaita uvepo pano iwe. '
//            'kana une nharo ndokuendesa.'),
//    ChatMessage(senderId: '1', text: 'Unozviziva wani'),
//    ChatMessage(senderId: '2', text: 'Haa tozvidira jecha zve'),
//  ];
//}
