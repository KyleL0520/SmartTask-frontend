import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/util/services/api/auth.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';
import 'package:frontend/src/widgets/display/ui_notify.dart';
import 'package:provider/provider.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthService _auth = AuthService();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final BuildContext? context = router.navigatorKey.currentContext;

    if (context == null) {
      _navigateToLogin(router, resolver);
      return;
    }

    final authStorage = Provider.of<AuthStorage>(context, listen: false);

    try {
      User? user = await _auth.profile(context);

      if (user != null) {
        resolver.next(true);
      } else {
        await authStorage.clear();
        _navigateToLogin(router, resolver);
      }
    } catch (e) {
      if (context.mounted) {
        UINotify.error(context, e);
      }

      _navigateToLogin(router, resolver);
    }
  }

  void _navigateToLogin(StackRouter router, NavigationResolver resolver) async {
    router.push(
      LoginRoute(
        onResult: (result) async {
          if (result == true) {
            resolver.next(true);
          }
        },
      ),
    );
  }
}
