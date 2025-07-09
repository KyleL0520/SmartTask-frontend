import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/models/group_task.dart';
import 'package:frontend/src/models/task.dart';
import 'package:frontend/src/screen/widgets/bottom_nav.dart';
import 'package:frontend/src/util/services/api/group_task.dart';
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
  late Future<List<GroupTask>?> _groupProject;
  List<Task>? _initgroupTask;

  @override
  void initState() {
    super.initState();
    _groupTasks = TaskService().getTasks(status: 'Pending', isGroupTask: true);
    _groupProject = GroupTaskService().getGroupTasks();
    _loadGroupdTasks();
    TaskScreenCallbackRegistry.refresh = _refreshGroupTasks;
  }

  Future<void> _loadGroupdTasks() async {
    _initgroupTask = await _groupTasks ?? [];
  }

  void _refreshGroupTasks() {
    setState(() {
      _groupTasks = TaskService().getTasks(
        status: 'Pending',
        isGroupTask: true,
      );
      _groupProject = GroupTaskService().getGroupTasks();
    });
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
                future: Future.wait([_groupTasks, _groupProject]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tasks = snapshot.data?[0] as List<Task>? ?? [];
                  final groupProjects =
                      snapshot.data?[1] as List<GroupTask>? ?? [];

                  final taskGroupIds =
                      tasks
                          .map((t) => t.groupTask?.id)
                          .whereType<String>()
                          .toSet();
                  final projectIds = groupProjects.map((g) => g.id).toSet();

                  final allGroupTaskIds = {...taskGroupIds, ...projectIds};

                  final allGroupTasks =
                      groupProjects
                          .where((g) => allGroupTaskIds.contains(g.id))
                          .toList();

                  final Map<String, List<GroupTask>> groupedProjects = {};
                  
                  for (final project in allGroupTasks) {
                    Task? relatedTask;
                    final filtered = tasks.where(
                      (t) => t.groupTask?.id == project.id,
                    );

                    if (filtered.isNotEmpty) {
                      relatedTask = filtered.first;
                    } else {
                      relatedTask = null;
                    }

                    DateTime deadline;
                    try {
                      final deadlineDate =
                          relatedTask != null
                              ? DateFormat(
                                'd MMMM yyyy',
                              ).parse(relatedTask.deadlinesDate)
                              : DateTime.now();

                      final deadlineTime =
                          relatedTask != null
                              ? DateFormat(
                                'hh : mm a',
                              ).parse(relatedTask.deadlinesTime)
                              : DateTime.now();

                      deadline = DateTime(
                        deadlineDate.year,
                        deadlineDate.month,
                        deadlineDate.day,
                        deadlineTime.hour,
                        deadlineTime.minute,
                      );
                    } catch (_) {
                      deadline = DateTime.now();
                    }

                    final formattedDate = DateFormat(
                      'dd/MM/yyyy',
                    ).format(deadline);

                    final dateLabel =
                        formattedDate ==
                                DateFormat('dd/MM/yyyy').format(DateTime.now())
                            ? 'Today'
                            : formattedDate;

                    groupedProjects
                        .putIfAbsent(dateLabel, () => [])
                        .add(project);
                  }

                  if (groupedProjects.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    children:
                        groupedProjects.entries.map((entry) {
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
                              ...entry.value.map((project) {
                                return GestureDetector(
                                  onTap:
                                      () => context
                                          .pushRoute(
                                            GroupTaskDetailsRoute(
                                              groupTask: project,
                                              afterGroupTaskSave: (_) {
                                                _refreshGroupTasks();
                                              },
                                            ),
                                          )
                                          .then((_) => _refreshGroupTasks()),
                                  child: Container(
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
                                            Text(
                                              project.projectName,
                                              style: TextStyle(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
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
