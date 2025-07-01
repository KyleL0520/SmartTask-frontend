import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:frontend/src/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> setUser(User user) async {
    _user = user;

    final preferences = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await preferences.setString('USER', userJson);

    notifyListeners();
  }

  Future<void> removeUser() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('USER');

    notifyListeners();
  }

  Future<void> setAccessToken(String accessToken) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('ACCESS_TOKEN', accessToken);
  }

  Future<void> setRefreshToken(String refreshToken) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('REFRESH_TOKEN', refreshToken);
  }

  Future<void> clear() async {
    _user = null;

    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('USER');
    await preferences.remove('ACCESS_TOKEN');
    await preferences.remove('REFRESH_TOKEN');

    notifyListeners();
  }

  Future<String?> get getToken async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('ACCESS_TOKEN');
  }

  Future<String?> get getRefreshToken async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('REFRESH_TOKEN');
  }

  Future<bool> get tokenExists async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.containsKey('ACCESS_TOKEN');
  }

  Future<User?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    String? userJson = preferences.getString('USER');

    if (userJson == null) {
      _user = null;
      return null;
    }

    _user = User.fromJson(jsonDecode(userJson));
    notifyListeners();
    return _user;
  }
}
