import 'package:flutter/material.dart';
import 'package:frontend/src/config/themes/app_colors.dart';

class CustomLabel extends StatelessWidget {
  final String text;
  const CustomLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
