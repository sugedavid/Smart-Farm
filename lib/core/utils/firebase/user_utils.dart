import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/core/data/models/user.dart';
import 'package:smart_farm/core/helper/diagnosis_manager.dart';
import 'package:smart_farm/core/utils/firebase/authentication_utils.dart';
import 'package:smart_farm/presentation/email_verification/email_verification_page.dart';
import 'package:smart_farm/presentation/login/login_page.dart';
import 'package:smart_farm/shared/presentation/sf_toast_notification.dart';

// db reference
final dbInstance = FirebaseFirestore.instance;

// update user
Future<void> updateUser(UserCredential credential, String firstName,
    String lastName, BuildContext context) async {
  try {
    final user = UserModel(
      userId: credential.user?.uid ?? '',
      firstName: firstName,
      lastName: lastName,
      email: credential.user?.email ?? '',
      emailVerified: credential.user?.emailVerified ?? false,
      threadId: '',
    );

    // reference to the Firestore collection
    final usersCollection = dbInstance.collection('users');

    usersCollection
        .doc(credential.user?.uid)
        .set(user.toFirestore())
        .then((value) {
      // verify email
      if (context.mounted) {
        verifyUserEmail(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => EmailVerificationPage(
                userModel: user,
              ),
            ),
            (route) => false);
      }
    });
  } catch (error) {
    // error handling
    if (context.mounted) {
      showToast('Oops! Something went wrong: $error', context,
          status: Status.error);
    }
  }
}

// authenticated user
User? authUser() {
  User? user = FirebaseAuth.instance.currentUser;
  user?.reload();

  return user;
}

// reauthenticate user
Future<void> reAuthUser(
  String email,
  String password,
  UserModel? userModel,
  BuildContext context,
) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    // reauthenticate user
    await user?.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
  } catch (error) {
    if (context.mounted) {
      showToast('Oops! Something went wrong: $error', context,
          status: Status.error);
    }
  }
}

// user information
Future<UserModel> authUserInfo(BuildContext context) async {
  var user = authUser();
  if (user != null) {
    UserModel data = UserModel.toEmpty();
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, _) => user.toFirestore(),
          )
          .get();

      if (documentSnapshot.exists) {
        // user document found
        data = documentSnapshot.data() as UserModel;
        return data;
      } else {
        // user document does not exist
        return data;
      }
    } catch (error) {
      // error fetching user information
      if (context.mounted) {
        showToast('Error getting your information: $error', context,
            status: Status.error);
      }
      return data;
    }
  } else {
    // user is not authenticated
    return UserModel.toEmpty();
  }
}

// update user information
Future<void> updateUserInfo(
    String firstName, String lastName, BuildContext context) async {
  var user = authUser();
  if (user != null) {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'firstName': firstName,
        'lastName': lastName,
      }).then((value) {
        showToast('Profile updated successfully', context,
            status: Status.success);
      });
    } catch (error) {
      // error updating user profile
      if (context.mounted) {
        showToast('Error updating your profile: $error', context,
            status: Status.error);
      }
    }
  } else {
    // user is not authenticated
    showToast('You are not authenticated', context, status: Status.error);
  }
}

// close user account
Future<void> closeUserAccount(BuildContext context) async {
  var user = authUser();
  DiagnosisManager diagnosisManager = DiagnosisManager();
  if (user != null) {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      // get a reference to all documents in the subcollection
      final accountsQuery = userRef.collection('bankAccounts');

      // delete each document individually
      await accountsQuery.get().then((querySnapshot) async {
        for (final doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
      });
      // delete the user document
      await dbInstance.collection('users').doc(user.uid).delete();

      // delete the user account
      await user.delete();

      // delete all diagnosis
      await diagnosisManager.deleteAllDiagnosis();

      if (context.mounted) {
        showToast('Account closed successfully!', context,
            status: Status.error);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LogInPage(),
          ),
        );
      }
    } catch (error) {
      // error deleting user
      if (context.mounted) {
        showToast('Error closing your account: $error', context,
            status: Status.error);
      }
    }
  } else {
    // user is not authenticated
    showToast('You are not authenticated', context, status: Status.error);
  }
}

// reset password
Future<void> resetPassword(String email, BuildContext context) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((_) {
      showToast('Password reset email sent', context, status: Status.success);
    });
  } catch (error) {
    // error sending password reset email
    if (context.mounted) {
      showToast('Error sending password reset email: $error', context,
          status: Status.error);
    }
  }
}

// fetch user details by id
Future<UserModel> getUserById(String userId, BuildContext context) async {
  UserModel data = UserModel.toEmpty();
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel user, _) => user.toFirestore(),
        )
        .get();

    if (documentSnapshot.exists) {
      // user document found
      data = documentSnapshot.data() as UserModel;
      return data;
    } else {
      // user document does not exist
      return data;
    }
  } catch (error) {
    // error fetching user information
    if (context.mounted) {
      showToast('Error getting your information: $error', context,
          status: Status.error);
    }
    return data;
  }
}
