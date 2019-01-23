// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return ChatMessage(
      senderId: json['senderId'] as int,
      chatId: json['chatId'] as int,
      senderEmail: json['senderEmail'] as String,
      text: json['text'] as String,
      attachmentUrl: json['attachmentUrl'] as String,
      attachmentThumbnail: json['attachmentThumbnail'] as String)
    ..id = json['id'] as int
    ..deliveryTime = json['deliveryTime'] == null
        ? null
        : DateTime.parse(json['deliveryTime'] as String)
    ..readTime = json['readTime'] == null
        ? null
        : DateTime.parse(json['readTime'] as String)
    ..sentTime = json['sentTime'] as int;
}

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('chatId', instance.chatId);
  writeNotNull('senderId', instance.senderId);
  writeNotNull('senderEmail', instance.senderEmail);
  writeNotNull('text', instance.text);
  writeNotNull('attachmentUrl', instance.attachmentUrl);
  writeNotNull('attachmentThumbnail', instance.attachmentThumbnail);
  writeNotNull('deliveryTime', instance.deliveryTime?.toIso8601String());
  writeNotNull('readTime', instance.readTime?.toIso8601String());
  writeNotNull('sentTime', instance.sentTime);
  return val;
}

Chat _$ChatFromJson(Map<String, dynamic> json) {
  return Chat(
      id: json['id'] as int,
      users: (json['users'] as List)
          ?.map((e) =>
              e == null ? null : AppUser.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      messages: json['messages'] == null
          ? null
          : ChatMessagesPage.fromJson(json['messages'] as Map<String, dynamic>),
      lastMessage: json['lastMessage'] == null
          ? null
          : ChatMessage.fromJson(json['lastMessage'] as Map<String, dynamic>),
      isGroup: json['isGroup'] as bool);
}

Map<String, dynamic> _$ChatToJson(Chat instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('users', instance.users);
  writeNotNull('messages', instance.messages);
  writeNotNull('lastMessage', instance.lastMessage);
  writeNotNull('isGroup', instance.isGroup);
  return val;
}

ChatMessagesPage _$ChatMessagesPageFromJson(Map<String, dynamic> json) {
  return ChatMessagesPage(
      content: (json['content'] as List)
          ?.map((e) => e == null
              ? null
              : ChatMessage.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      last: json['last'] as bool,
      totalPages: json['totalPages'] as int,
      totalElements: json['totalElements'] as int,
      sort: json['sort'],
      first: json['first'] as bool,
      numberOfElements: json['numberOfElements'] as int,
      size: json['size'] as int,
      number: json['number'] as int);
}

Map<String, dynamic> _$ChatMessagesPageToJson(ChatMessagesPage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('content', instance.content);
  writeNotNull('last', instance.last);
  writeNotNull('totalPages', instance.totalPages);
  writeNotNull('totalElements', instance.totalElements);
  writeNotNull('sort', instance.sort);
  writeNotNull('first', instance.first);
  writeNotNull('numberOfElements', instance.numberOfElements);
  writeNotNull('size', instance.size);
  writeNotNull('number', instance.number);
  return val;
}

ChatMessageForm _$ChatMessageFormFromJson(Map<String, dynamic> json) {
  return ChatMessageForm(
      text: json['text'] as String,
      attachments: json['attachments'] as List,
      recipientChatId: json['recipientChatId'] as String,
      recipientUsername: json['recipientUsername'] as String);
}

Map<String, dynamic> _$ChatMessageFormToJson(ChatMessageForm instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('text', instance.text);
  writeNotNull('attachments', instance.attachments);
  writeNotNull('recipientChatId', instance.recipientChatId);
  writeNotNull('recipientUsername', instance.recipientUsername);
  return val;
}
