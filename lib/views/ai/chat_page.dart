import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:smart_farm/data/helper/chat_manager.dart';
import 'package:smart_farm/data/models/message.dart';
import 'package:smart_farm/views/ai/components/chat_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.onMessageAdded});

  final Function() onMessageAdded;

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final ChatManager chatManager = ChatManager();
  var _messages = <MessageModel>[];

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  Future<void> getMessages() async {
    _messages = await chatManager.getChats();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      FutureBuilder(
        future: FlutterGemmaPlugin.instance.isInitialized,
        builder: (context, snapshot) {
          // chat list
          if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.data == true) {
            return Stack(
              children: [
                if (_messages.isEmpty) const Center(child: Text('No messages')),
                ChatList(
                  gemmaHandler: (message) {
                    setState(() {
                      chatManager.saveChat(message);
                      getMessages();
                      widget.onMessageAdded();
                    });
                  },
                  humanHandler: (text) {
                    setState(() {
                      chatManager
                          .saveChat(MessageModel(text: text, isUser: true));
                      getMessages();
                      widget.onMessageAdded();
                    });
                  },
                  messages: _messages,
                ),
              ],
            );
          }
          // loading
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ]);
  }
}
