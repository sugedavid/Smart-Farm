import 'dart:convert';

import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_farm/core/data/models/gpt/analysis_request.dart';
import 'package:smart_farm/core/data/models/gpt/analysis_response.dart';
import 'package:smart_farm/core/data/models/message.dart';
import 'package:smart_farm/core/data/service/analytics_service.dart';
import 'package:smart_farm/core/utils/firebase/user_utils.dart';
import 'package:smart_farm/shared/presentation/sf_toast_notification.dart';

class GPTService {
  final baseUrl = Uri.parse('http://192.168.1.129:8000/analysis');

  // assistant ID
  String assistantId = 'asst_rsigblrq35r9rdfGAvjTpbzJ';

  // prompt
  String prompt =
      'You are a Farm AI assistant. You will receive the results of a conducted bean plant diagnosis. Analyse the results and give provide a summary, no more than three paragraphs , of recommendations and possible ways to manage it';

  // process message
  Future<AnalysisResponseModel> processMessage(
      List<MessageModel> messages, Trace trace, String event) async {
    return AnalysisResponseModel.toEmpty();
  }

  // process response
  Future<dynamic> processResponse(
    AnalysisRequestModel requestBody,
    Trace trace,
    String event,
    BuildContext context,
  ) async {
    await trace.start();
    var startTime = DateTime.now();

    debugPrint(requestBody.toJson());

    // post request
    try {
      final response = await http.post(
        baseUrl,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody.toMap()),
      );

      // success
      if (response.statusCode == 200) {
        debugPrint('Response body: ${response.body}');

        var duration = DateTime.now().difference(startTime).inMilliseconds;
        await trace.stop();
        await AnalyticsService()
            .logEvent(event, AnalyticsService().gptModel, duration);

        final Map<String, dynamic> jsonMap = jsonDecode(response.body);

        await Future.delayed(const Duration(seconds: 5));
        if (context.mounted) {
          await fetchData(context);
        }
        return jsonMap;
      }
      // error
      else {
        debugPrint(
            'Failed to generate analysis. Status code: ${response.statusCode}');
        if (context.mounted) {
          showToast(
              'Failed to generate analysis. Status code: ${response.statusCode} Reason: ${response.reasonPhrase}',
              context,
              status: Status.error);
        }

        var duration = DateTime.now().difference(startTime).inMilliseconds;
        await trace.stop();
        await AnalyticsService()
            .logEvent(event, AnalyticsService().gptModel, duration);

        return AnalysisResponseModel.toEmpty();
      }
    } catch (e) {
      debugPrint('Error making POST request: $e');
      if (context.mounted) {
        showToast('Error making POST request: $e', context,
            status: Status.error);
      }

      var duration = DateTime.now().difference(startTime).inMilliseconds;
      await trace.stop();
      await AnalyticsService()
          .logEvent(event, AnalyticsService().gptModel, duration);

      return AnalysisResponseModel.toEmpty();
    }
  }

  // fetch analysis
  Future<dynamic> fetchData(BuildContext context) async {
    try {
      // user
      final user = await authUserInfo(context);

      final queryParams = {
        'thread_id': user.threadId,
      };
      final url = baseUrl.replace(queryParameters: queryParams);

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        debugPrint('Failed to load data. Status code: ${response.statusCode}');
        if (context.mounted) {
          showToast(
              'Failed to generate analysis. Status code: ${response.statusCode} Reason: ${response.reasonPhrase}',
              context,
              status: Status.error);
        }
        return AnalysisResponseModel.toEmpty();
      }
    } catch (e) {
      if (context.mounted) {
        showToast('Error fetching data: $e', context, status: Status.error);
      }
      debugPrint('Error fetching data: $e');
      return AnalysisResponseModel.toEmpty();
    }
  }
}
