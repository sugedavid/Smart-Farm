import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/components/sf_main_scaffold.dart';
import 'package:smart_farm/data/helper/settings_manager.dart';
import 'package:smart_farm/data/models/user.dart';
import 'package:smart_farm/firebase_options.dart';
import 'package:smart_farm/utils/colors.dart';
import 'package:smart_farm/utils/firebase/user_utils.dart';
import 'package:smart_farm/views/email_verification/email_verification_page.dart';
import 'package:smart_farm/views/login/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // gemma
  await FlutterGemmaPlugin.instance.init(
    temperature: 1.0,
    topK: 1,
    randomSeed: 1,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MainApp(),
    ),
  );
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
    return Consumer<ThemeNotifier>(builder: (context, themeNotifier, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Farm',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryColor,
            primary: AppColors.primaryColor,
            background: Colors.white,
            surface: Colors.grey.shade200,
            surfaceTint: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
              color: Colors.white, surfaceTintColor: AppColors.primaryColor),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: AppColors.primaryColor,
            primary: AppColors.darkModePimaryColor,
            background: AppColors.darkModeBackgroundColor,
            surface: AppColors.darkModeSurfaceColor,
            surfaceTint: Theme.of(context).colorScheme.surfaceVariant,
          ),
          appBarTheme:
              const AppBarTheme(color: AppColors.darkModeBackgroundColor),
          useMaterial3: true,
        ),
        themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: mainPage(),
      );
    });
  }
}

class ThemeNotifier with ChangeNotifier {
  final SettingsManager _settingsManager = SettingsManager();
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeNotifier() {
    _loadTheme();
  }

  void _loadTheme() async {
    _isDarkMode = await _settingsManager.getDarkMode();
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _settingsManager.saveDarkMode(_isDarkMode);
    notifyListeners();
  }
}
