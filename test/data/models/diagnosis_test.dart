import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/data/models/diagnosis.dart';

void main() {
  group('DiagnosisModel Tests', () {
    test('should correctly convert DiagnosisModel to Map', () {
      final model = DiagnosisModel(
        imagePath: 'path/to/image.png',
        description: 'Sample description',
        analysis: 'Sample analysis',
        isOffline: true,
        time: '2024-08-01T12:00:00Z',
        id: '123',
      );

      final map = model.toMap();

      expect(map, {
        'imagePath': 'path/to/image.png',
        'description': 'Sample description',
        'analysis': 'Sample analysis',
        'isOffline': true,
        'time': '2024-08-01T12:00:00Z',
        'id': '123',
      });
    });
  });
}
