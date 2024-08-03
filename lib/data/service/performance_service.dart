import 'package:firebase_performance/firebase_performance.dart';

class PerformanceService {
  // diagnosis
  final Trace diagnosisTrace =
      FirebasePerformance.instance.newTrace("diagnosis-trace");

  // gemma
  final Trace gemmaChatbotTrace =
      FirebasePerformance.instance.newTrace("gemma-chatbot-trace");
  final Trace gemmaAnalysisTrace =
      FirebasePerformance.instance.newTrace("gemma-analysis-trace");

  // gemini
  final Trace geminiChatbotTrace =
      FirebasePerformance.instance.newTrace("gemini-chatbot-trace");
  final Trace geminiAnalysisTrace =
      FirebasePerformance.instance.newTrace("gemini-analysis-trace");
}
