import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_farm/data/models/message.dart';

class ChatManager {
  static const String _chatKey = 'chat';
  static const String _gemmaChatKey = '${_chatKey}_gemma_chat';
  static const String _geminiChatKey = '${_chatKey}_gemini_chat';

  // save chat
  Future<void> saveChat(MessageModel message) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedMessages =
        prefs.getStringList(_gemmaChatKey) ?? <String>[];
    savedMessages.add(json.encode(message.toJson()));

    prefs.setStringList(_gemmaChatKey, savedMessages);
  }

  // delete chats
  Future<void> deleteChats() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_gemmaChatKey);
  }

  // get chats
  Future<List<MessageModel>> getChats() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedMessages = prefs.getStringList(_gemmaChatKey) ?? [];
    return savedMessages
        .map((jsonString) => MessageModel.fromJson(json.decode(jsonString)))
        .toList();
  }
}
