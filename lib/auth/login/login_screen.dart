import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/login/login_navigator.dart';
import 'package:todo/auth/login/login_screen_view_model.dart';
import 'package:todo/auth/register/custom_text_form_field.dart';
import 'package:todo/auth/register/register_screen.dart';
import 'package:todo/dialog_utils.dart';
import 'package:todo/providers/app_config_provider.dart';

import '../../my_theme.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LoginNavigator {
  LoginScreenViewModel viewModel = LoginScreenViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/main_background.png',
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Form(
              key: viewModel.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.38,
                    ),
                    CustomTextFormField(
                      label: AppLocalizations.of(context)!.email_address,
                      keyboardType: TextInputType.emailAddress,
                      controller: viewModel.emailController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!.validate_email;
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text);
                        if (!emailValid) {
                          return AppLocalizations.of(context)!.valid_email;
                        }

                        return null;
                      },
                    ),
                    CustomTextFormField(
                      isPassword: true,
                      label: AppLocalizations.of(context)!.password,
                      keyboardType: TextInputType.number,
                      controller: viewModel.passwordController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!
                              .validate_password;
                        }
                        if (text.length < 6) {
                          return AppLocalizations.of(context)!.valid_password;
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          viewModel.login(context);
                        },
                        child: Text(AppLocalizations.of(context)!.login,
                            style: Theme.of(context).textTheme.titleLarge),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.do_not_have_an_account,
                          style: provider.appTheme == ThemeMode.dark
                              ? Theme.of(context).textTheme.titleMedium
                              : Theme.of(context).textTheme.titleMedium,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(RegisterScreen.routeName);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.signup,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void HideMyLoading() {
    // TODO: implement HideMyLoading
    DialogUtils.hideLoading(context);
  }

  @override
  void showMyLoading() {
    // TODO: implement showMyLoading
    DialogUtils.showLoading(context, 'Loading...');
  }

  @override
  void showMyMessage(BuildContext context, String message,
      {String title = 'Title',
      String? posActionName,
      VoidCallback? posAction,
      bool barrierDismissible = true}) {
    // TODO: implement showMyMessage
    List<Widget> actions = [];
    if (posActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            posAction?.call();
          },
          child: Text(posActionName)));
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

    // DialogUtils.showMessage(
    //   context, message,
    //   barrierDismissible: false,
    //   posActionName: posActionName,
    // );
  }
}
