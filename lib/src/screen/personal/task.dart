import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/models/category.dart';
import 'package:frontend/src/models/task.dart';
import 'package:frontend/src/screen/widgets/bottom_nav.dart';
import 'package:frontend/src/util/services/api/category.dart';
import 'package:frontend/src/util/services/api/task.dart';
import 'package:frontend/src/util/utils.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';
import 'package:frontend/src/widgets/display/ui_notify.dart';
import 'package:intl/intl.dart';

@RoutePage()
class PersonalTaskScreen extends StatefulWidget {
  const PersonalTaskScreen({super.key});

  @override
  State<PersonalTaskScreen> createState() => PersonalTaskScreenState();
}

class PersonalTaskScreenState extends State<PersonalTaskScreen> {
  String selectedCategory = 'All';
  late Future<List<Category>?> _categories;
  late Future<List<Task>?> _tasks;
  late Future<void> _initTasksFuture;
  List<Task>? _filteredTasks;

  Set<String> _deleteModeCategories = {};

  @override
  void initState() {
    super.initState();
    _categories = CategoryService().getCategorys();
    _tasks = TaskService().getTasks(status: 'Pending', isGroupTask: false);
    _initTasksFuture = _loadFilteredTasks();
    TaskScreenCallbackRegistry.refresh = refreshTask;
  }

  Future<void> refreshTask() async {
    _tasks = TaskService().getTasks(status: 'Pending', isGroupTask: false);
    _initTasksFuture = _loadFilteredTasks();
    setState(() {});
  }

  Future<void> _loadFilteredTasks() async {
    final tasks = await _tasks ?? [];

    List<Task> filtered =
        selectedCategory == 'All'
            ? tasks
            : tasks.where((t) => t.category?.name == selectedCategory).toList();

    filtered.sort((a, b) {
      DateTime parseDeadline(Task t) {
        try {
          final date = DateFormat('d MMMM yyyy').parse(t.deadlinesDate);
          final time = DateFormat('hh : mm a').parse(t.deadlinesTime);
          return DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        } catch (_) {
          return DateTime.now();
        }
      }

      return parseDeadline(b).compareTo(parseDeadline(a));
    });

    _filteredTasks = filtered;
  }

  Future<void> _createCategory(TextEditingController category) async {
    String name = category.text.trim();
    final RegExp onlyLetters = RegExp(r'^[A-Za-z]+$');

    if (name.isEmpty) {
      UINotify.error(context, 'Category name cannot be empty');
      return;
    }

    if (name.length > 8) {
      UINotify.error(context, 'Maximum 8 letters allowed');
      return;
    }

    if (!onlyLetters.hasMatch(name)) {
      UINotify.error(context, 'Category name must contain only letters');
      return;
    }

    try {
      await CategoryService().createCategory(name);
      await _refreshCategories();

      if (!mounted) return;
      UINotify.success(context, 'Category added');
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      UINotify.error(context, e);
    }
  }

  Future<void> _deleteCategory(String categoryId) async {
    try {
      await CategoryService().deleteCategory(categoryId);
      await _refreshCategories();

      setState(() {
        _initTasksFuture = _loadFilteredTasks();
      });

      if (!mounted) return;
      UINotify.success(context, 'Category deleted');
    } catch (e) {
      if (!mounted) return;
      UINotify.error(context, e);
    }
  }

  Future<void> _refreshCategories() async {
    _categories = CategoryService().getCategorys();
    setState(() {});
  }

  void _onCategorySelected(String categoryName) {
    setState(() {
      selectedCategory = categoryName;
      _initTasksFuture = _loadFilteredTasks();
    });
  }

  void _showAddCategoryDialog(BuildContext context) async {
    final TextEditingController category = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: TextField(
            controller: category,
            maxLength: 8,
            decoration: const InputDecoration(
              hintText: 'Enter category name (max 8 letters)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _createCategory(category);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
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
      appBar: CustomAppBar(title: 'Personal', isCenterTitle: false),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder<List<Category>?>(
                future: _categories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    UINotify.error(context, 'Error: ${snapshot.error}');
                    return Text('');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    UINotify.error(context, 'No categories found');
                    return const Text('');
                  }

                  final categories = snapshot.data!;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryButton(
                        name: 'All',
                        isSelected: selectedCategory == 'All',
                        onTap: () => _onCategorySelected('All'),
                      ),
                      ...categories
                          .where((c) => c.name != 'All')
                          .map(
                            (c) => _buildCategoryButton(
                              name: c.name,
                              isSelected: selectedCategory == c.name,
                              onTap: () => _onCategorySelected(c.name),
                              onDelete: () async {
                                setState(() {
                                  _deleteModeCategories.remove(c.name);
                                });
                                await _deleteCategory(c.id);
                              },
                            ),
                          ),
                      const SizedBox(width: 15),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: TAppTheme.primaryColor,
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
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => _showAddCategoryDialog(context),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: _initTasksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final Map<String, List<Task>> groupedTasks = {};

                  for (var task in _filteredTasks ?? []) {
                    DateTime deadlineDate;
                    try {
                      deadlineDate = DateFormat(
                        'd MMMM yyyy',
                      ).parse(task.deadlinesDate);
                    } catch (_) {
                      deadlineDate = DateTime.now();
                    }

                    final formattedDate = DateFormat(
                      'dd/MM/yyyy',
                    ).format(deadlineDate);
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
                              'There are no tasks at the moment.\nThis is your chance to create something\nexciting and make it happen!',
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
                                          GestureDetector(
                                            onTap:
                                                () =>
                                                    t.status == 'Completed'
                                                        ? _updateTaskStatus(
                                                          task: t,
                                                          status: 'Pending',
                                                        )
                                                        : _updateTaskStatus(
                                                          task: t,
                                                          status: 'Completed',
                                                        ),
                                            child: Container(
                                              width: 18,
                                              height: 18,
                                              margin: const EdgeInsets.only(
                                                right: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  width: 2,
                                                  color: Utils.getPriorityColor(
                                                    t.priority,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => context.pushRoute(
                                                  PersonalTaskDetailsRoute(
                                                    task: t,
                                                    afterTaskSave: (
                                                      Task? newTask,
                                                    ) {
                                                      if (newTask == null) {
                                                        print(
                                                          'Edit pop back error',
                                                        );
                                                        return;
                                                      }
                                                      refreshTask();
                                                    },
                                                  ),
                                                ),
                                            child: Text(
                                              t.title,
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

  Widget _buildCategoryButton({
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
    VoidCallback? onDelete,
  }) {
    final isInDeleteMode = _deleteModeCategories.contains(name);

    return GestureDetector(
      onLongPress:
          () => setState(() {
            if (name != 'All' && name != 'Others') {
              _deleteModeCategories.add(name);
            }
          }),
      child: Padding(
        padding: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
        child: Container(
          width: 100,
          height: 40,
          decoration: BoxDecoration(
            color:
                isInDeleteMode
                    ? AppColors.red
                    : isSelected
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
          child:
              isInDeleteMode
                  ? IconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete, color: AppColors.black),
                  )
                  : TextButton(
                    onPressed: onTap,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        isSelected
                            ? TAppTheme.secondaryColor
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      name,
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
  }
}
