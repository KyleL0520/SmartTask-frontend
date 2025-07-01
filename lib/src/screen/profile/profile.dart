import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/util/services/api/auth.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';
import 'package:frontend/src/widgets/display/ui.confirm.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with RouteAware {
  User? user;
  bool _isLoading = true;

  @override
  void initState() {
    _readUser();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _readUser();
  }

  Future<void> _readUser() async {
    user = await AuthStorage().getUser();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> handleLogout() async {
    UIConfirm.confirmDialog(
      context,
      'Are you sure to logout?',
      '',
      () async {
        bool? success = await AuthService().logout(context);

        if (success != null && success) {
          if (context.mounted) {
            AutoRouter.of(context).replace(const BaseLayoutRoute());
          }
        }
      },
      () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', isCenterTitle: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      const SizedBox(height: 20),
                      ClipOval(
                        child:
                            user!.avatarPhoto.startsWith('assets/')
                                ? Image.asset(
                                  user!.avatarPhoto,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                                : user!.avatarPhoto.startsWith('http')
                                ? Image.network(
                                  user!.avatarPhoto,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                                : Image.file(
                                  File(user!.avatarPhoto),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user?.username ?? '',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildSectionButton(
                        title: 'Edit Profile',
                        icon: Icons.create,
                        onTap:
                            () => context.pushRoute(
                              EditProfileRoute(user: user!),
                            ),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionButton(
                        title: 'Edit Password',
                        icon: Icons.lock_outline_rounded,
                        onTap:
                            () => context.pushRoute(
                              EditPasswordRoute(user: user!),
                            ),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionButton(
                        title: 'Statistics',
                        icon: Icons.pie_chart,
                        onTap:
                            () =>
                                context.pushRoute(StatisticsRoute(user: user!)),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionButton(
                        title: 'Logout',
                        icon: Icons.logout_outlined,
                        onTap: handleLogout,
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildSectionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: title == 'Logout' ? AppColors.red : AppColors.black,
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(
                  color: title == 'Logout' ? AppColors.red : AppColors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, color: AppColors.grey),
        ],
      ),
    );
  }
}
