import 'package:flutter/material.dart';
import 'package:frontend/src/config/themes/app_colors.dart';
import 'package:intl/intl.dart';

class StatisticsSelector extends StatefulWidget {
  final void Function(String type, DateTime startDate, DateTime endDate)?
  onChanged;

  const StatisticsSelector({super.key, this.onChanged});

  @override
  State<StatisticsSelector> createState() => _StatisticsSelectorState();
}

class _StatisticsSelectorState extends State<StatisticsSelector> {
  String selectedCompletion = 'Weekly completion';

  final List<String> completionOptions = [
    'Weekly completion',
    'Monthly completion',
    'Yearly completion',
  ];

  DateTime startDate = DateTime(2025, 1, 1);
  DateTime endDate = DateTime(2025, 1, 7);

  void _notifyParent() {
    switch (selectedCompletion) {
      case 'Weekly completion':
        endDate = startDate.add(const Duration(days: 6));
        break;
      case 'Monthly completion':
        endDate = DateTime(startDate.year, startDate.month + 1, 0);
        break;
      case 'Yearly completion':
        endDate = DateTime(startDate.year, 12, 31);
        break;
      default:
        endDate = startDate;
    }

    widget.onChanged?.call(selectedCompletion, startDate, endDate);
  }

  void _adjustDate(bool isForward) {
    setState(() {
      switch (selectedCompletion) {
        case 'Weekly completion':
          startDate = startDate.add(Duration(days: isForward ? 7 : -7));
          break;
        case 'Monthly completion':
          startDate = DateTime(
            startDate.year,
            startDate.month + (isForward ? 1 : -1),
          );
          break;
        case 'Yearly completion':
          startDate = DateTime(startDate.year + (isForward ? 1 : -1), 1, 1);
          break;
      }
    });

    _notifyParent();
  }

  String _getFormattedRange() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<String>(
          value: selectedCompletion,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 2,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          onChanged: (String? newValue) {
            setState(() {
              selectedCompletion = newValue!;
              startDate = DateTime(2025, 1, 1);
            });
            _notifyParent();
          },
          items:
              completionOptions.map((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            IconButton(
              onPressed: () => _adjustDate(false),
              icon: Icon(Icons.chevron_left),
            ),
            Text(_getFormattedRange(), style: const TextStyle(fontSize: 15)),
            IconButton(
              onPressed: () => _adjustDate(true),
              icon: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ],
    );
  }
}
