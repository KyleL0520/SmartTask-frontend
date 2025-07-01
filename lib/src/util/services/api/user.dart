import 'package:flutter/material.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/util/services/api/index.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';
import 'package:provider/provider.dart';

class UserService extends API {
  final String _baseUrl = "/api/user";

  Future<User?> updateUser(BuildContext context, User user) async {
    final authStorage = Provider.of<AuthStorage>(context, listen: false);

    try {
      final response = await dio.put(
        '$_baseUrl/${user.uid}',
        data: user.toJson(),
      );
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
}
