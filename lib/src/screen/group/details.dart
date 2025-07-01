import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/routes/app_router.gr.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/models/task.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';

@RoutePage()
class GroupTaskDetailsScreen extends StatefulWidget {
  final Task groupTask;
  const GroupTaskDetailsScreen({super.key, required this.groupTask});

  @override
  State<GroupTaskDetailsScreen> createState() => _GroupTaskDetailsScreenState();
}

class _GroupTaskDetailsScreenState extends State<GroupTaskDetailsScreen> {
  double percent = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Project Details',
        isCenterTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              context.pushRoute(FormRoute(task: null));
            },
            child: Text(
              'Edit',
              style: TextStyle(
                color: TAppTheme.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),

      // body: SafeArea(
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 25.0),
      //     child: SingleChildScrollView(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           const SizedBox(height: 20),
      //           Text(
      //             widget.groupTask.projectName,
      //             style: TextStyle(
      //               fontSize: 22,
      //               color: AppColors.black,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //           const SizedBox(height: 20),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Text(
      //                 'In Progress',
      //                 style: TextStyle(fontSize: 16, color: AppColors.black),
      //               ),
      //               Text(
      //                 percent.toString(),
      //                 style: TextStyle(fontSize: 16, color: AppColors.black),
      //               ),
      //             ],
      //           ),
      //           LinearPercentIndicator(
      //             lineHeight: 20,
      //             percent: percent,
      //             progressColor: TAppTheme.secondaryColor,
      //             backgroundColor: AppColors.grey,
      //             animation: true,
      //             animationDuration: 800,
      //           ),
      //           const SizedBox(height: 20),
      //           CustomLabel(text: 'Overview'),
      //           const SizedBox(height: 6),
      //           Text(
      //             widget.groupTask.projectDescription,
      //             style: TextStyle(color: AppColors.grey),
      //           ),
      //           const SizedBox(height: 20),
      //           CustomLabel(text: 'Members'),
      //           const SizedBox(height: 6),

      //           const SizedBox(height: 20),
      //           CustomLabel(text: 'Tasks'),
      //           const SizedBox(height: 6),
      //           ...widget.groupTask.collaborations.map((t) {
      //             return Container(
      //               margin: const EdgeInsets.only(bottom: 10),
      //               padding: const EdgeInsets.symmetric(
      //                 horizontal: 10,
      //                 vertical: 3,
      //               ),
      //               decoration: BoxDecoration(
      //                 color: TAppTheme.primaryColor,
      //                 borderRadius: BorderRadius.circular(12),
      //                 boxShadow: const [
      //                   BoxShadow(
      //                     color: AppColors.grey,
      //                     offset: Offset(2, 2),
      //                     blurRadius: 3,
      //                   ),
      //                 ],
      //               ),
      //               child: Row(
      //                 children: [
      //                   const SizedBox(width: 5),
      //                   Container(
      //                     width: 16,
      //                     height: 16,
      //                     margin: const EdgeInsets.only(right: 10),
      //                     decoration: BoxDecoration(
      //                       shape: BoxShape.circle,
      //                       border: Border.all(
      //                         width: 2,
      //                         color: Utils.getPriorityColor(t.priority),
      //                       ),
      //                     ),
      //                   ),
      //                   TextButton(
      //                     onPressed:
      //                         () => context.pushRoute(
      //                           PersonalTaskDetailsRoute(task: t),
      //                         ),
      //                     child: Text(
      //                       t.title,
      //                       style: TextStyle(
      //                         color: AppColors.black,
      //                         fontWeight: FontWeight.bold,
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             );
      //           }),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
