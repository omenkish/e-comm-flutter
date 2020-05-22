import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shoppingapp/models/http_exception.dart';

class Auth  with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const API_KEY = 'AIzaSyDcV_YGw60aQC7JiS0FeGPRmHX0Hy_c7n4';

  bool get isAuthenticated {
    return token != null;
  }

  String get token {
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    try {
      final url  = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$API_KEY';
      final response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final SharedPreferences preferences = await _prefs;
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'exoiryDate': _expiryDate.toIso8601String()
      });
      preferences.setString('userData', userData);
    } catch (err) {
      throw err;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final SharedPreferences preferences = await _prefs;
    if (!preferences.containsKey('userData')) return false;
    
    final userData = json.decode(preferences.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(userData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = userData['expiryDate'];
    notifyListeners();
    _autoLogout();
    return true;
  }
  
  Future<void> logout() async {
    _expiryDate = null;
    _token = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final SharedPreferences preferences = await _prefs;
    preferences.remove('userData');
//  preferences.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
