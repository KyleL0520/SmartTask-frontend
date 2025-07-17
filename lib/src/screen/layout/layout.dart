import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/screen/shared/auth/login.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';
import 'package:provider/provider.dart';

@RoutePage()
class BaseLayoutScreen extends StatelessWidget {
  const BaseLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStorage>(
      builder: (context, authStorage, child) {
        final user = authStorage.user;
        final router = AutoRouter.of(context);

        if (user == null) return const LoginScreen();

        // router.replaceAll([BottomNavRoute()]);

        Future.microtask(() {
          if (router.canPop()) return;
          router.replaceAll([const BottomNavRoute()]);
        });

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
