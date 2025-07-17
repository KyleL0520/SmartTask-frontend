// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i19;
import 'package:flutter/material.dart' as _i20;
import 'package:frontend/src/models/group_task.dart' as _i22;
import 'package:frontend/src/models/task.dart' as _i23;
import 'package:frontend/src/models/user.dart' as _i21;
import 'package:frontend/src/screen/calendar.dart' as _i3;
import 'package:frontend/src/screen/form.dart' as _i7;
import 'package:frontend/src/screen/group/details.dart' as _i8;
import 'package:frontend/src/screen/group/task.dart' as _i9;
import 'package:frontend/src/screen/layout/layout.dart' as _i1;
import 'package:frontend/src/screen/personal/details.dart' as _i11;
import 'package:frontend/src/screen/personal/task.dart' as _i12;
import 'package:frontend/src/screen/profile/edit_password.dart' as _i4;
import 'package:frontend/src/screen/profile/edit_profile.dart' as _i5;
import 'package:frontend/src/screen/profile/profile.dart' as _i13;
import 'package:frontend/src/screen/profile/statistics.dart' as _i18;
import 'package:frontend/src/screen/shared/auth/forgot_password.dart' as _i6;
import 'package:frontend/src/screen/shared/auth/login.dart' as _i10;
import 'package:frontend/src/screen/shared/auth/reset_password.dart' as _i14;
import 'package:frontend/src/screen/shared/auth/signup.dart' as _i16;
import 'package:frontend/src/screen/shared/settings/settings.dart' as _i15;
import 'package:frontend/src/screen/start.dart' as _i17;
import 'package:frontend/src/screen/widgets/bottom_nav.dart' as _i2;

/// generated route for
/// [_i1.BaseLayoutScreen]
class BaseLayoutRoute extends _i19.PageRouteInfo<void> {
  const BaseLayoutRoute({List<_i19.PageRouteInfo>? children})
    : super(BaseLayoutRoute.name, initialChildren: children);

  static const String name = 'BaseLayoutRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i1.BaseLayoutScreen();
    },
  );
}

/// generated route for
/// [_i2.BottomNavScreen]
class BottomNavRoute extends _i19.PageRouteInfo<void> {
  const BottomNavRoute({List<_i19.PageRouteInfo>? children})
    : super(BottomNavRoute.name, initialChildren: children);

  static const String name = 'BottomNavRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i2.BottomNavScreen();
    },
  );
}

/// generated route for
/// [_i3.CalendarScreen]
class CalendarRoute extends _i19.PageRouteInfo<void> {
  const CalendarRoute({List<_i19.PageRouteInfo>? children})
    : super(CalendarRoute.name, initialChildren: children);

  static const String name = 'CalendarRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i3.CalendarScreen();
    },
  );
}

/// generated route for
/// [_i4.EditPasswordScreen]
class EditPasswordRoute extends _i19.PageRouteInfo<EditPasswordRouteArgs> {
  EditPasswordRoute({
    _i20.Key? key,
    required _i21.User user,
    List<_i19.PageRouteInfo>? children,
  }) : super(
         EditPasswordRoute.name,
         args: EditPasswordRouteArgs(key: key, user: user),
         initialChildren: children,
       );

  static const String name = 'EditPasswordRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditPasswordRouteArgs>();
      return _i4.EditPasswordScreen(key: args.key, user: args.user);
    },
  );
}

class EditPasswordRouteArgs {
  const EditPasswordRouteArgs({this.key, required this.user});

  final _i20.Key? key;

  final _i21.User user;

  @override
  String toString() {
    return 'EditPasswordRouteArgs{key: $key, user: $user}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditPasswordRouteArgs) return false;
    return key == other.key && user == other.user;
  }

  @override
  int get hashCode => key.hashCode ^ user.hashCode;
}

/// generated route for
/// [_i5.EditProfileScreen]
class EditProfileRoute extends _i19.PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({
    _i20.Key? key,
    required _i21.User user,
    List<_i19.PageRouteInfo>? children,
  }) : super(
         EditProfileRoute.name,
         args: EditProfileRouteArgs(key: key, user: user),
         initialChildren: children,
       );

  static const String name = 'EditProfileRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditProfileRouteArgs>();
      return _i5.EditProfileScreen(key: args.key, user: args.user);
    },
  );
}

class EditProfileRouteArgs {
  const EditProfileRouteArgs({this.key, required this.user});

  final _i20.Key? key;

  final _i21.User user;

  @override
  String toString() {
    return 'EditProfileRouteArgs{key: $key, user: $user}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditProfileRouteArgs) return false;
    return key == other.key && user == other.user;
  }

