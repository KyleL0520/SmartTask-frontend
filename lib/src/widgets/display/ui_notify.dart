import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/src/config/themes/app_colors.dart';

class UINotify {
  static void error(BuildContext context, dynamic message) {
    String errorMessage = 'An unknown error occurred';
    print(message);

    if (message is DioException) {
      final response = message.response;
      if (response != null && response.data is Map<String, dynamic>) {
        errorMessage = response.data['message'] ?? errorMessage;
      } else if (message.message != null) {
        errorMessage = message.message!;
      }
    } else if (message is String) {
      errorMessage = message;
    } else {
      try {
        final Map<String, dynamic> responseData = jsonDecode(
          message.toString(),
        );
        errorMessage = responseData['message'] ?? errorMessage;
      } catch (_) {
        errorMessage = message.toString();
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSnackBar(context, errorMessage, AppColors.red);
    });
  }

  static void warning(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.orange);
  }

  static void success(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.green);
  }

  static void _showSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor,
  ) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: backgroundColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }
}
