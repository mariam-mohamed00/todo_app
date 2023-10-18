import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/auth/login/login_screen.dart';
import 'package:todo/auth/register/register_screen.dart';
import 'package:todo/home/home_screen.dart';
import 'package:todo/home/task_list/edit_task_screen.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_config_provider.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/providers/list_provider.dart';

import 'home/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// offline
  // await FirebaseFirestore.instance.disableNetwork();
  // FirebaseFirestore.instance.settings =
  //     const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<AppConfigProvider>(
          create: (_) => AppConfigProvider()),
      ChangeNotifierProvider<ListProvider>(create: (_) => ListProvider()),
      ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider())
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
    // var listProvider = Provider.of<ListProvider>(context);
    provider = Provider.of<AppConfigProvider>(context);

    initSharedPref();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        SplashScreen.routeName: (context) => SplashScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        EditTask.routeName: (context) => EditTask(),
      },
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: provider.appTheme,
      locale: Locale(provider.appLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  Future<void> initSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    var language = prefs.getString('language');
    if (language != null) {
      provider.changeLanguage(language);
    }

    var isDark = prefs.getBool('isDark');
    if (isDark == true) {
      provider.changeTheme(ThemeMode.dark);
    } else if (isDark == false) {
      provider.changeTheme(ThemeMode.light);
    }
  }
}
