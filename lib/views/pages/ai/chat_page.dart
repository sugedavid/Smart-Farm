import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/data/helper/chat_manager.dart';
import 'package:smart_farm/data/models/message.dart';
import 'package:smart_farm/main.dart';
import 'package:smart_farm/views/pages/ai/components/chat_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.onMessageAdded,
    required this.isOffline,
  });

  final Function() onMessageAdded;
  final bool isOffline;

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
    var key =
        widget.isOffline ? ChatManager.gemmaChatKey : ChatManager.geminiChatKey;
    _messages = await chatManager.getChat(key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

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
                      chatManager.saveChat(ChatManager.gemmaChatKey, message);
                      getMessages();
                      widget.onMessageAdded();
                    });
                  },
                  geminiHandler: (message) {
                    setState(() {
                      chatManager.saveChat(ChatManager.geminiChatKey, message);
                      getMessages();
                      widget.onMessageAdded();
                    });
                  },
                  humanHandler: (text) {
                    setState(() {
                      if (themeNotifier.isOffline) {
                        chatManager.saveChat(
                          ChatManager.gemmaChatKey,
                          MessageModel(
                            text: text,
                            isUser: true,
                            time: DateTime.now().toIso8601String(),
                          ),
                        );
                      } else {
                        chatManager.saveChat(
                          ChatManager.geminiChatKey,
                          MessageModel(
                            text: text,
                            isUser: true,
                            time: DateTime.now().toIso8601String(),
                          ),
                        );
                      }
                      getMessages();
                      widget.onMessageAdded();
                    });
                  },
                  messages: _messages,
                  isOffline: themeNotifier.isOffline,
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
