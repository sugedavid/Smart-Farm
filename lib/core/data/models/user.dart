import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final bool emailVerified;
  final String threadId;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.emailVerified,
    required this.threadId,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return UserModel(
      userId: data?['userId'] ?? '',
      firstName: data?['firstName'] ?? '',
      lastName: data?['lastName'] ?? '',
      email: data?['email'] ?? '',
      emailVerified: data?['emailVerified'] ?? false,
      threadId: data?['threadId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'emailVerified': emailVerified,
      'threadId': threadId,
    };
  }

  UserModel copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? accountType,
    String? phoneNumber,
    bool? emailVerified,
    bool? phoneEnrolled,
    String? threadId,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      threadId: email ?? this.threadId,
    );
  }

  // empty user
  static UserModel toEmpty() {
    return UserModel(
      userId: '',
      firstName: '',
      lastName: '',
      email: '',
      emailVerified: false,
      threadId: '',
    );
  }
}