  @override
  int get hashCode => key.hashCode ^ user.hashCode;
}

/// generated route for
/// [_i6.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i19.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i19.PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i6.ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i7.FormScreen]
class FormRoute extends _i19.PageRouteInfo<FormRouteArgs> {
  FormRoute({
    _i20.Key? key,
    _i22.GroupTask? groupTask,
    _i23.Task? task,
    void Function(_i23.Task?)? afterTaskSave,
    void Function(_i22.GroupTask?)? afterGroupTaskSave,
    List<_i19.PageRouteInfo>? children,
  }) : super(
         FormRoute.name,
         args: FormRouteArgs(
           key: key,
           groupTask: groupTask,
           task: task,
           afterTaskSave: afterTaskSave,
           afterGroupTaskSave: afterGroupTaskSave,
         ),
         initialChildren: children,
       );

  static const String name = 'FormRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FormRouteArgs>(
        orElse: () => const FormRouteArgs(),
      );
      return _i7.FormScreen(
        key: args.key,
        groupTask: args.groupTask,
        task: args.task,
        afterTaskSave: args.afterTaskSave,
        afterGroupTaskSave: args.afterGroupTaskSave,
      );
    },
  );
}

class FormRouteArgs {
  const FormRouteArgs({
    this.key,
    this.groupTask,
    this.task,
    this.afterTaskSave,
    this.afterGroupTaskSave,
  });

  final _i20.Key? key;

  final _i22.GroupTask? groupTask;

  final _i23.Task? task;

  final void Function(_i23.Task?)? afterTaskSave;

  final void Function(_i22.GroupTask?)? afterGroupTaskSave;

  @override
  String toString() {
    return 'FormRouteArgs{key: $key, groupTask: $groupTask, task: $task, afterTaskSave: $afterTaskSave, afterGroupTaskSave: $afterGroupTaskSave}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FormRouteArgs) return false;
    return key == other.key &&
        groupTask == other.groupTask &&
        task == other.task;
  }

  @override
  int get hashCode => key.hashCode ^ groupTask.hashCode ^ task.hashCode;
}

/// generated route for
/// [_i8.GroupTaskDetailsScreen]
class GroupTaskDetailsRoute
    extends _i19.PageRouteInfo<GroupTaskDetailsRouteArgs> {
  GroupTaskDetailsRoute({
    _i20.Key? key,
    required _i22.GroupTask groupTask,
    void Function(_i22.GroupTask?)? afterGroupTaskSave,
    List<_i19.PageRouteInfo>? children,
  }) : super(
         GroupTaskDetailsRoute.name,
         args: GroupTaskDetailsRouteArgs(
           key: key,
           groupTask: groupTask,
           afterGroupTaskSave: afterGroupTaskSave,
         ),
         initialChildren: children,
       );

  static const String name = 'GroupTaskDetailsRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GroupTaskDetailsRouteArgs>();
      return _i8.GroupTaskDetailsScreen(
        key: args.key,
        groupTask: args.groupTask,
        afterGroupTaskSave: args.afterGroupTaskSave,
      );
    },
  );
}

class GroupTaskDetailsRouteArgs {
  const GroupTaskDetailsRouteArgs({
    this.key,
    required this.groupTask,
    this.afterGroupTaskSave,
  });

  final _i20.Key? key;

  final _i22.GroupTask groupTask;

  final void Function(_i22.GroupTask?)? afterGroupTaskSave;

  @override
  String toString() {
    return 'GroupTaskDetailsRouteArgs{key: $key, groupTask: $groupTask, afterGroupTaskSave: $afterGroupTaskSave}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GroupTaskDetailsRouteArgs) return false;
    return key == other.key && groupTask == other.groupTask;
  }

  @override
  int get hashCode => key.hashCode ^ groupTask.hashCode;
}

/// generated route for
/// [_i9.GroupTaskScreen]
class GroupTaskRoute extends _i19.PageRouteInfo<void> {
  const GroupTaskRoute({List<_i19.PageRouteInfo>? children})
    : super(GroupTaskRoute.name, initialChildren: children);

  static const String name = 'GroupTaskRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i9.GroupTaskScreen();
    },
  );
}

/// generated route for
/// [_i10.LoginScreen]
class LoginRoute extends _i19.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i20.Key? key,
    dynamic Function(bool?)? onResult,
    List<_i19.PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(key: key, onResult: onResult),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () => const LoginRouteArgs(),
      );
      return _i10.LoginScreen(key: args.key, onResult: args.onResult);
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, this.onResult});

  final _i20.Key? key;

  final dynamic Function(bool?)? onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i11.PersonalTaskDetailsScreen]
