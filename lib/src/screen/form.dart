import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/models/category.dart';
import 'package:frontend/src/models/group_task.dart';
import 'package:frontend/src/models/task.dart';
import 'package:frontend/src/util/services/api/category.dart';
import 'package:frontend/src/util/services/api/group_task.dart';
import 'package:frontend/src/util/services/api/task.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';
import 'package:frontend/src/widgets/display/ui_notify.dart';
import 'package:frontend/src/widgets/input/button.dart';
import 'package:frontend/src/widgets/input/form_item.dart';
import 'package:frontend/src/widgets/label/label.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:intl/intl.dart';

class CollaborationController {
  String? taskId;
  final TextEditingController collaboratorsId = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController deadlinesDate = TextEditingController();
  final TextEditingController deadlinesTime = TextEditingController();
}

@RoutePage()
class FormScreen extends StatefulWidget {
  final Task? task;
  final GroupTask? groupTask;
  final void Function(Task? savedTask)? afterTaskSave;
  final void Function(GroupTask? savedGroupTask)? afterGroupTaskSave;
  const FormScreen({
    super.key,
    this.groupTask,
    this.task,
    this.afterTaskSave,
    this.afterGroupTaskSave,
  });

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  bool _isPersonal = true;
  bool _isTask = true;
  bool _isLoading = false;
  bool _isReminderSwitched = true;

  final _formKey = GlobalKey<FormState>();

  late Future<List<Category>?> _categories;
  late Future<List<Task>?> _allTasksInGroup;
  final List<Task> _resolvedAllTaskInGroup = [];

  //Personal
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _deadlinesDate = TextEditingController();
  final TextEditingController _deadlinesTime = TextEditingController();
  final TextEditingController _categoryId = TextEditingController();
  final TextEditingController _categoryName = TextEditingController();
  final TextEditingController _priority = TextEditingController();
  final TextEditingController _reminderDate = TextEditingController();
  final TextEditingController _reminderTime = TextEditingController();
  final TextEditingController _ai = TextEditingController();

  //Group
  final TextEditingController _projectName = TextEditingController();
  final TextEditingController _projectDescription = TextEditingController();

  final List<CollaborationData> _collaborations = [];

