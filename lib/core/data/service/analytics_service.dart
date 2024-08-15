import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // events
  final String diagnosisEvent = 'diagnosis';
  final String analysisEvent = 'analysis';
  final String chatBotEvent = 'chatbot';

  // bean plant
  final String diagnosisModel = 'bean-plant';

  // gemma
  final String gemmaModel = 'gemma-2b-it-cpu-int4';

  // gemini
  final String geminiModel = 'gemini-1.5-flash';

  // gpt
  final String gptModel = 'gpt-3.5-turbo-1106';

  Future<void> logEvent(String name, String model, int duration) async {
    await analytics.logEvent(
      name: name,
      parameters: {
        'model': model,
        'duration_ms': duration,
      },
    );
  }
}
