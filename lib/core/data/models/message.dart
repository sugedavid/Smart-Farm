import 'package:flutter_gemma/core/message.dart';

class MessageModel extends Message {
  const MessageModel({required super.text, super.isUser, required this.time});

  final String time;

  // convert to a Map
  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'time': time,
      };

  // create from a Map
  static MessageModel fromJson(Map<String, dynamic> json) => MessageModel(
        text: json['text'],
        isUser: json['isUser'],
        time: json['time'] ?? '',
      );
}
