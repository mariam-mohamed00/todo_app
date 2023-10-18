import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/login/login_screen.dart';
import 'package:todo/auth/register/custom_text_form_field.dart';
import 'package:todo/dialog_utils.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/model/my_user.dart';

import '../../home/home_screen.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmationPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    label: AppLocalizations.of(context)!.user_name,
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppLocalizations.of(context)!.validate_user_name;
                      }
                      return null;
                    },
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
                  CustomTextFormField(
                    isPassword: true,
                    label: AppLocalizations.of(context)!.confirmation_password,
                    keyboardType: TextInputType.number,
                    controller: confirmationPasswordController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppLocalizations.of(context)!.validate_password;
                      }
                      if (text != passwordController.text) {
                        return AppLocalizations.of(context)!
                            .validate_confirm_password;
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        register();
                      },
                      child: Text(AppLocalizations.of(context)!.register,
                          style: Theme.of(context).textTheme.titleLarge),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(LoginScreen.routeName);
                      },
                      child:
                          Text(AppLocalizations.of(context)!.have_an_account)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void register() async {
    if (formKey.currentState!.validate() == true) {
      // todo: show loading
      DialogUtils.showLoading(context, AppLocalizations.of(context)!.loading);
      // await Future.delayed(Duration(seconds: 2));
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text);
        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updateUser(myUser);
        await FirebaseUtils.addUserToFireStore(myUser);
        // todo: hide loading
        // todo: show message
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context, AppLocalizations.of(context)!.register_message_success,
            title: AppLocalizations.of(context)!.success_title,
            posActionName: AppLocalizations.of(context)!.ok,
            barrierDismissible: false, posAction: () {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // todo: hide loading
          // todo: show message
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context, 'The password provided is too weak',
              title: AppLocalizations.of(context)!.error_title,
              posActionName: AppLocalizations.of(context)!.ok);

          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          // todo: hide loading
          // todo: show message
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context,
              AppLocalizations.of(context)!.register_message_email_exist,
              title: AppLocalizations.of(context)!.error_title,
              posActionName: AppLocalizations.of(context)!.ok,
              barrierDismissible: false);
        }
      } catch (e) {
        // todo: hide loading
        // todo: show message
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, e.toString(),
            title: AppLocalizations.of(context)!.error_title,
            posActionName: AppLocalizations.of(context)!.ok);

        print(e);
      }
    }
  }
}
