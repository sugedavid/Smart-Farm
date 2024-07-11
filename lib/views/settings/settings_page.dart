import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/components/sf_dialog.dart';
import 'package:smart_farm/components/sf_text_field.dart';
import 'package:smart_farm/components/sf_toast_notification.dart';
import 'package:smart_farm/data/models/user.dart';
import 'package:smart_farm/utils/firebase/authentication_utils.dart';
import 'package:smart_farm/utils/firebase/user_utils.dart';
import 'package:smart_farm/utils/spacing.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.userData});

  final UserModel userData;

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool _isLoading = false;

  // toggle loading
  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = authUser();
    return SingleChildScrollView(
      child: Column(
        children: [
          // profile
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 8.0),
                //   child: Text('Profile'),
                // ),

                // AppSpacing.medium,

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '${widget.userData.firstName} ${widget.userData.lastName}',
                    style: const TextStyle(
                        fontSize: 23, fontWeight: FontWeight.w400),
                  ),
                ),

                AppSpacing.medium,

                // profile
                // ListTile(
                //   contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                //   leading: const Icon(
                //     Icons.person_outline,
                //     size: 20,
                //   ),
                //   title: Text(
                //       '${widget.userData.firstName} ${widget.userData.lastName}'),
                // ),

                // email
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  leading: const Icon(
                    Icons.email_outlined,
                    size: 20,
                  ),
                  title: Text(
                    widget.userData.email,
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: ActionChip(
                    label: Text(user?.emailVerified ?? false
                        ? 'Verified'
                        : 'Not Verified'),
                    padding: EdgeInsets.zero,
                    backgroundColor: user?.emailVerified ?? false
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    labelStyle: TextStyle(
                        color: user?.emailVerified ?? false
                            ? Colors.green
                            : Colors.red,
                        fontSize: 12),
                    side: BorderSide.none,
                    onPressed: () async => user?.emailVerified ?? false
                        ? showToast('Email verified', context,
                            status: Status.info)
                        : await verifyUserEmail(context),
                  ),
                ),

                // reset email
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  onTap: () => SFDialog.showSFDialog(
                    context: context,
                    title: 'Reset Password',
                    content: const Text(
                        'We will send a password reset link to your email address.'),
                    okText: 'RESET',
                    cancelText: 'CANCEL',
                    onOk: () async {
                      Navigator.pop(context);
                      toggleLoading();
                      await resetPassword(widget.userData.email, context);
                      toggleLoading();
                    },
                    onCancel: () => Navigator.pop(context),
                  ),
                  leading: const Icon(
                    Icons.send_to_mobile_outlined,
                    size: 20,
                  ),
                  title: const Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.large,

          // settings
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('General'),
                ),

                AppSpacing.medium,

                // about
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  onTap: () => showAboutDialog(context: context),
                  leading: const Icon(
                    Icons.info_outlined,
                    size: 20,
                  ),
                  title: const Text(
                    'About',
                    style: TextStyle(fontSize: 14),
                  ),
                ),

                // close account
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  onTap: () {
                    SFDialog.showSFDialog(
                      context: context,
                      title: 'Delete Account',
                      content: const Text(
                          'Are you sure you want to close your account? This action cannot be undone.'),
                      okText: 'DELETE ACCOUNT',
                      cancelText: 'CANCEL',
                      onOk: () async {
                        Navigator.pop(context);
                        toggleLoading();
                        await closeUserAccount(context);
                        toggleLoading();
                      },
                      onCancel: () => Navigator.pop(context),
                    );
                  },
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  title: const Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

                // sign out
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                  onTap: () async {
                    SFDialog.showSFDialog(
                      context: context,
                      title: 'Sign out',
                      content: const Text('Are you sure you want to sign out?'),
                      okText: 'SIGN OUT',
                      cancelText: 'CANCEL',
                      onOk: () async {
                        Navigator.pop(context);
                        toggleLoading();
                        await signOutUser(context);
                        toggleLoading();
                      },
                      onCancel: () => Navigator.pop(context),
                    );
                  },
                  leading: const Icon(
                    Icons.exit_to_app_outlined,
                    color: Colors.red,
                    size: 20,
                  ),
                  title: const Text(
                    'Sign out',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showReAuthDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController(text: widget.userData.email);
    final passwordController = TextEditingController();

    SFDialog.showSFDialog(
        context: context,
        title: 'Sign In',
        cancelText: 'Cancel',
        onCancel: () => Navigator.of(context).pop(),
        okText: 'Continue',
        onOk: () async {
          if (formKey.currentState!.validate()) {
            Navigator.of(context).pop();
            await reAuthUser(
              emailController.text,
              passwordController.text,
              widget.userData,
              context,
            );
          }
        },
        content: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSpacing.large,
              // email
              SFTextField(
                labelText: 'Email',
                controller: emailController,
                textInputType: TextInputType.emailAddress,
              ),

              // password
              SFTextField(
                labelText: 'Password',
                controller: passwordController,
                obscureText: true,
                showOptional: false,
              ),
            ],
          ),
        ));
  }
}
