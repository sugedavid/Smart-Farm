import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/utils/spacing.dart';

void main() {
  group('AppSpacing Tests', () {
    test('AppSpacing xSmall has correct height', () {
      expect(AppSpacing.xSmall, isA<SizedBox>());
      expect((AppSpacing.xSmall).height, 8.0);
    });

    test('AppSpacing small has correct height', () {
      expect(AppSpacing.small, isA<SizedBox>());
      expect((AppSpacing.small).height, 12.0);
    });

    test('AppSpacing medium has correct height', () {
      expect(AppSpacing.medium, isA<SizedBox>());
      expect((AppSpacing.medium).height, 16.0);
    });

    test('AppSpacing large has correct height', () {
      expect(AppSpacing.large, isA<SizedBox>());
      expect((AppSpacing.large).height, 20.0);
    });

    test('AppSpacing xLarge has correct height', () {
      expect(AppSpacing.xLarge, isA<SizedBox>());
      expect((AppSpacing.xLarge).height, 24.0);
    });

    test('AppSpacing xxLarge has correct height', () {
      expect(AppSpacing.xxLarge, isA<SizedBox>());
      expect((AppSpacing.xxLarge).height, 28.0);
    });

    test('AppSpacing xxxLarge has correct height', () {
      expect(AppSpacing.xxxLarge, isA<SizedBox>());
      expect((AppSpacing.xxxLarge).height, 32.0);
    });

    test('AppSpacing veryLarge has correct height', () {
      expect(AppSpacing.veryLarge, isA<SizedBox>());
      expect((AppSpacing.veryLarge).height, 40.0);
    });
  });

  group('AppWidthSpacing Tests', () {
    test('AppWidthSpacing xSmall has correct width', () {
      expect(AppWidthSpacing.xSmall, isA<SizedBox>());
      expect((AppWidthSpacing.xSmall).width, 8.0);
    });

    test('AppWidthSpacing small has correct width', () {
      expect(AppWidthSpacing.small, isA<SizedBox>());
      expect((AppWidthSpacing.small).width, 12.0);
    });

    test('AppWidthSpacing medium has correct width', () {
      expect(AppWidthSpacing.medium, isA<SizedBox>());
      expect((AppWidthSpacing.medium).width, 16.0);
    });

    test('AppWidthSpacing large has correct width', () {
      expect(AppWidthSpacing.large, isA<SizedBox>());
      expect((AppWidthSpacing.large).width, 20.0);
    });

    test('AppWidthSpacing xLarge has correct width', () {
      expect(AppWidthSpacing.xLarge, isA<SizedBox>());
      expect((AppWidthSpacing.xLarge).width, 24.0);
    });

    test('AppWidthSpacing xxLarge has correct width', () {
      expect(AppWidthSpacing.xxLarge, isA<SizedBox>());
      expect((AppWidthSpacing.xxLarge).width, 28.0);
    });

    test('AppWidthSpacing xxxLarge has correct width', () {
      expect(AppWidthSpacing.xxxLarge, isA<SizedBox>());
      expect((AppWidthSpacing.xxxLarge).width, 32.0);
    });

    test('AppWidthSpacing veryLarge has correct width', () {
      expect(AppWidthSpacing.veryLarge, isA<SizedBox>());
      expect((AppWidthSpacing.veryLarge).width, 40.0);
    });
  });
}
