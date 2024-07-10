import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/components/sf_main_scaffold.dart';
import 'package:smart_farm/data/models/user.dart';
import 'package:smart_farm/firebase_options.dart';
import 'package:smart_farm/utils/colors.dart';
import 'package:smart_farm/utils/firebase/user_utils.dart';
import 'package:smart_farm/views/email_verification/email_verification_page.dart';
import 'package:smart_farm/views/login/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  UserModel userModel = UserModel.toEmpty();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    userModel = await authUserInfo(context);
  }

  Widget mainPage() {
    if (authUser() != null) {
      if (!(authUser()?.emailVerified ?? false)) {
        return EmailVerificationPage(
          userModel: userModel,
        );
      } else {
        return const SFMainScaffold();
      }
    } else {
      return const LogInPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Farm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          // surface: Colors.white,
        ),
        useMaterial3: true,
      ),
      // darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: mainPage(),
    );
  }
}
