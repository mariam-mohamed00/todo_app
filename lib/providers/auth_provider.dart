import 'package:flutter/material.dart';
import 'package:todo/model/my_user.dart';

class AuthProvider extends ChangeNotifier {
  MyUser? currentuser;

  void updateUser(MyUser newUser) {
    currentuser = newUser;
    notifyListeners();
  }
}
