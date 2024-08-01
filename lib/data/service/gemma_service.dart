import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:smart_farm/data/models/message.dart';

class GemmaLocalService {
  // prompt
  String prompt(String description) =>
      'You are a Farm AI assistant. You will recieve the results of a conducted bean plant diagnosis. Analyse the results and give provide a summary, no more than three paragraphs , of recommendations and possible ways to manage it: $description';

  // process message
  Future<String?> processMessage(List<MessageModel> messages) {
    return FlutterGemmaPlugin.instance.getChatResponse(messages: messages);
  }

  // process message asynchrounously
  Stream<String?> processMessageAsync(List<MessageModel> messages) {
    return FlutterGemmaPlugin.instance.getChatResponseAsync(messages: messages);
  }

  // process response
  Future<String?> processResponse(String description) {
    return FlutterGemmaPlugin.instance.getResponse(prompt: prompt(description));
  }
}
