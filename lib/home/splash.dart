import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/login/login_screen.dart';
import 'package:todo/providers/app_config_provider.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'Splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(seconds: 2), () {});
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      body: Image.asset(
        provider.appTheme == ThemeMode.light
            ? 'assets/images/splash_light.png'
            : 'assets/images/splash_dark.png',
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }
}
