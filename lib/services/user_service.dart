// added auth service to authenticate against dummyjson's endpoints for enhancement 1
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserService {
  static const String _host = 'https://dummyjson.com';
  static const String _kUserKey = 'auth_user';
  static const String _kIsLoggedInKey = 'auth_is_logged_in';

  // added a feature where it calls POST /auth/login with the needed attributes to authenticate the user for enhancement 1
  Future<User> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$_host/auth/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 60,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final User user = User.fromJson(data);
      await _saveSession(user);
      return user;
    }

    String message = 'Invalid username or password.';
    try {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['message'] != null) message = data['message'];
    } catch (_) {
      // response wasn't valid json, fall back to the default message above
    }
    throw Exception(message);
  }

  // added a feature to save the logged-in user as json so the session survives an app restart for enhancement 1
  Future<void> _saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserKey, jsonEncode(user.toJson()));
    await prefs.setBool(_kIsLoggedInKey, true);
  }

  // used by SplashScreen to decide whether to go straight to /home or /login for enhancement 1
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kIsLoggedInKey) ?? false;
  }

  // reads the saved user back out of shared_preferences so screens don't need the user passed in manually for enhancement 1
  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_kUserKey);
    if (raw == null) return null;

    try {
      return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  // clears the saved session; wired to the Sign Out action on the settings screen for enhancement 2
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserKey);
    await prefs.setBool(_kIsLoggedInKey, false);
  }
}
