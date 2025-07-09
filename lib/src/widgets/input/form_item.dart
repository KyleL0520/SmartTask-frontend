import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/util/services/api/group_task.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1.5),
        ),
        prefixIcon: Icon(Icons.email_outlined, color: AppColors.black),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }

        final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );

        if (!emailRegex.hasMatch(value.trim())) {
          return 'Invalid Email Format';
        }

        return null;
      },
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1.5),
        ),
        prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.black),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.black,
          ),
        ),
      ),
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }
}

class ConfirmPasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const ConfirmPasswordField({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.confirmPasswordController,
      decoration: InputDecoration(
        hintText: 'Confirm Password',
        hintStyle: TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1.5),
        ),
        prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.black),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.black,
          ),
        ),
      ),
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your password';
        }
        if (value != widget.passwordController.text) {
          return 'Password do not match';
        }
        return null;
      },
    );
  }
}

class UsernameField extends StatelessWidget {
  final TextEditingController controller;

  const UsernameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Username',
            hintStyle: TextStyle(color: AppColors.grey),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.grey, width: 1.5),
            ),
            prefixIcon: Icon(Icons.person_outlined, color: AppColors.black),
          ),
          inputFormatters: [LengthLimitingTextInputFormatter(10)],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your username';
            }

            return null;
          },
        ),
      ],
    );
  }
}

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter the task description',
            hintStyle: TextStyle(color: AppColors.grey),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.grey, width: 1.5),
            ),
          ),
          maxLines: 4,
          maxLength: 100,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter the task description';
            }

            return null;
          },
        ),
      ],
    );
  }
}

class TaskField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String emptyMessage;

  const TaskField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1.5),
        ),
      ),
      maxLength: 20,
      inputFormatters: [LengthLimitingTextInputFormatter(20)],
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return emptyMessage;
        }

        return null;
      },
    );
  }
}

