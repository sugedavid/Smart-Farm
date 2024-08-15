import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:smart_farm/core/data/models/message.dart';
import 'package:smart_farm/core/data/service/analytics_service.dart';

class GeminiService {
  final geminiModel =
      FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');

  final generationConfig = GenerationConfig(
    maxOutputTokens: 400,
    temperature: 1,
    topP: 1,
  );

  // prompt
  String prompt(String description) =>
      'You are a Farm AI assistant. You will receive the results of a conducted bean plant diagnosis. Analyse the results and give provide a summary, no more than three paragraphs , of recommendations and possible ways to manage it: $description';

  // process message
  Future<GenerateContentResponse> processMessage(
      List<MessageModel> messages, Trace trace, String event) async {
    await trace.start();
    var startTime = DateTime.now();

    var response = geminiModel.generateContent(
      [Content.text(messages.last.text)],
      generationConfig: generationConfig,
    );

    var endTime = DateTime.now();
    var duration = endTime.difference(startTime).inMilliseconds;

    await trace.stop();
    await AnalyticsService()
        .logEvent(event, AnalyticsService().geminiModel, duration);

    return response;
  }

  // process response
  Future<GenerateContentResponse> processResponse(
      String description, Trace trace, String event) async {
    await trace.start();
    var startTime = DateTime.now();

    var response = geminiModel.generateContent(
      [Content.text(prompt(description))],
      generationConfig: generationConfig,
    );

    var endTime = DateTime.now();
    var duration = endTime.difference(startTime).inMilliseconds;

    await trace.stop();
    await AnalyticsService()
        .logEvent(event, AnalyticsService().geminiModel, duration);

    return response;
  }
}
