import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/views/components/sf_main_scaffold.dart';
import 'package:smart_farm/views/components/sf_toast_notification.dart';
import 'package:smart_farm/utils/firebase/user_utils.dart';
import 'package:smart_farm/views/pages/login/login_page.dart';

// register a new user
Future<void> registerUser(String firstName, String lastName,
    String emailAddress, String password, BuildContext context) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: emailAddress, password: password)
        .then((UserCredential credential) {
      // update user details
      updateUser(credential, firstName, lastName, context);
    });
  } on FirebaseAuthException catch (e) {
    // error handling
    if (e.code == 'weak-password') {
      if (context.mounted) {
        showToast('The password provided is too weak.', context,
            status: Status.error);
      }
    } else if (e.code == 'email-already-in-use') {
      if (context.mounted) {
        showToast('The account already exists for that email.', context,
            status: Status.error);
      }
    } else {
      if (context.mounted) {
        showToast(e.message ?? 'Oops! Something went wrong', context,
            status: Status.error);
      }
    }
  } catch (e) {
    // error handling
    if (context.mounted) {
      showToast(
          'Oops! Could not register your account: ${e.toString()}', context,
          status: Status.error);
    }
  }
}

// login a user
Future<void> logInUser(
    String emailAddress, String password, BuildContext context) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    )
        .then((UserCredential value) {
      // navigate to home page
      showToast('Signed in', context, status: Status.success);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const SFMainScaffold(),
          ),
          (route) => false);
    });
  } on FirebaseAuthException catch (e) {
    // firebase error handling
    if (e.code == 'user-not-found') {
      if (context.mounted) {
        showToast('No user found for that email.', context,
            status: Status.error);
      }
    } else if (e.code == 'wrong-password') {
      if (context.mounted) {
        {
          showToast('Wrong password provided for that user.', context,
              status: Status.error);
        }
      }
    } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
      if (context.mounted) {
        showToast('Invalid login credentials', context, status: Status.error);
      }
    } else {
      if (context.mounted) {
        {
          showToast(e.message ?? 'Oops! Something went wrong', context,
              status: Status.error);
        }
      }
    }
  } catch (e) {
    // error handling
    if (context.mounted) {
      showToast('Oops! Something went wrong: ${e.toString()}', context);
    }
  }
}

// verify email
Future<void> verifyUserEmail(BuildContext context) async {
  try {
    final user = authUser();
    await user?.sendEmailVerification().then((_) {
      // update user
      final usersCollection = dbInstance.collection('users');
      usersCollection.doc(user.uid).update({
        'emailVerified': user.emailVerified,
      });

      showToast('Email verification sent successfully', context,
          status: Status.success);
    });
  } on FirebaseAuthException catch (e) {
    // firebase error handling
    if (e.code == 'user-not-found') {
      if (context.mounted) {
        showToast('No user found for that email.', context,
            status: Status.error);
      }
    } else if (e.code == 'wrong-password') {
      if (context.mounted) {
        showToast('Wrong password provided for that user.', context,
            status: Status.error);
      }
    } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
      if (context.mounted) {
        showToast('Invalid login credentials', context, status: Status.error);
      }
    } else {
      if (context.mounted) {
        showToast(e.message ?? 'Oops! Something went wrong', context,
            status: Status.error);
      }
    }
  } catch (e) {
    // error handling
    if (context.mounted) {
      showToast('Oops! Something went wrong: ${e.toString()}', context,
          status: Status.error);
    }
  }
}

// sign out a user
Future<void> signOutUser(BuildContext context) async {
  await FirebaseAuth.instance.signOut().then((value) {
    showToast('Signed out', context, status: Status.success);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LogInPage(),
        ),
        (route) => false);
  }).catchError((error) {
    // error handling
    showToast('Oops! Something went wrong: $error', context,
        status: Status.error);
  });
}
