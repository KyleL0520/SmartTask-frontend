import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/models/task.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/util/services/api/task.dart';
import 'package:frontend/src/widgets/app_bar/app_bar.dart';
import 'package:frontend/src/widgets/input/selector.dart';
import 'package:intl/intl.dart';

@RoutePage()
class StatisticsScreen extends StatefulWidget {
  final User user;
  const StatisticsScreen({super.key, required this.user});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<List<Task>?> _tasks;

  DateTime selectedStart = DateTime(2025, 1, 1);
  DateTime selectedEnd = DateTime(2025, 1, 7);
  String? selectedType;

  @override
  void initState() {
    super.initState();
    _tasks = TaskService().getTasks(isApproved: true);
  }

  double _calculatePercent(String status, List<Task> tasks) {
    if (tasks.isEmpty) return 0;
    final total = tasks.length;
    final int filtered;
    if (status == 'Expired') {
      filtered = tasks.where((t) => t.isExpired).length;
    } else {
      filtered = tasks.where((t) => t.status == status).length;
    }
    print('$status count: $filtered of $total');

    return (filtered / total * 100).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Statistics', isCenterTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              StatisticsSelector(
                onChanged: (type, start, end) {
                  setState(() {
                    selectedType = type;
                    selectedStart = start;
                    selectedEnd = end;
                  });
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: _tasks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No tasks found in this range.");
                  }

                  final filteredTasks =
                      snapshot.data!.where((task) {
                        DateTime? deadline;
                        try {
                          deadline = DateFormat(
                            'd MMMM yyyy',
                          ).parse(task.deadlinesDate);
                        } catch (_) {
                          return false;
                        }

                        return !deadline.isBefore(selectedStart) &&
                            !deadline.isAfter(selectedEnd);
                      }).toList();

                  print(
                    'Filtered ${filteredTasks.length} tasks between $selectedStart and $selectedEnd',
                  );

                  return SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: getSections(filteredTasks),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildLabel(color: AppColors.green, text: 'Completed'),
              _buildLabel(color: TAppTheme.secondaryColor, text: 'Pending'),
              _buildLabel(color: AppColors.red, text: 'Expired'),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> getSections(List<Task> tasks) {
    if (tasks.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 100,
          title: '0%',
          titleStyle: TextStyle(
            color: TAppTheme.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ];
    }

    final int completedCount =
        tasks.where((t) => t.status == 'Completed').length;
    final int pendingCount =
        tasks.where((t) => t.status == 'Pending' && !t.isExpired).length;
    final int expiredCount = tasks.where((t) => t.isExpired).length;

    final int totalCount = completedCount + pendingCount + expiredCount;

    double percent(int count) => (count / totalCount) * 100;

    final completed = percent(completedCount);
    final pending = percent(pendingCount);
    final expired = percent(expiredCount);

    print('Completed $completed');
    print('pending $pending');
    print('expired $expired');

    return [
      PieChartSectionData(
        color: AppColors.green,
        value: completed,
        title: '${completed.toStringAsFixed(2)}%',
        titleStyle: TextStyle(
          color: TAppTheme.primaryColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        color: TAppTheme.secondaryColor,
        value: pending,
        title: '${pending.toStringAsFixed(2)}%',
        titleStyle: TextStyle(
          color: TAppTheme.primaryColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        color: AppColors.red,
        value: expired,
        title: '${expired.toStringAsFixed(2)}%',
        titleStyle: TextStyle(
          color: TAppTheme.primaryColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }

  Widget _buildLabel({required Color color, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
