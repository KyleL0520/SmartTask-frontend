import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/models/task.dart';
import 'package:frontend/src/util/services/api/task.dart';
import 'package:frontend/src/util/utils.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';
import 'package:frontend/src/widgets/display/ui_notify.dart';
import 'package:intl/intl.dart';

final List<String> status = ['Pending', 'Completed'];

@RoutePage()
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime dateTime;
  late String date;
  late Future<List<Task>?> _personalTasks;
  late Future<List<Task>?> _groupTasks;
  String selectedStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dateTime = now;
    date = DateFormat('dd-MM-yyyy').format(now);
    _personalTasks = TaskService().getTasks(isGroupTask: false);
    _groupTasks = TaskService().getTasks(isGroupTask: true, isApproved: true);
  }

  Future<void> refreshTask() async {
    _personalTasks = TaskService().getTasks(isGroupTask: false);
    _groupTasks = TaskService().getTasks(isGroupTask: true, isApproved: true);
    setState(() {});
  }

  Future<void> _updateTaskStatus({
    required Task task,
    required String status,
  }) async {
    task.status = status;

    try {
      final response = await TaskService().updateTaskStatus(task);

      if (response == null) return;

      if (!mounted) return;
      await refreshTask();
    } catch (e) {
      if (!mounted) return;
      UINotify.error(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Calendar', isCenterTitle: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Today',
                  style: TextStyle(color: AppColors.grey, fontSize: 15),
                ),
                Text(
                  DateFormat('EEEE, dd MMM').format(DateTime.now()),
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap:
                      () => showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (context) => _buildDatePicker(),
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          color: TAppTheme.secondaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: AppColors.grey,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children:
                      status.map((s) {
                        bool isSelected = selectedStatus == s;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? TAppTheme.secondaryColor
                                        : TAppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.grey,
                                    blurRadius: 3,
                                    offset: Offset(3, 3),
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedStatus = s;
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    isSelected
                                        ? TAppTheme.secondaryColor
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Text(
                                  s,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? TAppTheme.primaryColor
                                            : AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 30),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder(
                        future: _personalTasks,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Text("No tasks found.");
                          }

                          final filteredTasks =
                              snapshot.data!.where((t) {
                                try {
                                  final deadlineDate = DateFormat(
                                    'd MMMM yyyy',
                                  ).parse(t.deadlinesDate);
                                  final deadlineTime = DateFormat(
                                    'hh : mm a',
                                  ).parse(t.deadlinesTime);

                                  final deadline = DateTime(
                                    deadlineDate.year,
                                    deadlineDate.month,
                                    deadlineDate.day,
                                    deadlineTime.hour,
                                    deadlineTime.minute,
                                  );

                                  final formattedDeadline = DateFormat(
                                    'dd-MM-yyyy',
                                  ).format(deadline);

                                  return t.status.toLowerCase() ==
                                          selectedStatus.toLowerCase() &&
                                      formattedDeadline == date;
                                } catch (e) {
                                  return false;
                                }
                              }).toList();

                          return Column(
                            children:
                                filteredTasks.map((task) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: TAppTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColors.grey,
                                          offset: Offset(2, 2),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 5),
                                        GestureDetector(
                                          onTap:
                                              () =>
                                                  task.status == 'Completed'
                                                      ? _updateTaskStatus(
                                                        task: task,
                                                        status: 'Pending',
                                                      )
                                                      : _updateTaskStatus(
                                                        task: task,
                                                        status: 'Completed',
                                                      ),
                                          child: Container(
                                            width: 16,
                                            height: 16,
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                width: 2,
                                                color: Utils.getPriorityColor(
                                                  task.priority,
                                                ),
                                              ),
                                              color:
                                                  task.status == 'Completed'
                                                      ? AppColors.black
                                                      : Colors.transparent,
                                            ),
                                            child:
                                                task.status == 'Completed'
                                                    ? Icon(
                                                      Icons.check,
                                                      color:
                                                          TAppTheme
                                                              .primaryColor,
                                                      size: 12,
                                                    )
                                                    : SizedBox(),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () => context.pushRoute(
                                                PersonalTaskDetailsRoute(
                                                  task: task,
                                                ),
                                              ),
                                          child: Text(
                                            task.title,
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        if (task.isExpired)
                                          Text(
                                            'Expired',
                                            style: TextStyle(
                                              color: AppColors.red,
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Group',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder(
                        future: _groupTasks,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Text("No tasks found.");
                          }

                          final filteredTasks =
                              snapshot.data!.where((t) {
                                try {
                                  final deadlineDate = DateFormat(
                                    'd MMMM yyyy',
                                  ).parse(t.deadlinesDate);
                                  final deadlineTime = DateFormat(
                                    'hh : mm a',
                                  ).parse(t.deadlinesTime);

                                  final deadline = DateTime(
                                    deadlineDate.year,
                                    deadlineDate.month,
                                    deadlineDate.day,
                                    deadlineTime.hour,
                                    deadlineTime.minute,
                                  );

                                  final formattedDeadline = DateFormat(
                                    'dd-MM-yyyy',
                                  ).format(deadline);

                                  return t.status.toLowerCase() ==
                                          selectedStatus.toLowerCase() &&
                                      formattedDeadline == date;
                                } catch (e) {
                                  return false;
                                }
                              }).toList();

                          return Column(
                            children:
                                filteredTasks.map((task) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: TAppTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: AppColors.grey,
                                          offset: Offset(2, 2),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 5),
                                        GestureDetector(
                                          onTap:
                                              () =>
                                                  task.status == 'Completed'
                                                      ? _updateTaskStatus(
                                                        task: task,
                                                        status: 'Pending',
                                                      )
                                                      : _updateTaskStatus(
                                                        task: task,
                                                        status: 'Completed',
                                                      ),
                                          child: Container(
                                            width: 16,
                                            height: 16,
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                width: 2,
                                                color: Utils.getPriorityColor(
                                                  task.priority,
                                                ),
                                              ),
                                              color:
                                                  task.status == 'Completed'
                                                      ? AppColors.black
                                                      : Colors.transparent,
                                            ),
                                            child:
                                                task.status == 'Completed'
                                                    ? Icon(
                                                      Icons.check,
                                                      color:
                                                          TAppTheme
                                                              .primaryColor,
                                                      size: 12,
                                                    )
                                                    : SizedBox(),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed:
                                              task.groupTask == null
                                                  ? null
                                                  : () => context.pushRoute(
                                                    GroupTaskDetailsRoute(
                                                      groupTask:
                                                          task.groupTask!,
                                                    ),
                                                  ),
                                          child: Text(
                                            task.title,
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() => SizedBox(
    height: 200,
    child: Column(
      children: [
        Expanded(
          child: CupertinoDatePicker(
            initialDateTime: dateTime,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged:
                (DateTime newDate) => setState(() {
                  dateTime = newDate;
                  date = DateFormat('dd-MM-yyyy').format(newDate);
                  refreshTask();
                }),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Done',
            style: TextStyle(color: TAppTheme.secondaryColor, fontSize: 16),
          ),
        ),
      ],
    ),
  );
}
