import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState extends ChangeNotifier {
  var accessToken = 'null';
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  String get token => accessToken;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenSaved = prefs.getString('access_token') ?? "null";
    if (tokenSaved != "null") {
      accessToken = tokenSaved;
    }
    notifyListeners();
  }

  Future<bool> login() async {
    // Create a map with the username and password fields
    final body = {
      'username': username.text,
      'password': password.text,
    };
    // Send a POST request to the authentication endpoint
    final response = await http.post(
      Uri.parse('http://172.31.219.169:8000/auth/token'),
      body: body,
    );

    print(response);
    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the response body to extract the access token
      final responseBody = json.decode(response.body);
      final ac = responseBody['access_token'];
      print(ac);

      // Store the access token in the key-value store
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', ac);

      // Update the accessToken variable and notify listeners
      accessToken = accessToken;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    accessToken = 'null';
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('access_token');
    });
    notifyListeners();
  }

  bool isLoggedIn() {
    if (accessToken == 'null') {
      return false;
    } else {
      return true;
    }
  }
}
