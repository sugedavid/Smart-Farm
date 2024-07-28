import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smart_farm/data/models/message.dart';
import 'package:smart_farm/utils/date.dart';
import 'package:smart_farm/utils/spacing.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              // ai avatar
              message.isUser
                  ? const SizedBox()
                  : _buildAvatar(context: context),
              AppWidthSpacing.xSmall,

              // message
              Flexible(
                child: Column(
                  crossAxisAlignment: message.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // message body
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? Theme.of(context).colorScheme.onInverseSurface
                              : Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: message.text.isNotEmpty
                            ? MarkdownBody(
                                data: message.text,
                                styleSheet: MarkdownStyleSheet(
                                  p: TextStyle(
                                    color: message.isUser
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                        : Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                  ),
                                ),
                              )
                            : LoadingAnimationWidget.waveDots(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                size: 18,
                              ),
                      ),
                    ),

                    // time
                    Container(
                      alignment: message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4.0),
                      child: Text(
                        formatDateString(message.time),
                        style: const TextStyle(fontSize: 10),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // avatar
  Widget _buildAvatar({context = BuildContext}) {
    return message.isUser
        ? const Icon(
            Icons.account_circle,
            color: Colors.grey,
          )
        : Icon(
            Icons.auto_awesome,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          );
  }
}
