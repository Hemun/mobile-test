import 'package:flutter/material.dart';
import 'package:last_exam/model/users.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String token = "";
  int? userID = 0;
  User? user;

  bool get isLoggedIn => _isLoggedIn;

  void setToken(String nToken) {
    token = nToken;
  }

  void setID(int? newID) {
    userID = newID;
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void setUser(User? newUser) {
    user = newUser;
  }

  int? getUserID() {
    return userID;
  }
}
