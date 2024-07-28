import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:smart_farm/data/models/message.dart';

class GeminiLocalService {
  final geminiModel =
      FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');

  final generationConfig = GenerationConfig(
    maxOutputTokens: 400,
    temperature: 0.9,
  );

  // process message
  Future<GenerateContentResponse> processMessage(List<MessageModel> messages) {
    return geminiModel.generateContent(
      [Content.text(messages.last.text)],
      generationConfig: generationConfig,
    );
  }

  // process response
  Future<GenerateContentResponse> processResponse(String prompt) {
    return geminiModel.generateContent(
      [Content.text(prompt)],
      generationConfig: generationConfig,
    );
  }
}
