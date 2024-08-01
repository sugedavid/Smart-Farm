import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/data/models/user.dart';

void main() {
  group('UserModel Tests', () {
    test('toFirestore should convert UserModel to Map<String, dynamic>', () {
      final userModel = UserModel(
        userId: '12345',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        emailVerified: true,
      );

      final firestoreData = userModel.toFirestore();

      expect(firestoreData, {
        'userId': '12345',
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john.doe@example.com',
        'emailVerified': true,
      });
    });

    test('copyWith should create a copy of UserModel with modified fields', () {
      final userModel = UserModel(
        userId: '12345',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        emailVerified: true,
      );

      final updatedUserModel = userModel.copyWith(
        firstName: 'Jane',
        emailVerified: false,
      );

      expect(updatedUserModel.userId, '12345');
      expect(updatedUserModel.firstName, 'Jane');
      expect(updatedUserModel.lastName, 'Doe');
      expect(updatedUserModel.email, 'john.doe@example.com');
      expect(updatedUserModel.emailVerified, false);
    });

    test('toEmpty should return a UserModel with default empty values', () {
      final emptyUserModel = UserModel.toEmpty();

      expect(emptyUserModel.userId, '');
      expect(emptyUserModel.firstName, '');
      expect(emptyUserModel.lastName, '');
      expect(emptyUserModel.email, '');
      expect(emptyUserModel.emailVerified, false);
    });
  });
}
