import 'package:flutter/material.dart';
import 'package:smart_farm/components/sf_onboarding_scaffold.dart';
import 'package:smart_farm/components/sf_primary_button.dart';
import 'package:smart_farm/components/sf_text_field.dart';
import 'package:smart_farm/utils/spacing.dart';
import 'package:smart_farm/views/login/login_page.dart';

import '../../utils/firebase/authentication_utils.dart';

class ResgistrationPage extends StatelessWidget {
  const ResgistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return SFOnBoardingScaffold(
      title: 'Sign Up',
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: SFTextField(
                    labelText: 'First name',
                    controller: firstNameController,
                    textInputType: TextInputType.name,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: SFTextField(
                    labelText: 'Last name',
                    controller: lastNameController,
                    textInputType: TextInputType.name,
                  ),
                ),
              ],
            ),

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
              textInputType: TextInputType.visiblePassword,
              obscureText: true,
            ),

            AppSpacing.xLarge,

            // continue cta
            SFPrimaryButton(
              text: 'Continue',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await registerUser(
                    firstNameController.text,
                    lastNameController.text,
                    emailController.text,
                    passwordController.text,
                    context,
                  );
                }
              },
            ),
          ],
        ),
      ),
      richActionText: "Already have an account? ",
      richText: 'Sign In',
      onRichCallTap: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LogInPage(),
        ),
      ),
    );
  }
}
