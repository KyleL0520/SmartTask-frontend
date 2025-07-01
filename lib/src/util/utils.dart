import 'dart:ui';

import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';

class Utils {
  static Color getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'important and urgent':
        return AppColors.red;
      case 'important but not urgent':
        return AppColors.yellow;
      case 'not important but urgent':
        return TAppTheme.secondaryColor;
      case 'not important and not urgent':
        return AppColors.green;
      default:
        return AppColors.black;
    }
  }
}