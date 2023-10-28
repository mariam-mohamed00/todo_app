import 'package:flutter/material.dart';

abstract class LoginNavigator {
  void showMyLoading();

  void HideMyLoading();

  void showMyMessage(BuildContext context, String message,
      {String title = 'Title',
      String? posActionName,
      VoidCallback? posAction,
      bool barrierDismissible = true});
// void goToHome(String routeName);
}
