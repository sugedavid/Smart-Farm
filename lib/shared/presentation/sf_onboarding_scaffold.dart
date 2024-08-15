import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/utils/colors.dart';
import '../../core/utils/spacing.dart';

class SFOnBoardingScaffold extends StatelessWidget {
  const SFOnBoardingScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.richText,
    required this.richActionText,
    required this.onRichCallTap,
    this.secondaryRichText,
    this.secondaryActionText,
    this.onSecondaryRichCallTap,
  });

  final String title;
  final Widget body;
  final String richText;
  final String richActionText;
  final Function() onRichCallTap;
  final String? secondaryRichText;
  final String? secondaryActionText;
  final Function()? onSecondaryRichCallTap;

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 16.0);
    TextStyle linkStyle = const TextStyle(
        color: AppColors.primaryColor, fontWeight: FontWeight.w500);

    return Scaffold(
      appBar: null,
      body: Center(
        child: Center(
          child: SafeArea(
            child: Center(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 24),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),

                    // body
                    body,

                    AppSpacing.veryLarge,

                    // rich text link
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RichText(
                        text: TextSpan(
                          text: richActionText,
                          style: defaultStyle,
                          children: <TextSpan>[
                            TextSpan(
                              text: richText,
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = onRichCallTap,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacing.small,

                    if (secondaryRichText != null)
                      // secondary action
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: RichText(
                          text: TextSpan(
                            text: secondaryActionText,
                            style: defaultStyle,
                            children: <TextSpan>[
                              TextSpan(
                                text: secondaryRichText,
                                style: linkStyle,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = onSecondaryRichCallTap,
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }
}