class DatePicker extends StatefulWidget {
  final TextEditingController controller;
  final bool isValidate;
  const DatePicker({
    super.key,
    required this.controller,
    required this.isValidate,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dateTime = now;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: 'Select date',
          hintStyle: TextStyle(color: AppColors.grey),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.grey, width: 1.5),
          ),
          suffixIcon: Icon(Icons.date_range, color: TAppTheme.secondaryColor),
        ),
        validator: (value) {
          if (widget.isValidate) {
            if (value == null || value.trim().isEmpty) {
              return 'Please select the date of deadlines';
            }
          }
          return null;
        },
        onTap:
            () => showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              builder: (context) => _buildDatePicker(),
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
            minimumDate: dateTime,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged:
                (DateTime newDate) => setState(() => dateTime = newDate),
          ),
        ),
        TextButton(
          onPressed: () {
            final formattedDate = DateFormat('d MMMM yyyy').format(dateTime);
            widget.controller.text = formattedDate;
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

class TimePicker extends StatefulWidget {
  final TextEditingController controller;
  final bool isValidate;
  const TimePicker({
    super.key,
    required this.controller,
    required this.isValidate,
  });

  @override
  State<TimePicker> createState() => _TimeickerState();
}

class _TimeickerState extends State<TimePicker> {
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dateTime = now;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: 'Select time',
          hintStyle: TextStyle(color: AppColors.grey),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.grey, width: 1.5),
          ),
          suffixIcon: Icon(
            Icons.access_time_filled_outlined,
            color: TAppTheme.secondaryColor,
          ),
        ),
        validator: (value) {
          if (widget.isValidate) {
            if (value == null || value.trim().isEmpty) {
              return 'Please select the time of deadlines';
            }
          }
          return null;
        },
        onTap:
            () => showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              builder: (context) => _buildDatePicker(),
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
            minimumDate: dateTime,
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged:
                (DateTime newDate) => setState(() => dateTime = newDate),
          ),
        ),
        TextButton(
          onPressed: () {
            final formattedTime = DateFormat('hh : mm a').format(dateTime);
            widget.controller.text = formattedTime;
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

class CategoryPicker extends StatefulWidget {
  final List<String> list;
  final TextEditingController controller;
  final String hinText;
  final String errorMessage;
  final void Function(String)? onSelected;

  const CategoryPicker({
    super.key,
    required this.list,
    required this.controller,
    required this.hinText,
    required this.errorMessage,
    this.onSelected,
  });

  @override
  State<CategoryPicker> createState() => _categoryIdPickerState();
}

class _categoryIdPickerState extends State<CategoryPicker> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hinText,
        hintStyle: TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return widget.errorMessage;
        }
        return null;
      },
      onTap:
          () => showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (context) => _buildCustomPicker(),
          ),
    );
  }

  Widget _buildCustomPicker() {
    String result = '';

    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: CupertinoPicker(
              itemExtent: 50,
              diameterRatio: 0.7,
              looping: true,
              onSelectedItemChanged:
                  (index) => setState(() => this.index = index),
              selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                background: AppColors.grey.withOpacity(0.12),
              ),
              children: List.generate(widget.list.length, (index) {
                result = widget.list[index];
                return Center(
                  child: Text(
                    widget.list[index],
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }),
            ),
          ),
          TextButton(
            onPressed: () {
              final selected = widget.list[index];
              widget.controller.text = selected;
              widget.onSelected?.call(selected);
              Navigator.of(context).pop();
            },
            child: Text(
              'Done',
              style: TextStyle(
                color: TAppTheme.secondaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPicker extends StatefulWidget {
  final List<String> list;
  final TextEditingController controller;
  final String hinText;
  final String errorMessage;

  const CustomPicker({
    super.key,
    required this.list,
    required this.controller,
    required this.hinText,
    required this.errorMessage,
  });

  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hinText,
        hintStyle: TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1.5),
        ),
      ),
      onTap:
          () => showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (context) => _buildCustomPicker(),
          ),
    );
  }

  Widget _buildCustomPicker() {
    String result = '';

    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: CupertinoPicker(
              itemExtent: 50,
              diameterRatio: 0.7,
              looping: true,
              onSelectedItemChanged:
                  (index) => setState(() => this.index = index),
              selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                background: AppColors.grey.withOpacity(0.12),
              ),
              children: List.generate(widget.list.length, (index) {
                result = widget.list[index];
                return Center(
                  child: Text(
                    widget.list[index],
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.controller.text = widget.list[index];
              Navigator.of(context).pop();
            },
            child: Text(
              'Done',
              style: TextStyle(
                color: TAppTheme.secondaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AIField extends StatelessWidget {
  final TextEditingController controller;

  const AIField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter the task description',
            hintStyle: TextStyle(color: AppColors.grey),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.grey, width: 1.5),
            ),
          ),
          maxLines: 10,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter the task description';
            }

            return null;
          },
        ),
      ],
    );
  }
}

class UserField extends StatefulWidget {
  final TextEditingController controller;

  const UserField({super.key, required this.controller});

  @override
  State<UserField> createState() => _UserFieldState();
}

class _UserFieldState extends State<UserField> {
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await GroupTaskService().getUser();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching users: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DropdownSearch<User>(
      items: _users,
      itemAsString: (user) => user.email,
      onChanged: (User? selectedUser) {
        widget.controller.text = selectedUser?.uid ?? '';
      },
      selectedItem: _users.firstWhereOrNull(
        (u) => u.uid == widget.controller.text,
      ),
      compareFn: (User a, User b) => a.uid == b.uid,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: 'Email',
          hintStyle: const TextStyle(color: AppColors.grey),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 2,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.grey, width: 1.5),
          ),
          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.black),
        ),
      ),
      validator: (value) {
        if (value == null) return 'Please select a user';
        return null;
      },
      popupProps: PopupProps.menu(
        showSearchBox: true,
        showSelectedItems: true,
        searchDelay: const Duration(milliseconds: 500),
        searchFieldProps: const TextFieldProps(
          autofocus: true,
          decoration: InputDecoration(hintText: 'Search by email...'),
        ),
        emptyBuilder: (context, _) => Center(child: Text('No user found')),
        loadingBuilder:
            (context, _) => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class UserNameField extends StatelessWidget {
  final TextEditingController controller;

  const UserNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Username',
        hintStyle: TextStyle(color: AppColors.grey),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1.5),
        ),
        prefixIcon: Icon(Icons.person, color: AppColors.black),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your username';
        }

        return null;
      },
    );
  }
}
