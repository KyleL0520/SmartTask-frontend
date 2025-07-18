import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';
import 'package:provider/provider.dart';

@RoutePage()
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    final authStorage = context.read<AuthStorage>();

    if (!mounted) return;

    if (authStorage.user == null) {
      context.replaceRoute(LoginRoute());
    } else {
      context.replaceRoute(BottomNavRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 30.0,
            fontFamily: 'Poppins',
            color: AppColors.black,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'SmartTask',
                speed: Duration(milliseconds: 230),
              ),
            ],
            isRepeatingAnimation: false,
          ),
        ),
      ),
    );
  }
}
