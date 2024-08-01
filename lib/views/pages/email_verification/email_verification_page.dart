import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/views/components/sf_main_scaffold.dart';
import 'package:smart_farm/views/components/sf_primary_button.dart';
import 'package:smart_farm/views/components/sf_single_page_scaffold.dart';
import 'package:smart_farm/views/components/sf_toast_notification.dart';
import 'package:smart_farm/data/models/user.dart';
import 'package:smart_farm/utils/assets.dart';
import 'package:smart_farm/utils/firebase/authentication_utils.dart';
import 'package:smart_farm/utils/firebase/user_utils.dart';
import 'package:smart_farm/utils/spacing.dart';
import '../../../utils/colors.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  EmailVerificationPageState createState() => EmailVerificationPageState();
}

class EmailVerificationPageState extends State<EmailVerificationPage>
    with SingleTickerProviderStateMixin {
  UserModel userModel = UserModel.toEmpty();

  bool resend = false;
  int remainingTime = 30;

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  void fetchUserData() async {
    userModel = await authUserInfo(context);
  }

  void toggleResendCode() {
    setState(() {
      resend = !resend;
    });
  }

  void startTimer() async {
    toggleResendCode();
    while (remainingTime > 0) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        remainingTime--;
      });
    }
    toggleResendCode();
  }

  @override
  Widget build(BuildContext context) {
    return SFSinglePageScaffold(
      title: 'Account Verification',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.emailVerificationImg,
              width: 70,
              height: 70,
            ),
            AppSpacing.medium,

            // title
            const Text(
              'Verify Email',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            // message
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'An email with a verification link has been sent to ',
                    style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                  ),
                  TextSpan(
                    text: authUser()?.email ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.xxxLarge,

            // continue
            SFPrimaryButton(
              text: 'Continue',
              onPressed: () async {
                showToast('Signed in', context, status: Status.success);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const SFMainScaffold(),
                    ),
                    (route) => false);
              },
            ),
            AppSpacing.large,

            // resend
            Align(
              alignment: Alignment.bottomCenter,
              child: RichText(
                text: TextSpan(
                  text: "Didn't get the email? ",
                  style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Resend',
                      style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async => await verifyUserEmail(context),
                    ),
                  ],
                ),
              ),
            ),

            // sign out
            TextButton(
              onPressed: () async => signOutUser(context),
              child: const Text(
                'Sign out',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
