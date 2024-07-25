import 'package:flutter_gemma/core/message.dart';

class MessageModel extends Message {
  const MessageModel({required super.text, super.isUser});

  // convert to a Map
  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
      };

  // create from a Map
  static MessageModel fromJson(Map<String, dynamic> json) => MessageModel(
        text: json['text'],
        isUser: json['isUser'],
      );
}