  @override
  void dispose() {
    super.dispose();

    _title.dispose();
    _description.dispose();
    _deadlinesDate.dispose();
    _deadlinesTime.dispose();
    _categoryId.dispose();
    _categoryName.dispose();
    _priority.dispose();
    _reminderDate.dispose();
    _reminderTime.dispose();
    _ai.dispose();

    _projectName.dispose();
    _projectDescription.dispose();

    for (var c in _collaborations) {
      c.controller.collaboratorsId.dispose();
      c.controller.title.dispose();
      c.controller.description.dispose();
      c.controller.deadlinesDate.dispose();
      c.controller.deadlinesTime.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    _categories = CategoryService().getCategorys();

    if (widget.task != null) {
      _title.text = widget.task?.title ?? '';
      _description.text = widget.task?.description ?? '';
      _deadlinesDate.text = widget.task?.deadlinesDate ?? '';
      _deadlinesTime.text = widget.task?.deadlinesTime ?? '';
      if (widget.task?.category != null) {
        _categoryId.text = widget.task!.category!.id;
        _categoryName.text = widget.task!.category!.name;
      }
      _priority.text = widget.task?.priority ?? '';
      _reminderDate.text = widget.task?.reminderDate ?? '';
      _reminderTime.text = widget.task?.reminderTime ?? '';
    }
    if (widget.groupTask != null) {
      _isPersonal = false;
      _projectName.text = widget.groupTask?.projectName ?? '';
      _projectDescription.text = widget.groupTask?.projectDescription ?? '';

      _allTasksInGroup = TaskService().getTasks(
        groupTaskId: widget.groupTask!.id,
        isByUser: false,
      );
      _allTasksInGroup.then((tasks) {
        if (tasks != null && tasks.isNotEmpty) {
          _collaborations.clear();
          for (var task in tasks) {
            final c = CollaborationController();
            c.taskId = task.id;
            c.collaboratorsId.text = task.user.uid;
            c.title.text = task.title;
            c.description.text = task.description;
            c.deadlinesDate.text = task.deadlinesDate;
            c.deadlinesTime.text = task.deadlinesTime;
            _collaborations.add(
              CollaborationData(taskId: task.id, controller: c),
            );
          }
          setState(() {});
        }
      });
    }
  }

  bool _checkReminder() {
    if (_isReminderSwitched) {
      if (_reminderDate.text.isEmpty || _reminderTime.text.isEmpty) {
        UINotify.error(
          context,
          'Reminder date and time are required when reminder is on',
        );
        return false;
      }

      try {
        final deadlineFormat = DateFormat("d MMMM yyyy hh : mm a");
        final reminderFormat = DateFormat("d MMMM yyyy hh : mm a");

        final deadlineDateTime = deadlineFormat.parse(
          '${_deadlinesDate.text} ${_deadlinesTime.text}',
        );

        final reminderDateTime = reminderFormat.parse(
          '${_reminderDate.text} ${_reminderTime.text}',
        );

        if (reminderDateTime.isAfter(deadlineDateTime)) {
          UINotify.error(context, 'Reminder cannot be after the deadline');
          return false;
        }
      } catch (e) {
        UINotify.error(context, 'Invalid date/time format');
        return false;
      }
    } else {
      _reminderDate.text = '';
      _reminderTime.text = '';
      return true;
    }
    return true;
  }

  Future<void> _handleCreateTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    if (!_checkReminder()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      await TaskService().createTask(
        title: _title.text.trim(),
        description: _description.text.trim(),
        category: _categoryId.text.trim(),
        deadlinesDate: _deadlinesDate.text.trim(),
        deadlinesTime: _deadlinesTime.text.trim(),
        reminderDate: _reminderDate.text.trim(),
        reminderTime: _reminderTime.text.trim(),
        priority: _priority.text.trim(),
      );

      if (!mounted) return;
      UINotify.success(context, 'Task added');
      widget.afterTaskSave!(null);
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

  Future<void> _handleCreateTaskAI() async {
    if (_ai.text.isEmpty) {
      if (!mounted) return;
      UINotify.error(context, 'Task description is required');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await TaskService().createTaskAI(description: _ai.text.trim());

      if (!mounted) return;
      UINotify.success(context, 'Task added');
      widget.afterTaskSave!(null);
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

  Future<void> _handleEditTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    if (!_checkReminder()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await TaskService().updateTask(
        id: widget.task!.id,
        title: _title.text.trim(),
        description: _description.text.trim(),
        category: _categoryId.text.trim(),
        deadlinesDate: _deadlinesDate.text.trim(),
        deadlinesTime: _deadlinesTime.text.trim(),
        reminderDate: _reminderDate.text.trim(),
        reminderTime: _reminderTime.text.trim(),
        priority: _priority.text.trim(),
      );

      if (response == null) return;

      if (!mounted) return;
      UINotify.success(context, 'Task edited');
      widget.afterTaskSave!(response);
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      UINotify.error(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleCreateGroupTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final groupResult = await GroupTaskService().createGroupTask(
        projectName: _projectName.text.trim(),
        projectDescription: _projectDescription.text.trim(),
      );

      if (groupResult == null) return;

      _collaborations.map((c) async {
        await TaskService().createCollaborationTask(
          uid: c.controller.collaboratorsId.text.trim(),
          title: c.controller.title.text.trim(),
          description: c.controller.description.text.trim(),
          deadlinesDate: c.controller.deadlinesDate.text.trim(),
          deadlinesTime: c.controller.deadlinesTime.text.trim(),
          groupTask: groupResult.id,
        );
      }).toList();

      if (!mounted) return;
      UINotify.success(context, 'Group Task added');
      widget.afterTaskSave!(null);
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      UINotify.error(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleEditGroupTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await GroupTaskService().updateGroupTask(
        id: widget.groupTask!.id,
        projectName: _projectName.text.trim(),
        projectDescription: _projectDescription.text.trim(),
      );

      await Future.wait(
        _collaborations.map((data) async {
          final c = data.controller;
          if (data.taskId != null) {
            await TaskService().updateCollaborationTask(
              id: data.taskId!,
              uid: c.collaboratorsId.text.trim(),
              title: c.title.text.trim(),
              description: c.description.text.trim(),
              deadlinesDate: c.deadlinesDate.text.trim(),
              deadlinesTime: c.deadlinesTime.text.trim(),
            );
          } else {
            await TaskService().createCollaborationTask(
              groupTask: widget.groupTask!.id,
              uid: c.collaboratorsId.text.trim(),
              title: c.title.text.trim(),
              description: c.description.text.trim(),
              deadlinesDate: c.deadlinesDate.text.trim(),
              deadlinesTime: c.deadlinesTime.text.trim(),
            );
          }
        }),
      );

      if (response == null) return;

      if (!mounted) return;
      UINotify.success(context, 'Group task edited');
      widget.afterGroupTaskSave!(response);
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      UINotify.error(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDeleteCollaborationTask(String? taskId, int index) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (taskId != null) {
        final response = await TaskService().deleteTask(taskId);
        if (response == null) return;
        if (!mounted) return;
        UINotify.success(context, 'Task deleted');
      }

      _collaborations.removeAt(index);
      setState(() {});
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
        title:
            widget.task != null
                ? 'Edit Personal Task'
                : widget.groupTask != null
                ? 'Edit Group Task'
                : widget.task == null
                ? 'Create Personal Task'
                : 'Create Group Task',

        isCenterTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  widget.task != null || widget.groupTask != null
                      ? SizedBox()
                      : ToggleSwitch(
                        minWidth: double.infinity,
                        cornerRadius: 15.0,
                        activeBgColor: [TAppTheme.secondaryColor],
                        activeFgColor: TAppTheme.primaryColor,
                        inactiveBgColor: AppColors.grey,
                        inactiveFgColor: TAppTheme.primaryColor,
                        initialLabelIndex: _isPersonal ? 0 : 1,
                        totalSwitches: 2,
                        labels: ['Personal', 'Group'],
                        radiusStyle: true,
                        onToggle: (index) {
                          setState(() {
                            _isPersonal = index == 0;
                          });
                        },
                      ),
                  const SizedBox(height: 20),
                  widget.task != null || widget.groupTask != null
                      ? SizedBox()
                      : !_isPersonal
                      ? SizedBox()
                      : ToggleSwitch(
                        minWidth: double.infinity,
                        cornerRadius: 15.0,
                        activeBgColor: [TAppTheme.secondaryColor],
                        activeFgColor: TAppTheme.primaryColor,
                        inactiveBgColor: AppColors.grey,
                        inactiveFgColor: TAppTheme.primaryColor,
                        initialLabelIndex: _isTask ? 0 : 1,
                        totalSwitches: 2,
                        labels: ['Task', 'AI'],
                        radiusStyle: true,
                        onToggle: (index) {
                          setState(() {
                            _isTask = index == 0;
                          });
                        },
                      ),
                  const SizedBox(height: 20),
                  _isPersonal
                      ? _isTask
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomLabel(text: 'Task Name'),
                              const SizedBox(height: 10),
                              TaskField(
                                controller: _title,
                                hintText: 'Enter the task name',
                                emptyMessage: 'Pleas enter the task name',
                              ),
                              const SizedBox(height: 20),
                              CustomLabel(text: 'Description'),
                              const SizedBox(height: 10),
                              DescriptionField(controller: _description),
                              const SizedBox(height: 20),
                              CustomLabel(text: 'Deadlines'),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  DatePicker(
                                    controller: _deadlinesDate,
                                    isValidate: true,
                                  ),
                                  const SizedBox(width: 10),
                                  TimePicker(
                                    controller: _deadlinesTime,
                                    isValidate: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              CustomLabel(text: 'Category'),
                              const SizedBox(height: 10),
                              FutureBuilder<List<Category>?>(
                                future: _categories,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError ||
                                      !snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Text(
                                      'Failed to load categories',
                                    );
                                  }

                                  final List<Category> categoryList =
                                      snapshot.data!;
                                  final List<String> categoryNames =
                                      categoryList.map((c) => c.name).toList();

                                  return CategoryPicker(
                                    list: categoryNames,
                                    controller: _categoryName,
                                    hinText: 'Select Category',
                                    errorMessage: 'Please select task category',
                                    onSelected: (selectedName) {
                                      final selectedCategory = categoryList
                                          .firstWhere(
                                            (c) => c.name == selectedName,
                                          );
                                      _categoryId.text = selectedCategory.id;
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomLabel(text: 'Reminder'),
                                  Transform.scale(
                                    scale: 0.6,
                                    child: Switch(
                                      activeColor: TAppTheme.secondaryColor,
                                      value: _isReminderSwitched,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _isReminderSwitched = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _isReminderSwitched
                                  ? Row(
                                    children: [
                                      DatePicker(
                                        controller: _reminderDate,
                                        isValidate: false,
                                      ),
                                      const SizedBox(width: 10),
                                      TimePicker(
                                        controller: _reminderTime,
                                        isValidate: false,
                                      ),
                                    ],
                                  )
                                  : SizedBox(),
                              const SizedBox(height: 20),
                              CustomLabel(text: 'Priority'),
                              const SizedBox(height: 10),
                              CustomPicker(
                                list: [
                                  'important and urgent',
                                  'important but not urgent',
                                  'not important but urgent',
                                  'not important and not urgent',
                                ],
                                controller: _priority,
                                hinText: 'Select Priority',
                                errorMessage: 'Please select task priority',
                              ),
                            ],
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomLabel(text: 'Task'),
                              const SizedBox(height: 10),
                              AIField(controller: _ai),
                            ],
                          )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomLabel(text: 'Project Name'),
                          const SizedBox(height: 10),
                          TaskField(
                            controller: _projectName,
                            hintText: 'Enter the project name',
                            emptyMessage: 'Pleas enter the project name',
                          ),
                          const SizedBox(height: 20),
                          CustomLabel(text: 'Project Description'),
                          const SizedBox(height: 10),
                          DescriptionField(controller: _projectDescription),
                          const SizedBox(height: 20),
                          CustomLabel(text: 'Collaboration'),
                          const SizedBox(height: 10),
                          Column(
                            children:
                                _collaborations.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final data = entry.value;
                                  return _buildCollaborationForm(
                                    controller: data.controller,
                                    onDelete:
                                        () => _handleDeleteCollaborationTask(
                                          data.taskId,
                                          index,
                                        ),
                                  );
                                }).toList(),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: GestureDetector(
                              onTap:
                                  () => setState(
                                    () => _collaborations.add(
                                      CollaborationData(
                                        taskId: null,
                                        controller: CollaborationController(),
                                      ),
                                    ),
                                  ),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: TAppTheme.secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: TAppTheme.primaryColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text:
                        widget.task != null || widget.groupTask != null
                            ? 'Edit'
                            : 'Create',
                    isLoading: _isLoading,
                    handle: () {
                      if (widget.task != null) {
                        _handleEditTask();
                      } else if (widget.groupTask != null) {
                        _handleEditGroupTask();
                      } else if (_isPersonal) {
                        _isTask ? _handleCreateTask() : _handleCreateTaskAI();
                      } else {
                        _handleCreateGroupTask();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollaborationForm({
    required CollaborationController controller,
    VoidCallback? onDelete,
  }) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomLabel(text: 'Email'),
              const SizedBox(height: 10),
              UserField(controller: controller.collaboratorsId),
              const SizedBox(height: 20),
              CustomLabel(text: 'Task'),
              const SizedBox(height: 10),
              TaskField(
                controller: controller.title,
                hintText: 'Enter task name',
                emptyMessage: 'Please enter task name',
              ),
              const SizedBox(height: 20),
              CustomLabel(text: 'Description'),
              const SizedBox(height: 10),
              DescriptionField(controller: controller.description),
              const SizedBox(height: 20),
              CustomLabel(text: 'Deadlines'),
              const SizedBox(height: 10),
              Row(
                children: [
                  DatePicker(
                    controller: controller.deadlinesDate,
                    isValidate: true,
                  ),
                  const SizedBox(width: 10),
                  TimePicker(
                    controller: controller.deadlinesTime,
                    isValidate: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            onPressed: onDelete,
            tooltip: 'Remove collaboration',
            icon: const Icon(Icons.close, color: AppColors.red),
          ),
        ),
      ],
    );
  }
}

class CollaborationData {
  String? taskId;
  final CollaborationController controller;

  CollaborationData({this.taskId, required this.controller});
}
