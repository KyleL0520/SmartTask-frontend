import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/models/task.dart';
import 'package:frontend/src/util/services/api/task.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';
import 'package:intl/intl.dart';

@RoutePage()
class GroupTaskScreen extends StatefulWidget {
  const GroupTaskScreen({super.key});

  @override
  State<GroupTaskScreen> createState() => _GroupTaskScreenState();
}

class _GroupTaskScreenState extends State<GroupTaskScreen> {
  late Future<List<Task>?> _groupTasks;
  List<Task>? _initgroupTask;

  @override
  void initState() {
    super.initState();
    _groupTasks = TaskService().getTasks(status: 'Pending', isGroupTask: true);
    _loadGroupdTasks();
  }

  Future<void> _loadGroupdTasks() async {
    _initgroupTask = await _groupTasks ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Group', isCenterTitle: false),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _groupTasks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final Map<String, List<Task>> groupedTasks = {};
                  for (var task in _initgroupTask ?? []) {
                    final formattedDate = DateFormat(
                      'dd/MM/yyyy',
                    ).format(task.createdAt);
                    final dateLabel =
                        formattedDate ==
                                DateFormat('dd/MM/yyyy').format(DateTime.now())
                            ? 'Today'
                            : formattedDate;
                    groupedTasks.putIfAbsent(dateLabel, () => []).add(task);
                  }

                  return groupedTasks.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/empty.png', width: 100),
                            const Text(
                              'There are no group tasks at the moment.\nThis is your chance to create something\nexciting and make it happen!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        children:
                            groupedTasks.entries.map((entry) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ...entry.value.map((t) {
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
                                          TextButton(
                                            onPressed:
                                                () => context.pushRoute(
                                                  GroupTaskDetailsRoute(
                                                    groupTask: t,
                                                  ),
                                                ),
                                            child: Text(
                                              t.groupTask!.projectName,
                                              style: TextStyle(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              );
                            }).toList(),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
