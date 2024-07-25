import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_farm/data/models/message.dart';
import 'package:smart_farm/views/ai/components/chat_message.dart';
import 'package:smart_farm/views/ai/service/gemma_service.dart';

class GemmaInputField extends StatefulWidget {
  const GemmaInputField({
    super.key,
    required this.messages,
    required this.streamHandled,
  });

  final List<MessageModel> messages;
  final ValueChanged<MessageModel> streamHandled;

  @override
  GemmaInputFieldState createState() => GemmaInputFieldState();
}

class GemmaInputFieldState extends State<GemmaInputField> {
  final _gemma = GemmaLocalService();
  StreamSubscription<String?>? _subscription;
  var _message = const MessageModel(text: '');

  @override
  void initState() {
    super.initState();
    _processMessages();
  }

  // process message
  void _processMessages() {
    _subscription =
        _gemma.processMessageAsync(widget.messages).listen((String? token) {
      if (token == null) {
        widget.streamHandled(_message);
      } else {
        setState(() {
          _message = MessageModel(text: '${_message.text}$token');
        });
      }
    });
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
