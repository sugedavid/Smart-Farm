import 'package:flutter_test/flutter_test.dart';

import 'package:smart_farm/data/models/message.dart';

void main() {
  group('MessageModel Tests', () {
    test('should correctly convert MessageModel to JSON', () {
      const messageModel = MessageModel(
        text: 'Hello, world!',
        isUser: true,
        time: '2024-08-01T12:00:00Z',
      );

      final json = messageModel.toJson();

      expect(json, {
        'text': 'Hello, world!',
        'isUser': true,
        'time': '2024-08-01T12:00:00Z',
      });
    });

    test('should correctly create MessageModel from JSON', () {
      final json = {
        'text': 'Hello, world!',
        'isUser': true,
        'time': '2024-08-01T12:00:00Z',
      };

      final messageModel = MessageModel.fromJson(json);

      expect(messageModel.text, 'Hello, world!');
      expect(messageModel.isUser, true);
      expect(messageModel.time, '2024-08-01T12:00:00Z');
    });

    test(
        'should create MessageModel with default values when JSON has missing fields',
        () {
      final json = {
        'text': 'Hello, world!',
        'isUser': false,
      };

      final messageModel = MessageModel.fromJson(json);

      expect(messageModel.text, 'Hello, world!');
      expect(messageModel.isUser, false);
      expect(messageModel.time, '');
    });
  });
}
