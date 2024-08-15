import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:smart_farm/core/data/models/message.dart';
import 'package:smart_farm/core/data/service/analytics_service.dart';

class GemmaService {
  // prompt
  String prompt(String description) =>
      'You are a Farm AI assistant. You will receive the results of a conducted bean plant diagnosis. Analyse the results and give provide a summary, no more than three paragraphs , of recommendations and possible ways to manage it: $description';

  // process message
  Future<String?> processMessage(
      List<MessageModel> messages, Trace trace, String event) async {
    await trace.start();
    var startTime = DateTime.now();

    var response =
        FlutterGemmaPlugin.instance.getChatResponse(messages: messages);

    var endTime = DateTime.now();
    var duration = endTime.difference(startTime).inMilliseconds;

    await trace.stop();
    await AnalyticsService()
        .logEvent(event, AnalyticsService().gemmaModel, duration);

    return response;
  }

  // process message asynchrounously
  Stream<String?> processMessageAsync(
      List<MessageModel> messages, Trace trace, String event) {
    trace.start();
    var startTime = DateTime.now();

    var response =
        FlutterGemmaPlugin.instance.getChatResponseAsync(messages: messages);

    var endTime = DateTime.now();
    var duration = endTime.difference(startTime).inMilliseconds;

    trace.stop();
    AnalyticsService().logEvent(event, AnalyticsService().gemmaModel, duration);

    return response;
  }

  // process response
  Future<String?> processResponse(
      String description, Trace trace, String event) async {
    await trace.start();
    var startTime = DateTime.now();

    var response =
        FlutterGemmaPlugin.instance.getResponse(prompt: prompt(description));

    var endTime = DateTime.now();
    var duration = endTime.difference(startTime).inMilliseconds;

    await trace.stop();
    await AnalyticsService()
        .logEvent(event, AnalyticsService().gemmaModel, duration);

    return response;
  }
}