class PersonalTaskDetailsRoute
    extends _i19.PageRouteInfo<PersonalTaskDetailsRouteArgs> {
  PersonalTaskDetailsRoute({
    _i20.Key? key,
    required _i23.Task task,
    void Function(_i23.Task?)? afterTaskSave,
    List<_i19.PageRouteInfo>? children,
  }) : super(
         PersonalTaskDetailsRoute.name,
         args: PersonalTaskDetailsRouteArgs(
           key: key,
           task: task,
           afterTaskSave: afterTaskSave,
         ),
         initialChildren: children,
       );

  static const String name = 'PersonalTaskDetailsRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PersonalTaskDetailsRouteArgs>();
      return _i11.PersonalTaskDetailsScreen(
        key: args.key,
        task: args.task,
        afterTaskSave: args.afterTaskSave,
      );
    },
  );
}

class PersonalTaskDetailsRouteArgs {
  const PersonalTaskDetailsRouteArgs({
    this.key,
    required this.task,
    this.afterTaskSave,
  });

  final _i20.Key? key;

  final _i23.Task task;

  final void Function(_i23.Task?)? afterTaskSave;

  @override
  String toString() {
    return 'PersonalTaskDetailsRouteArgs{key: $key, task: $task, afterTaskSave: $afterTaskSave}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PersonalTaskDetailsRouteArgs) return false;
    return key == other.key && task == other.task;
  }

  @override
  int get hashCode => key.hashCode ^ task.hashCode;
}

/// generated route for
/// [_i12.PersonalTaskScreen]
class PersonalTaskRoute extends _i19.PageRouteInfo<void> {
  const PersonalTaskRoute({List<_i19.PageRouteInfo>? children})
    : super(PersonalTaskRoute.name, initialChildren: children);

  static const String name = 'PersonalTaskRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i12.PersonalTaskScreen();
    },
  );
}

/// generated route for
/// [_i13.ProfileScreen]
class ProfileRoute extends _i19.PageRouteInfo<void> {
  const ProfileRoute({List<_i19.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i13.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i14.ResetPasswordScreen]
class ResetPasswordRoute extends _i19.PageRouteInfo<ResetPasswordRouteArgs> {
  ResetPasswordRoute({
    _i20.Key? key,
    required String email,
    List<_i19.PageRouteInfo>? children,
  }) : super(
         ResetPasswordRoute.name,
         args: ResetPasswordRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'ResetPasswordRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResetPasswordRouteArgs>();
      return _i14.ResetPasswordScreen(key: args.key, email: args.email);
    },
  );
}

class ResetPasswordRouteArgs {
  const ResetPasswordRouteArgs({this.key, required this.email});

  final _i20.Key? key;

  final String email;

  @override
  String toString() {
    return 'ResetPasswordRouteArgs{key: $key, email: $email}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ResetPasswordRouteArgs) return false;
    return key == other.key && email == other.email;
  }

  @override
  int get hashCode => key.hashCode ^ email.hashCode;
}

/// generated route for
/// [_i15.SettingsScreen]
class SettingsRoute extends _i19.PageRouteInfo<void> {
  const SettingsRoute({List<_i19.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i15.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i16.SignUpScreen]
class SignUpRoute extends _i19.PageRouteInfo<void> {
  const SignUpRoute({List<_i19.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i16.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i17.StartScreen]
class StartRoute extends _i19.PageRouteInfo<void> {
  const StartRoute({List<_i19.PageRouteInfo>? children})
    : super(StartRoute.name, initialChildren: children);

  static const String name = 'StartRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i17.StartScreen();
    },
  );
}

/// generated route for
/// [_i18.StatisticsScreen]
class StatisticsRoute extends _i19.PageRouteInfo<StatisticsRouteArgs> {
  StatisticsRoute({
    _i20.Key? key,
    required _i21.User user,
    List<_i19.PageRouteInfo>? children,
  }) : super(
         StatisticsRoute.name,
         args: StatisticsRouteArgs(key: key, user: user),
         initialChildren: children,
       );

  static const String name = 'StatisticsRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StatisticsRouteArgs>();
      return _i18.StatisticsScreen(key: args.key, user: args.user);
    },
  );
}

class StatisticsRouteArgs {
  const StatisticsRouteArgs({this.key, required this.user});

  final _i20.Key? key;

  final _i21.User user;

  @override
  String toString() {
    return 'StatisticsRouteArgs{key: $key, user: $user}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! StatisticsRouteArgs) return false;
    return key == other.key && user == other.user;
  }

  @override
  int get hashCode => key.hashCode ^ user.hashCode;
}
