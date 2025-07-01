import 'package:frontend/src/models/task.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/util/services/api/index.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';

class TaskService extends API {
  final String _baseUrl = "/api/task";

  Future<List<Task>?> getTasks({String? status, bool? isGroupTask}) async {
    User? user = await AuthStorage().getUser();

    try {
      final response = await dio.get(
        _baseUrl,
        queryParameters: {
          "user": user?.uid,
          "status": status,
          "isGroupTask": isGroupTask,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'];
        final List<Task> tasks =
            items.map((item) => Task.fromJson(item)).toList();
        return tasks;
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Task?> createTask({
    required String title,
    required String description,
    String? category,
    required String deadlinesDate,
    required String deadlinesTime,
    String? reminderDate,
    String? reminderTime,
    String? priority,
  }) async {
    User? user = await AuthStorage().getUser();

    try {
      final response = await dio.post(
        _baseUrl,
        data: {
          'user': user?.uid,
          'title': title,
          'description': description,
          'category': category,
          'deadlinesDate': deadlinesDate,
          'deadlinesTime': deadlinesTime,
          'reminderDate': reminderDate,
          'reminderTime': reminderTime,
          'priority': priority,
        },
      );

      print(response.data);

      if (response.statusCode == 201) {
        return Task.fromJson(response.data);
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Task?> createCollaborationTask({
    required String uid,
    required String taskName,
    required String taskDescription,
    required String deadlinesDate,
    required String deadlinesTime,
    required String groupTask,
  }) async {
    try {
      final response = await dio.post(
        _baseUrl,
        data: {
          'user': uid,
          'title': taskName,
          'description': taskDescription,
          'deadlinesDate': deadlinesDate,
          'deadlinesTime': deadlinesTime,
          'groupTask': groupTask,
        },
      );

      if (response.statusCode == 201) {
        return Task.fromJson(response.data);
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Task?> updateTask(Task task) async {
    try {
      final response = await dio.put(
        '$_baseUrl/${task.id}',
        data: task.toJson(),
      );
      if (response.statusCode == 200) {
        return Task.fromJson(response.data);
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Task?> deleteTask(String id) async {
    try {
      final response = await dio.delete('$_baseUrl/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return Task.fromJson(response.data);
      } else {
        throw response;
      }
    } catch (e) {
      rethrow;
    }
  }
}
