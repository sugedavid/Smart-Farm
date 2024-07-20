import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:smart_farm/views/ai/components/chat_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final _messages = <Message>[];

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FutureBuilder(
        future: FlutterGemmaPlugin.instance.isInitialized,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.data == true) {
            return ChatList(
              gemmaHandler: (message) {
                setState(() {
                  _messages.add(message);
                });
              },
              humanHandler: (text) {
                setState(() {
                  _messages.add(Message(text: text, isUser: true));
                });
              },
              messages: _messages,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ]);
  }
}
