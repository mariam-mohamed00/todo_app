import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/login/login_screen.dart';
import 'package:todo/auth/register/custom_text_form_field.dart';
import 'package:todo/auth/register/register_navigator.dart';
import 'package:todo/auth/register/register_screen_view_model.dart';
import 'package:todo/dialog_utils.dart';
import 'package:todo/home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    implements RegisterNavigator {
  var formKey = GlobalKey<FormState>();

  RegisterScreenViewModel viewModel = RegisterScreenViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => viewModel,
        child: Stack(
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
                      controller: viewModel.nameController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!
                              .validate_user_name;
                        }
                        return null;
                      },
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
                    CustomTextFormField(
                      isPassword: true,
                      label:
                          AppLocalizations.of(context)!.confirmation_password,
                      keyboardType: TextInputType.number,
                      controller: viewModel.confirmationPasswordController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!
                              .validate_password;
                        }
                        if (text != viewModel.passwordController.text) {
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
                          Navigator.of(context)
                              .pushNamed(LoginScreen.routeName);
                        },
                        child: Text(
                            AppLocalizations.of(context)!.have_an_account)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void register() async {
    if (formKey.currentState!.validate() == true) {
      viewModel.register(viewModel.emailController.text,
          viewModel.passwordController.text, context);
    }
  }

  @override
  void hideMyLoading() {
    DialogUtils.hideLoading(context);
  }

  @override
  void showMyLoading() {
    DialogUtils.showLoading(context, 'Waiting...');
  }

  @override
  void showMyMessage(String message) {
    // TODO: implement showMyMessage
    DialogUtils.showMessage(context, message,
        posActionName: AppLocalizations.of(context)!.ok, posAction: () {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }, barrierDismissible: false);

    // Navigator.pushNamed(context, HomeScreen.routeName);
    setState(() {});
  }
}
