import 'package:frontend/src/models/category.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/util/services/api/index.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';

class CategoryService extends API {
  final String _baseUrl = "/api/category";

  Future<List<Category>?> getCategorys() async {
    User? user = await AuthStorage().getUser();

    try {
      final response = await dio.get(
        _baseUrl,
        queryParameters: {"user": user?.uid},
      );

      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'];
        final List<Category> categorys =
            items.map((item) => Category.fromJson(item)).toList();
        return categorys;
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> createCategory(String name) async {
    User? user = await AuthStorage().getUser();

    try {
      final response = await dio.post(
        _baseUrl,
        data: {'name': name, 'user': user?.uid},
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

  Future<bool?> deleteCategory(String id) async {
    try {
      final response = await dio.delete('$_baseUrl/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }
}
