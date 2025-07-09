import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/models/task.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/screen/widgets/bottom_nav.dart';
import 'package:frontend/src/util/services/api/task.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';
import 'package:frontend/src/widgets/display/ui_notify.dart';
import 'package:frontend/src/widgets/input/button.dart';
import 'package:frontend/src/widgets/label/label.dart';
import 'package:intl/intl.dart';

@RoutePage()
class PersonalTaskDetailsScreen extends StatefulWidget {
  final Task task;
  final void Function(Task? savedTask)? afterTaskSave;
  const PersonalTaskDetailsScreen({
    super.key,
    required this.task,
    this.afterTaskSave,
  });

  @override
  State<PersonalTaskDetailsScreen> createState() =>
      _PersonalTaskDetailsScreenState();
}

class _PersonalTaskDetailsScreenState extends State<PersonalTaskDetailsScreen> {
  bool _isLoading = false;
  late Task _task;
  User? user;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _loadUser();
  }

  String formatTimestamp(String date, String time) {
    try {
      final cleanedTime = time.replaceAll(RegExp(r'\s*:\s*'), ':').trim();
      final cleanedDate = date.trim();

      final cleanedDateTime = '$cleanedDate $cleanedTime';

      final inputFormat = DateFormat('dd MMMM yyyy hh:mm a');
      final outputFormat = DateFormat('dd MMMM, \'at\' hh : mm a');

      // Parse and format
      final parsedDate = inputFormat.parse(cleanedDateTime);
      return outputFormat.format(parsedDate);
    } catch (e) {
      debugPrint('Error parsing timestamp: $e');
      debugPrint('Date input: "$date", Time input: "$time"');
      return '$date $time';
    }
  }

  Future<void> _handleDeleteTask(String taskId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await TaskService().deleteTask(taskId);

      if (response == null) return;

      if (!mounted) return;
      UINotify.success(context, 'Task deleted');
      widget.afterTaskSave!(response);
      AutoRouter.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      UINotify.error(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUser() async {
    final fetchedUser = await AuthStorage().getUser();
    setState(() {
      user = fetchedUser;
    });
  }

  void refreshTask(Task newTask) {
    setState(() async {
      _task = newTask;
    });
    TaskScreenCallbackRegistry.refresh?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Task Details',
        isCenterTitle: true,
        actions: [
          _task.groupTask == null
              ? TextButton(
                onPressed: () {
                  AutoRouter.of(context).push(
                    FormRoute(
                      task: _task,
                      afterTaskSave: (Task? newTask) {
                        if (newTask == null) {
                          print('Edit pop back error');
                          return;
                        }
                        refreshTask(newTask);
                      },
                    ),
                  );
                },
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: TAppTheme.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              )
              : SizedBox(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  _task.title,
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.date_range),
                    const SizedBox(width: 10),
                    Text(
                      formatTimestamp(_task.deadlinesDate, _task.deadlinesTime),
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomLabel(text: 'Description'),
                const SizedBox(height: 6),
                Text(
                  _task.description,
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: 20),
                _task.category != null
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomLabel(text: 'Category'),
                        _data(_task.category!.name),
                      ],
                    )
                    : SizedBox(),
                const SizedBox(height: 20),
                _task.reminderDate == null || _task.reminderDate == ''
                    ? SizedBox()
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomLabel(text: 'Reminder'),
                        _data(
                          formatTimestamp(
                            _task.reminderDate!,
                            _task.reminderTime!,
                          ),
                        ),
                      ],
                    ),
                const SizedBox(height: 20),
                _task.priority == null || _task.priority == ''
                    ? SizedBox()
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomLabel(text: 'Priority'),
                        _data(_task.priority!),
                      ],
                    ),
                const SizedBox(height: 20),
                _task.groupTask == null ||
                        _task.groupTask?.owner.uid == user?.uid
                    ? DeleteButton(
                      isLoading: _isLoading,
                      handle: () => _handleDeleteTask(_task.id),
                    )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _data(String text) {
    return Text(text, style: TextStyle(color: AppColors.grey));
  }
}
