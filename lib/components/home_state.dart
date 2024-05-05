import 'package:flutter/material.dart';
import 'package:pharma_app/components/login_state.dart';

class HomeState extends ChangeNotifier {
  LoginState? _auth;

  var _index = 0;

  int get index => _index;

  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }

  void update(LoginState auth) async {
    _auth = auth;
    await _auth?.loadToken();
    if (!_auth!.isLoggedIn()) {
      _index = 3;
    }
    notifyListeners();
  }
}
