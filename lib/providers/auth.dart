import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBr2_xcq-qV9QTkoajScpJfYtuLd5Eot80';

    return await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
  }

  Future<void> login(String email, String password) async {
    final response = _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> signup(String email, String password) async {
    final response = _authenticate(email, password, 'signUp');
  }
}
