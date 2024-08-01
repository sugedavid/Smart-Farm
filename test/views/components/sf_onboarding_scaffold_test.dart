import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/views/components/sf_onboarding_scaffold.dart';

void main() {
  group('SFOnBoardingScaffold Tests', () {
    testWidgets('displays title, body, and rich text',
        (WidgetTester tester) async {
      const title = 'Welcome';
      const richActionText = 'Don\'t have an account?';
      const richText = ' Sign up';
      const bodyText = 'This is the body content';
      bool richTextTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SFOnBoardingScaffold(
            title: title,
            body: const Text(bodyText),
            richText: richText,
            richActionText: richActionText,
            onRichCallTap: () {
              richTextTapped = true;
            },
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(bodyText), findsOneWidget);

      expect(find.textContaining(richActionText, findRichText: true),
          findsOneWidget);
      expect(find.textContaining(richText, findRichText: true), findsOneWidget);

      await tester.tap(find.textContaining(richText, findRichText: true));
      expect(richTextTapped, isFalse);
    });

    testWidgets('displays secondary rich text when provided',
        (WidgetTester tester) async {
      const title = 'Welcome';
      const richActionText = 'Don\'t have an account?';
      const richText = ' Sign up';
      const secondaryActionText = 'Already have an account?';
      const secondaryRichText = ' Log in';
      const bodyText = 'This is the body content';
      bool secondaryRichTextTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SFOnBoardingScaffold(
            title: title,
            body: const Text(bodyText),
            richText: richText,
            richActionText: richActionText,
            onRichCallTap: () {},
            secondaryRichText: secondaryRichText,
            secondaryActionText: secondaryActionText,
            onSecondaryRichCallTap: () {
              secondaryRichTextTapped = true;
            },
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(bodyText), findsOneWidget);
      expect(find.textContaining(richActionText, findRichText: true),
          findsOneWidget);
      expect(find.textContaining(richText, findRichText: true), findsOneWidget);
      expect(find.textContaining(secondaryActionText, findRichText: true),
          findsOneWidget);
      expect(find.textContaining(secondaryRichText, findRichText: true),
          findsOneWidget);

      await tester
          .tap(find.textContaining(secondaryRichText, findRichText: true));
      expect(secondaryRichTextTapped, isFalse);
    });
  });
}
