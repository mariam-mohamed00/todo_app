import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/register/custom_text_form_field.dart';
import 'package:todo/auth/register/register_screen.dart';
import 'package:todo/dialog_utils.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/home/home_screen.dart';
import 'package:todo/providers/app_config_provider.dart';
import 'package:todo/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/main_background.png',
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Form(
            key: formKey,
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
                    controller: emailController,
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
                    controller: passwordController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppLocalizations.of(context)!.validate_password;
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
                        login();
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
    );
  }

  void login() async {
    if (formKey.currentState!.validate() == true) {
      DialogUtils.showLoading(context, AppLocalizations.of(context)!.loading);
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        var user = await FirebaseUtils.readUserFromFireStore(
            credential.user?.uid ?? '');
        if (user == null) {
          return;
        }
        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updateUser(user);
        // todo: hide loading
        // todo: show message
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context, AppLocalizations.of(context)!.login_message_success,
            title: AppLocalizations.of(context)!.success_title,
            posActionName: AppLocalizations.of(context)!.ok,
            barrierDismissible: false, posAction: () {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          // todo: hide loading
          // todo : show message
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context, AppLocalizations.of(context)!.login_message_error,
              title: AppLocalizations.of(context)!.error_title,
              posActionName: AppLocalizations.of(context)!.ok,
              barrierDismissible: false);
        }
      } catch (e) {
        // todo: hide loading
        // todo : show messageAA
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, e.toString(),
            title: AppLocalizations.of(context)!.error_title,
            posActionName: AppLocalizations.of(context)!.ok,
            barrierDismissible: false);

        print(e);
      }
    }
  }
}
