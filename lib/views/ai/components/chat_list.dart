import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:smart_farm/views/ai/components/chat_input_field.dart';
import 'package:smart_farm/views/ai/components/chat_message.dart';
import 'package:smart_farm/views/ai/components/gemma_input_field.dart';

class ChatList extends StatelessWidget {
  const ChatList({
    super.key,
    required this.messages,
    required this.gemmaHandler,
    required this.humanHandler,
  });

  final List<Message> messages;
  final ValueChanged<Message> gemmaHandler;
  final ValueChanged<String> humanHandler;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      primary: false,
      reverse: true,
      itemCount: messages.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          if (messages.isNotEmpty && messages.last.isUser) {
            return GemmaInputField(
              messages: messages,
              streamHandled: gemmaHandler,
            );
          }
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
