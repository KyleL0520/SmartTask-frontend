import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/models/group_task.dart';
import 'package:frontend/src/models/task.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/screen/widgets/bottom_nav.dart';
import 'package:frontend/src/util/services/api/group_task.dart';
import 'package:frontend/src/util/services/api/task.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';
import 'package:frontend/src/util/utils.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';
import 'package:frontend/src/widgets/display/ui_notify.dart';
import 'package:frontend/src/widgets/input/button.dart';
import 'package:frontend/src/widgets/label/label.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

@RoutePage()
class GroupTaskDetailsScreen extends StatefulWidget {
  final GroupTask groupTask;
  final void Function(GroupTask? savedGroupTask)? afterGroupTaskSave;
  const GroupTaskDetailsScreen({
    super.key,
    required this.groupTask,
    this.afterGroupTaskSave,
  });

  @override
  State<GroupTaskDetailsScreen> createState() => _GroupTaskDetailsScreenState();
}

class _GroupTaskDetailsScreenState extends State<GroupTaskDetailsScreen> {
  bool _isLoading = false;

  late GroupTask _groupTask;
  late Future<List<Task>?> _allTasksInGroup;
  double percent = 0.0;
  User? user;

  @override
  void initState() {
    super.initState();
    _groupTask = widget.groupTask;
    _allTasksInGroup = TaskService().getTasks(
      groupTaskId: widget.groupTask.id,
      isByUser: false,
    );
    _calculatePercent();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final fetchedUser = await AuthStorage().getUser();
    setState(() {
      user = fetchedUser;
    });
  }

  Future<void> refreshGroupTask(GroupTask newGroupTask) async {
    setState(() {
      _groupTask = newGroupTask;
      _allTasksInGroup = TaskService().getTasks(
        groupTaskId: widget.groupTask.id,
        isByUser: false,
      );
    });
    TaskScreenCallbackRegistry.refresh?.call();
  }

  Future<void> refreshTask() async {
    _allTasksInGroup = TaskService().getTasks(
      groupTaskId: widget.groupTask.id,
      isByUser: false,
    );
    setState(() {});
  }

  Future<void> _calculatePercent() async {
    final tasks = await _allTasksInGroup;

    if (tasks == null || tasks.isEmpty) return;
    final total = tasks.length;
    final filtered = tasks.where((t) => t.status == 'Completed').length;

    setState(() {
      percent = (filtered / total);
    });
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
      await _calculatePercent();
    } catch (e) {
      if (!mounted) return;
      UINotify.error(context, e);
    }
  }

  Future<void> _deleteGroupTask() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tasks = await _allTasksInGroup;
      if (tasks != null && tasks.isNotEmpty) {
        await Future.wait(tasks.map((t) => TaskService().deleteTask(t.id)));
      }
      final gtResponse = await GroupTaskService().deleteGroupTask(
        widget.groupTask.id,
      );

      if (gtResponse == null) return;

      if (!mounted) return;
      UINotify.success(context, 'Group task deleted');
      if (widget.afterGroupTaskSave != null) {
        widget.afterGroupTaskSave?.call(gtResponse);
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Project Details',
        isCenterTitle: true,
        actions: [
          user?.uid == _groupTask.owner.uid
              ? TextButton(
                onPressed: () {
                  AutoRouter.of(context).push(
                    FormRoute(
                      groupTask: _groupTask,
                      afterGroupTaskSave: (GroupTask? newGroupTask) {
                        if (newGroupTask == null) {
                          print('Edit pop back error');
                          return;
                        }
                        refreshGroupTask(newGroupTask);
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
                  _groupTask.projectName,
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'In Progress',
                      style: TextStyle(fontSize: 16, color: AppColors.black),
                    ),
                    Text(
                      percent.toString(),
                      style: TextStyle(fontSize: 16, color: AppColors.black),
                    ),
                  ],
                ),
                LinearPercentIndicator(
                  lineHeight: 20,
                  percent: percent,
                  progressColor: TAppTheme.secondaryColor,
                  backgroundColor: AppColors.grey,
                  animation: true,
                  animationDuration: 800,
                  barRadius: Radius.circular(10),
                  center: Text(
                    '${(percent * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomLabel(text: 'Overview'),
                const SizedBox(height: 6),
                Text(
                  _groupTask.projectDescription,
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: 20),
                CustomLabel(text: 'Members'),
                const SizedBox(height: 6),
                FutureBuilder(
                  future: _allTasksInGroup,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final tasks = snapshot.data;

                    if (tasks == null || tasks.isEmpty) {
                      return const Center(child: Text(""));
                    }

                    return Row(
                      children:
                          tasks
                              .map((task) {
                                final user = task.user;

                                if (user.avatarPhoto.isEmpty) {
                                  return const SizedBox();
                                }

                                final avatar = user.avatarPhoto;
                                Image imageWidget;

                                if (avatar.startsWith('assets/')) {
                                  imageWidget = Image.asset(
                                    avatar,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  );
                                } else if (avatar.startsWith('http')) {
                                  imageWidget = Image.network(
                                    avatar,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  imageWidget = Image.file(
                                    File(avatar),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ClipOval(child: imageWidget),
                                );
                              })
                              .toSet()
                              .toList(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                CustomLabel(text: 'Tasks'),
                const SizedBox(height: 6),
                FutureBuilder(
                  future: _allTasksInGroup,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final tasks = snapshot.data;

                    if (tasks == null || tasks.isEmpty) {
                      return const Center(child: Text("No tasks found"));
                    }

                    return Column(
                      children:
                          tasks.map((t) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 5),
                                      t.isApproved
                                          ? t.user.uid == user?.uid
                                              ? GestureDetector(
                                                onTap:
                                                    () =>
                                                        t.status == 'Completed'
                                                            ? _updateTaskStatus(
                                                              task: t,
                                                              status: 'Pending',
                                                            )
                                                            : _updateTaskStatus(
                                                              task: t,
                                                              status:
                                                                  'Completed',
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
                                                      color:
                                                          Utils.getPriorityColor(
                                                            t.priority,
                                                          ),
                                                    ),
                                                    color:
                                                        t.status == 'Completed'
                                                            ? AppColors.black
                                                            : Colors
                                                                .transparent,
                                                  ),
                                                  child:
                                                      t.status == 'Completed'
                                                          ? Icon(
                                                            Icons.check,
                                                            color:
                                                                TAppTheme
                                                                    .primaryColor,
                                                            size: 12,
                                                          )
                                                          : SizedBox(),
                                                ),
                                              )
                                              : SizedBox()
                                          : Text(
                                            'Pending approve',
                                            style: TextStyle(
                                              color: AppColors.red,
                                            ),
                                          ),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        onPressed:
                                            () => context.pushRoute(
                                              PersonalTaskDetailsRoute(task: t),
                                            ),
                                        child: Text(
                                          t.title,
                                          style: TextStyle(
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    t.user.username,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
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
                user?.uid == _groupTask.owner.uid
                    ? DeleteButton(
                      isLoading: _isLoading,
                      handle: () => _deleteGroupTask(),
                    )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
