import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final ValueChanged<String> handleSubmitted;

  const ChatInputField({super.key, required this.handleSubmitted});

  @override
  ChatInputFieldState createState() => ChatInputFieldState();
}

class ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    widget.handleSubmitted(text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).hoverColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            // text field
            Flexible(
              child: TextField(
                maxLines: null,
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Write a message',
                ),
                onChanged: (_) {
                  setState(() {});
                },
              ),
            ),

            // send
            IconButton(
              icon: Icon(
                Icons.send_rounded,
                color: _textController.text.isEmpty
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}
