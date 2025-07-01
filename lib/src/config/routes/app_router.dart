import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/routes/router_guard.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: BaseLayoutRoute.page, initial: true, path: '/'),

    AutoRoute(
      page: BottomNavRoute.page,
      path: '/user',
      guards: [AuthGuard()],
      children: [
        AutoRoute(
          page: PersonalTaskRoute.page,
          path: 'personal-task',
          guards: [AuthGuard()],
        ),
        AutoRoute(
          page: GroupTaskRoute.page,
          path: 'group-task',
          guards: [AuthGuard()],
        ),
        AutoRoute(
          page: CalendarRoute.page,
          path: 'calendar',
          guards: [AuthGuard()],
        ),
        AutoRoute(
          page: ProfileRoute.page,
          path: 'profile',
          guards: [AuthGuard()],
        ),
        AutoRoute(page: SettingsRoute.page, path: 'settings'),
      ],
    ),

    AutoRoute(
      page: PersonalTaskDetailsRoute.page,
      path: '/personal-task-details',
      guards: [AuthGuard()],
    ),
    AutoRoute(
      page: GroupTaskDetailsRoute.page,
      path: '/group-task-details',
      guards: [AuthGuard()],
    ),
    AutoRoute(page: FormRoute.page, path: '/form', guards: [AuthGuard()]),

    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: SignUpRoute.page, path: '/signup'),
    AutoRoute(page: ForgotPasswordRoute.page, path: '/forgot-password'),
    AutoRoute(page: ResetPasswordRoute.page, path: '/reset-password'),
    AutoRoute(page: ProfileRoute.page, path: '/profile'),
    AutoRoute(page: EditProfileRoute.page, path: '/edit-profile'),
    AutoRoute(page: EditPasswordRoute.page, path: '/edit-password'),
    AutoRoute(page: StatisticsRoute.page, path: '/statistics'),
  ];
}
