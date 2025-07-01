import 'package:flutter/material.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/widgets/app_bar/title.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool isCenterTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    required this.isCenterTitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, left: 10.0, right: 10.0),
      child:
          isCenterTitle
              ? AppBar(
                elevation: 0,
                automaticallyImplyLeading: true,
                backgroundColor: TAppTheme.primaryColor,
                title: AppBarTitle(title: title, isCenterTitle: isCenterTitle),
                centerTitle: true,
                actions: actions,
              )
              : AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: TAppTheme.primaryColor,
                title: AppBarTitle(title: title, isCenterTitle: isCenterTitle),
                centerTitle: false,
                actions: actions,
              ),
    );
  }
}
