import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_config_provider.dart';

class DialogUtils {
  static void showLoading(BuildContext context, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        var provider = Provider.of<AppConfigProvider>(context);

        return AlertDialog(
          backgroundColor: provider.appTheme == ThemeMode.light
              ? MyTheme.whiteColor
              : MyTheme.blackDark,
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 12,
              ),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(BuildContext context, String message,
      {String title = 'Title',
      String? posActionName,
      VoidCallback? posAction,
      String? negActionName,
      VoidCallback? negAction,
      bool barrierDismissible = true}) {
    List<Widget> actions = [];
    if (posActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            posAction?.call();
          },
          child: Text(posActionName)));
    }
    if (negActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            negAction?.call();
          },
          child: Text(negActionName)));
    }
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        var provider = Provider.of<AppConfigProvider>(context);

        return AlertDialog(
          backgroundColor: provider.appTheme == ThemeMode.light
              ? MyTheme.whiteColor
              : MyTheme.blackDark,
          content: Text(message),
          title: Text(title,
              style: TextStyle(
                  color: provider.appTheme == ThemeMode.light
                      ? MyTheme.blackColor
                      : MyTheme.whiteColor)),
          actions: actions,
          titleTextStyle: TextStyle(color: MyTheme.blackColor),
        );
      },
    );
  }
}
