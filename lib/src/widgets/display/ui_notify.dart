import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';

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
    //   final overlay = Overlay.of(context);
    //   if (overlay == null) return;

    //   final entry = OverlayEntry(
    //     builder:
    //         (ctx) => Positioned(
    //           bottom: 30,
    //           left: 16,
    //           right: 16,
    //           child: Material(
    //             elevation: 12,
    //             borderRadius: BorderRadius.circular(10),
    //             color: backgroundColor,
    //             child: Padding(
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 16,
    //                 vertical: 12,
    //               ),
    //               child: Text(
    //                 message,
    //                 style: TextStyle(
    //                   color:
    //                       backgroundColor == AppColors.red
    //                           ? TAppTheme.primaryColor
    //                           : AppColors.black,
    //                 ),
    //                 textAlign: TextAlign.center,
    //               ),
    //             ),
    //           ),
    //         ),
    //   );

    //   overlay.insert(entry);

    //   Future.delayed(const Duration(seconds: 2), () {
    //     entry.remove();
    //   });
    // }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
