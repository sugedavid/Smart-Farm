import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/core/data/models/diagnosis.dart';
import 'package:smart_farm/core/helper/settings_manager.dart';

void main() {
  group('DiagnosisModel Tests', () {
    test('should correctly convert DiagnosisModel to Map', () {
      final model = DiagnosisModel(
        imagePath: 'path/to/image.png',
        description: 'Sample description',
        analysis: 'Sample analysis',
        aiModel: AIModel.gemini.name,
        time: '2024-08-01T12:00:00Z',
        id: '123',
      );

      final map = model.toMap();

      expect(map, {
        'imagePath': 'path/to/image.png',
        'description': 'Sample description',
        'analysis': 'Sample analysis',
        'aiModel': AIModel.gemini.name,
        'time': '2024-08-01T12:00:00Z',
        'id': '123',
      });
    });
  });
}
