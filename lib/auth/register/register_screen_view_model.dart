import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/register/register_navigator.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/model/my_user.dart';
import 'package:todo/providers/auth_provider.dart';

class RegisterScreenViewModel extends ChangeNotifier {
  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmationPasswordController = TextEditingController();

  // todo : hold data - handle data

  late RegisterNavigator navigator;

  void register(String email, String password, BuildContext context) async {
    // todo: show loading
    navigator.showMyLoading();

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      MyUser myUser = MyUser(
          id: credential.user?.uid ?? '',
          name: nameController.text,
          email: emailController.text);
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.updateUser(myUser);
      await FirebaseUtils.addUserToFireStore(myUser);

      // todo: hide loading
      navigator.hideMyLoading();
      // todo: show message

      navigator.showMyMessage(
        AppLocalizations.of(context)!.register_message_success,
        // AppLocalizations.of(context)!.success_title,
        //         AppLocalizations.of(context)!.ok,
        //       () {
        //           Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        //        },
        // false
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // todo: hide loading
        navigator.hideMyLoading();

        // todo: show message
        navigator.showMyMessage(
          'The password provided is too weak',
          // AppLocalizations.of(context)!.error_title,
          //   AppLocalizations.of(context)!.ok,
          //     () {},
          // false
        );
      } else if (e.code == 'email-already-in-use') {
        // todo: hide loading
        navigator.hideMyLoading();

        // todo: show message
        navigator.showMyMessage(
          AppLocalizations.of(context)!.register_message_email_exist,
          // AppLocalizations.of(context)!.error_title,
          //            AppLocalizations.of(context)!.ok,
          //                () {},
          // false);
        );
      }
    } catch (e) {
      // todo: hide loading
      navigator.hideMyLoading();

      // todo: show message
      navigator.showMyMessage(
        e.toString(),
        // AppLocalizations.of(context)!.error_title, AppLocalizations.of(context)!.ok,
        //     () {},
      );
    }
  }
}
