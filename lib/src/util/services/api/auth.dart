import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/util/services/api/index.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AuthService extends API {
  final String _baseUrl = "/api/auth";

  Future<bool?> signUp(String username, String email, String password) async {
    try {
      final byteData = await rootBundle.load('assets/images/defaultAvatar.png');
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/defaultAvatar.png');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      final formData = FormData.fromMap({
        'username': username,
        'email': email,
        'password': password,
        'avatarPhoto': await MultipartFile.fromFile(
          tempFile.path,
          filename: 'defaultAvatar.png',
        ),
      });

      final response = await dio.post('$_baseUrl/signup', data: formData);

      if (response.statusCode == 201) {
        return true;
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    final authStorage = Provider.of<AuthStorage>(context, listen: false);

    try {
      final response = await dio.post(
        '$_baseUrl/login',
        data: {"email": email, "password": password},
      );

      print(response.data);

      if (response.statusCode == 201) {
        User userResponse = User.fromJson(response.data['user']);

        authStorage.setUser(userResponse);
        authStorage.setAccessToken(response.data['token']);
        authStorage.setRefreshToken(response.data['refreshToken']);

        return userResponse;
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> profile(BuildContext context) async {
    final authStorage = Provider.of<AuthStorage>(context, listen: false);

    try {
      final response = await dio.get('$_baseUrl/profile');

      if (response.statusCode == 200) {
        User userResponse = User.fromJson(response.data);
        authStorage.setUser(userResponse);

        return userResponse;
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> logout(BuildContext context) async {
    final authStorage = Provider.of<AuthStorage>(context, listen: false);
    try {
      final response = await dio.post('$_baseUrl/logout');

      if (response.statusCode == 201) {
        await authStorage.clear();
        return true;
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> forgotPassword(String email) async {
    try {
      final response = await dio.post(
        '$_baseUrl/forgot-password',
        data: {"email": email},
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> validate(String email, String otp) async {
    try {
      final response = await dio.post(
        '$_baseUrl/validate',
        data: {"otp": otp, "email": email},
      );

      return response.data == "true";
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> resetPassword(String email, String password) async {
    try {
      final response = await dio.post(
        '$_baseUrl/reset-password',
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }
}
