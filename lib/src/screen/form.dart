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
  final TextEditingController collaboratorsId = TextEditingController();
  final TextEditingController taskName = TextEditingController();
  final TextEditingController taskDescription = TextEditingController();
  final TextEditingController deadlinesDate = TextEditingController();
  final TextEditingController deadlinesTime = TextEditingController();
}

@RoutePage()
class FormScreen extends StatefulWidget {
  final Task? task;
  final GroupTask? groupTask;
  final void Function(Task? savedTask)? afterSave;
  const FormScreen({super.key, this.groupTask, this.task, this.afterSave});

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

  //Personal
  final TextEditingController _taskName = TextEditingController();
  final TextEditingController _taskDescription = TextEditingController();
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

  final List<CollaborationController> _collaborations = [
    CollaborationController(),
  ];

  @override
  void dispose() {
    super.dispose();

    _taskName.dispose();
    _taskDescription.dispose();
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
      c.collaboratorsId.dispose();
      c.taskName.dispose();
      c.taskDescription.dispose();
      c.deadlinesDate.dispose();
      c.deadlinesTime.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    _taskName.text = widget.task?.title ?? '';
    _taskDescription.text = widget.task?.description ?? '';
    _deadlinesDate.text = widget.task?.deadlinesDate ?? '';
    _deadlinesTime.text = widget.task?.deadlinesTime ?? '';
    if (widget.task?.category != null) {
      _categoryId.text = widget.task!.category!.id;
      _categoryName.text = widget.task!.category!.name;
    }
    _priority.text = widget.task?.priority ?? '';
    _reminderDate.text = widget.task?.reminderDate ?? '';
    _reminderTime.text = widget.task?.reminderTime ?? '';
    _categories = CategoryService().getCategorys();
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

  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    if (!_checkReminder()) {
      return;
    }

    try {
      await TaskService().createTask(
        title: _taskName.text.trim(),
        description: _taskDescription.text.trim(),
        category: _categoryId.text.trim(),
        deadlinesDate: _deadlinesDate.text.trim(),
        deadlinesTime: _deadlinesTime.text.trim(),
        reminderDate: _reminderDate.text.trim(),
        reminderTime: _reminderTime.text.trim(),
        priority: _priority.text.trim(),
      );

      if (!mounted) return;
      UINotify.success(context, 'Task added');
      widget.afterSave!(null);
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

  Future<void> _editTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    if (!_checkReminder()) {
      return;
    }

    try {
      final response = await TaskService().updateTask(widget.task!);

      if (response == null) {
        return;
      }

      if (!mounted) return;
      UINotify.success(context, 'Task edited');
      widget.afterSave!(response);
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

  Future<void> _createGroupTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final groupResult = await GroupTaskService().createGroupTask(
        projectName: _projectName.text.trim(),
        projectDescription: _projectDescription.text.trim(),
      );

      if (groupResult == null) {
        return;
      }

      _collaborations.map((c) async {
        await TaskService().createCollaborationTask(
          uid: c.collaboratorsId.text.trim(),
          taskName: c.taskName.text.trim(),
          taskDescription: c.taskDescription.text.trim(),
          deadlinesDate: c.deadlinesDate.text.trim(),
          deadlinesTime: c.deadlinesTime.text.trim(),
          groupTask: groupResult.id,
        );
      }).toList();

      if (!mounted) return;
      UINotify.success(context, 'Group Task added');
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

  Future<void> _editGroupTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });
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
                                controller: _taskName,
                                hintText: 'Enter the task name',
                                emptyMessage: 'Pleas enter the task name',
                              ),
                              const SizedBox(height: 20),
                              CustomLabel(text: 'Description'),
                              const SizedBox(height: 10),
                              DescriptionField(controller: _taskDescription),
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
                          ..._collaborations.map(
                            (controller) => _buildCollaborationForm(controller),
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
                                      CollaborationController(),
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
                        _editTask();
                      } else if (widget.groupTask != null) {
                        _editGroupTask();
                      } else if (_isPersonal) {
                        _createTask();
                      } else {
                        _createGroupTask();
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

  Widget _buildCollaborationForm(CollaborationController controller) {
    return Container(
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
            controller: controller.taskName,
            hintText: 'Enter task name',
            emptyMessage: 'Please enter task name',
          ),
          const SizedBox(height: 20),
          CustomLabel(text: 'Description'),
          const SizedBox(height: 10),
          DescriptionField(controller: controller.taskDescription),
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
    );
  }
}
