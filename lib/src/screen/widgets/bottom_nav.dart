import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';

@RoutePage()
class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [
        PersonalTaskRoute(),
        GroupTaskRoute(),
        CalendarRoute(),
        ProfileRoute(),
      ],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 50,
        child: FloatingActionButton(
          onPressed: () {
            AutoRouter.of(context).push(
              FormRoute(
                afterTaskSave:
                    (task) => TaskScreenCallbackRegistry.refresh?.call(),
                afterGroupTaskSave:
                    (groupTask) => TaskScreenCallbackRegistry.refresh?.call(),
              ),
            );
          },
          backgroundColor: TAppTheme.secondaryColor,
          shape: CircleBorder(),
          child: const Icon(Icons.add, color: TAppTheme.primaryColor),
        ),
      ),
      bottomNavigationBuilder: (context, tabsRouter) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.lightgrey,
                blurRadius: 5,
                offset: Offset(0, -2),
              ),
            ],
          ),

          child: BottomAppBar(
            color: TAppTheme.primaryColor,
            shape: const CircularNotchedRectangle(),
            notchMargin: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem(
                  context,
                  icon: Icons.checklist,
                  label: 'Personal',
                  index: 0,
                  tabsRouter: tabsRouter,
                ),
                _buildTabItem(
                  context,
                  icon: Icons.groups,
                  label: 'Group',
                  index: 1,
                  tabsRouter: tabsRouter,
                ),
                const SizedBox(width: 48),
                _buildTabItem(
                  context,
                  icon: Icons.date_range,
                  label: 'Calendar',
                  index: 2,
                  tabsRouter: tabsRouter,
                ),
                _buildTabItem(
                  context,
                  icon: Icons.person,
                  label: 'Profile',
                  index: 3,
                  tabsRouter: tabsRouter,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required TabsRouter tabsRouter,
  }) {
    final isSelected = tabsRouter.activeIndex == index;
    return GestureDetector(
      onTap: () => tabsRouter.setActiveIndex(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? TAppTheme.secondaryColor : AppColors.black,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? TAppTheme.secondaryColor : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskScreenCallbackRegistry {
  static void Function()? refresh;
}
