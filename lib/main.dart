import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/core/data/models/user.dart';
import 'package:smart_farm/core/helper/settings_manager.dart';
import 'package:smart_farm/core/utils/colors.dart';
import 'package:smart_farm/core/utils/firebase/user_utils.dart';
import 'package:smart_farm/firebase_options.dart';
import 'package:smart_farm/presentation/email_verification/email_verification_page.dart';
import 'package:smart_farm/presentation/login/login_page.dart';
import 'package:smart_farm/shared/presentation/sf_main_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // app check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
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
  bool _isOffline = true;
  String _aiModel = AIModel.gemini.name;

  bool get isDarkMode => _isDarkMode;
  bool get isOffline => _isOffline;
  String get aiModel => _aiModel;

  ThemeNotifier() {
    _loadTheme();
  }

  void _loadTheme() async {
    _isDarkMode = await _settingsManager.getDarkMode();
    _isOffline = await _settingsManager.getOffline();
    _aiModel = await _settingsManager.getAIModel();
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _settingsManager.saveDarkMode(_isDarkMode);
    notifyListeners();
  }

  void toggleOffline() {
    _isOffline = !_isOffline;
    _settingsManager.saveOffline(_isOffline);
    notifyListeners();
  }

  void saveAIModel(aiModel) {
    _aiModel = aiModel;
    _settingsManager.saveAIModel(_aiModel);
    notifyListeners();
  }
}
