import 'package:flutter/material.dart';
import '../widgets/summary_card.dart';
import '../widgets/weekly_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Home',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SummaryCard(
                  title: 'Thu nhập',
                  amount: '+12.000.000 đ',
                  color: Colors.green,
                ),
                SizedBox(width: 12),
                SummaryCard(
                  title: 'Chi tiêu',
                  amount: '-7.500.000 đ',
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Chi tiêu theo tuần',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Expanded(child: WeeklyChart()),
          ],
        ),
      ),
    );
  }
}
