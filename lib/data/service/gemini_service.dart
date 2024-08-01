import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:smart_farm/data/models/message.dart';

class GeminiLocalService {
  final geminiModel =
      FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');

  final generationConfig = GenerationConfig(
    maxOutputTokens: 400,
    temperature: 0.9,
  );

  // prompt
  String prompt(String description) =>
      'You are a Farm AI assistant. You will recieve the results of a conducted bean plant diagnosis. Analyse the results and give provide a summary, no more than three paragraphs , of recommendations and possible ways to manage it: $description';

  // process message
  Future<GenerateContentResponse> processMessage(List<MessageModel> messages) {
    return geminiModel.generateContent(
      [Content.text(messages.last.text)],
      generationConfig: generationConfig,
    );
  }

  // process response
  Future<GenerateContentResponse> processResponse(String description) {
    return geminiModel.generateContent(
      [Content.text(prompt(description))],
      generationConfig: generationConfig,
    );
  }
}
