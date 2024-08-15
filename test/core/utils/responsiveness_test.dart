import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/core/utils/responsiveness.dart';

void main() {
  testWidgets('isLargeScreen returns true for large screens',
      (WidgetTester tester) async {
    const Size largeScreenSize = Size(3840, 2160);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
            MediaQueryData mediaQueryData = MediaQueryData(
              size: largeScreenSize,
              devicePixelRatio: devicePixelRatio,
            );

            return MediaQuery(
              data: mediaQueryData,
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    expect(isLargeScreen(context), isTrue);
                    return const SizedBox.shrink();
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  });

  testWidgets('isLargeScreen returns false for small screens',
      (WidgetTester tester) async {
    const Size smallScreenSize = Size(360, 640);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
            MediaQueryData mediaQueryData = MediaQueryData(
              size: smallScreenSize,
              devicePixelRatio: devicePixelRatio,
            );

            return MediaQuery(
              data: mediaQueryData,
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    expect(isLargeScreen(context), isFalse);
                    return const SizedBox.shrink();
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  });
}
