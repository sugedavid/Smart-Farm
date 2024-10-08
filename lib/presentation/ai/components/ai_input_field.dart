import 'dart:async';

import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/core/data/models/message.dart';
import 'package:smart_farm/core/data/service/analytics_service.dart';
import 'package:smart_farm/core/data/service/gemini_service.dart';
import 'package:smart_farm/core/data/service/gemma_service.dart';
import 'package:smart_farm/core/data/service/performance_service.dart';
import 'package:smart_farm/core/helper/settings_manager.dart';
import 'package:smart_farm/presentation/ai/components/chat_message.dart';

class AIInputField extends StatefulWidget {
  const AIInputField({
    super.key,
    required this.messages,
    required this.streamHandled,
    required this.geminiStreamHandled,
    required this.aiModel,
  });

  final List<MessageModel> messages;
  final ValueChanged<MessageModel> streamHandled;
  final ValueChanged<MessageModel> geminiStreamHandled;
  final String aiModel;

  @override
  AIInputFieldState createState() => AIInputFieldState();
}

class AIInputFieldState extends State<AIInputField> {
  final _gemma = GemmaService();
  StreamSubscription<String?>? _subscription;
  var _message = MessageModel(
    text: '',
    time: DateTime.now().toIso8601String(),
  );

  @override
  void initState() {
    super.initState();
    _processMessages();
  }

  // process message
  void _processMessages() {
    // gemma
    if (widget.aiModel == AIModel.gemma.name) {
      _subscription = _gemma
          .processMessageAsync(
              widget.messages,
              PerformanceService().gemmaChatbotTrace,
              AnalyticsService().chatBotEvent)
          .listen((String? token) {
        // finished adding text
        if (token == null) {
          widget.streamHandled(_message);
        }
        // add text
        else {
          setState(() {
            _message = MessageModel(
              text: '${_message.text}$token',
              time: DateTime.now().toIso8601String(),
            );
          });
        }
      });
    }
    // gemini
    else if (widget.aiModel == AIModel.gemini.name) {
      GeminiService()
          .processMessage(
              widget.messages,
              PerformanceService().geminiChatbotTrace,
              AnalyticsService().chatBotEvent)
          .then((GenerateContentResponse value) {
        setState(() {
          _message = MessageModel(
            text: value.text ?? '',
            time: DateTime.now().toIso8601String(),
          );
          widget.geminiStreamHandled(_message);
        });
      });
    }
    // GPT
    else if (widget.aiModel == AIModel.gemini.name) {
      // TODO: GPT Implementation
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ChatMessage(message: _message),
    );
  }
}
