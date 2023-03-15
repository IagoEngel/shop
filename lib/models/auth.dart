import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  Future<void> authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyB88pHvvlHc3Yuzq1xNGjjObD1XA4v0QMk';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    print(response.body);
  }

  Future<void> signUp(String email, String password) async {
    await authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    await authenticate(email, password, 'signInWithPassword');
  }
}
