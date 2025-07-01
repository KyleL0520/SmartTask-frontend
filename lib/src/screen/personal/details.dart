import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/models/task.dart';
import 'package:frontend/src/screen/widgets/bottom_nav.dart';
import 'package:frontend/src/util/services/api/task.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';
import 'package:frontend/src/widgets/display/ui_notify.dart';
import 'package:frontend/src/widgets/input/button.dart';
import 'package:frontend/src/widgets/label/label.dart';
import 'package:intl/intl.dart';

@RoutePage()
class PersonalTaskDetailsScreen extends StatefulWidget {
  final Task task;
  final void Function(Task? savedTask)? afterSave;
  const PersonalTaskDetailsScreen({
    super.key,
    required this.task,
    this.afterSave,
  });

  @override
  State<PersonalTaskDetailsScreen> createState() =>
      _PersonalTaskDetailsScreenState();
}

class _PersonalTaskDetailsScreenState extends State<PersonalTaskDetailsScreen> {
  bool _isLoading = false;
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
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

  Future<void> _deleteTask(String taskId) async {
    try {
      final response = await TaskService().deleteTask(taskId);

      if (response == null) {
        return;
      }

      if (!mounted) return;
      UINotify.success(context, 'Task deleted');
      widget.afterSave!(response);
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

  void refreshTask(Task newTask) {
    setState(() {
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
          TextButton(
            onPressed: () {
              context.pushRoute(
                FormRoute(
                  task: widget.task,
                  afterSave: (Task? newTask) {
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
          ),
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
                  widget.task.title,
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
                      formatTimestamp(
                        widget.task.deadlinesDate,
                        widget.task.deadlinesTime,
                      ),
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomLabel(text: 'Description'),
                const SizedBox(height: 6),
                Text(
                  widget.task.description,
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: 20),
                widget.task.category != null
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomLabel(text: 'Category'),
                        _data(widget.task.category!.name),
                      ],
                    )
                    : SizedBox(),
                const SizedBox(height: 20),
                widget.task.reminderDate == null ||
                        widget.task.reminderDate == ''
                    ? SizedBox()
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomLabel(text: 'Reminder'),
                        _data(
                          formatTimestamp(
                            widget.task.reminderDate!,
                            widget.task.reminderTime!,
                          ),
                        ),
                      ],
                    ),
                const SizedBox(height: 20),
                widget.task.priority == null || widget.task.priority == ''
                    ? SizedBox()
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomLabel(text: 'Priority'),
                        _data(widget.task.priority!),
                      ],
                    ),
                const SizedBox(height: 20),
                DeleteButton(
                  isLoading: _isLoading,
                  handle: () => _deleteTask(widget.task.id),
                ),
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
