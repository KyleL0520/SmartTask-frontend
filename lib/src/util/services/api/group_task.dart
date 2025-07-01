import 'package:frontend/src/models/group_task.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/util/services/api/index.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';

class GroupTaskService extends API {
  final String _baseUrl = "/api/group-task";

  Future<List<GroupTask>?> getGroupTasks() async {
    User? user = await AuthStorage().getUser();

    try {
      final response = await dio.get(
        _baseUrl,
        queryParameters: {"user": user?.uid},
      );

      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'];
        final List<GroupTask> groupTasks =
            items.map((item) => GroupTask.fromJson(item)).toList();
        return groupTasks;
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> getUser() async {
    try {
      final response = await dio.get('$_baseUrl/user');
      print('Raw user response: ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<GroupTask?> createGroupTask({
    required String projectName,
    required String projectDescription,
  }) async {
    User? user = await AuthStorage().getUser();

    final data = {
      'owner': user?.uid,
      'projectName': projectName,
      'projectDescription': projectDescription,
    };

    try {
      final response = await dio.post(_baseUrl, data: data);

      if (response.statusCode == 201) {
        return GroupTask.fromJson(response.data);
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> updateGroupTask(String id, GroupTask groupTask) async {
    try {
      final response = await dio.put('$_baseUrl/$id', data: groupTask);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> deleteGroupTask(String id) async {
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
