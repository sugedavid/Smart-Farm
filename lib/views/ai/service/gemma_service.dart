import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:smart_farm/data/models/message.dart';

class GemmaLocalService {
  Future<String?> processMessage(List<MessageModel> messages) {
    return FlutterGemmaPlugin.instance.getChatResponse(messages: messages);
  }

  Stream<String?> processMessageAsync(List<MessageModel> messages) {
    return FlutterGemmaPlugin.instance.getChatResponseAsync(messages: messages);
  }
}
