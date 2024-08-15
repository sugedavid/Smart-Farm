import 'package:flutter/material.dart';
import 'package:smart_farm/core/utils/firebase/authentication_utils.dart';
import 'package:smart_farm/shared/presentation/sf_onboarding_scaffold.dart';
import 'package:smart_farm/shared/presentation/sf_primary_button.dart';
import 'package:smart_farm/shared/presentation/sf_text_field.dart';

import '../registration/registration_page.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return SFOnBoardingScaffold(
      title: 'Welcome',
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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

            const SizedBox(
              height: 20,
            ),

            // continue cta
            SFPrimaryButton(
              text: 'Sign in',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await logInUser(
                      emailController.text, passwordController.text, context);
                }
              },
            ),
          ],
        ),
      ),
      secondaryActionText: "Don't have an account? ",
      secondaryRichText: 'Sign Up',
      onSecondaryRichCallTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ResgistrationPage(),
        ),
      ),
      richActionText: 'Forgot Password? ',
      richText: 'Reset',
      onRichCallTap: () {},
    );
  }
}
