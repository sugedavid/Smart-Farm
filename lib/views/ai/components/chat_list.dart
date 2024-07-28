import 'package:flutter/material.dart';
import 'package:smart_farm/data/models/message.dart';
import 'package:smart_farm/views/ai/components/chat_input_field.dart';
import 'package:smart_farm/views/ai/components/chat_message.dart';
import 'package:smart_farm/views/ai/components/ai_input_field.dart';

class ChatList extends StatelessWidget {
  const ChatList({
    super.key,
    required this.messages,
    required this.gemmaHandler,
    required this.geminiHandler,
    required this.humanHandler,
    required this.isOffline,
  });

  final List<MessageModel> messages;
  final ValueChanged<MessageModel> gemmaHandler;
  final ValueChanged<MessageModel> geminiHandler;
  final ValueChanged<String> humanHandler;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
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
              isOffline: isOffline,
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
