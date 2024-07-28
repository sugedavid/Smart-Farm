import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_farm/data/models/message.dart';

class ChatManager {
  static const String _chatKey = 'chat';
  static const String gemmaChatKey = '${_chatKey}_gemma_chat';
  static const String geminiChatKey = '${_chatKey}_gemini_chat';

  // save chat
  Future<void> saveChat(String key, MessageModel message) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedMessages = prefs.getStringList(key) ?? <String>[];
    savedMessages.add(json.encode(message.toJson()));

    prefs.setStringList(key, savedMessages);
  }

  // delete chats
  Future<void> deleteChat(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  // get chats
  Future<List<MessageModel>> getChat(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedMessages = prefs.getStringList(key) ?? [];
    return savedMessages
        .map((jsonString) => MessageModel.fromJson(json.decode(jsonString)))
        .toList();
  }
}
