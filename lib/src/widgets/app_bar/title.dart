import 'package:flutter/material.dart';
import 'package:frontend/src/config/themes/app_colors.dart';

class AppBarTitle extends StatelessWidget {
  final String title;
  final bool isCenterTitle;

  const AppBarTitle({
    super.key,
    required this.title,
    required this.isCenterTitle,
  });

  @override
  Widget build(BuildContext context) {
    return isCenterTitle
        ? Text(
          title,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
        : Text(
          title,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        );
  }
}
