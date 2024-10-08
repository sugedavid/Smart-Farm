import 'package:flutter/material.dart';
import 'package:smart_farm/core/data/models/message.dart';
import 'package:smart_farm/presentation/ai/components/ai_input_field.dart';
import 'package:smart_farm/presentation/ai/components/chat_input_field.dart';
import 'package:smart_farm/presentation/ai/components/chat_message.dart';

class ChatList extends StatelessWidget {
  const ChatList({
    super.key,
    required this.messages,
    required this.gemmaHandler,
    required this.geminiHandler,
    required this.humanHandler,
    required this.aiModel,
  });

  final List<MessageModel> messages;
  final ValueChanged<MessageModel> gemmaHandler;
  final ValueChanged<MessageModel> geminiHandler;
  final ValueChanged<String> humanHandler;
  final String aiModel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      reverse: true,
      itemCount: messages.length + 2,
      itemBuilder: (context, index) {
        // last item
        if (index == 0) {
          // gemma field
          if (messages.isNotEmpty && messages.last.isUser) {
            return AIInputField(
              messages: messages,
              streamHandled: gemmaHandler,
              geminiStreamHandled: geminiHandler,
              aiModel: aiModel,
            );
          }

          // chat field
          if (messages.isEmpty || !messages.last.isUser) {
            return ChatInputField(handleSubmitted: humanHandler);
          }
        } else if (index == 1) {
          return const Divider(height: 1.0);
        } else {
          final message = messages.reversed.toList()[index - 2];
          return ChatMessage(
            message: message,
          );
        }
        return null;
      },
    );
  }
}
