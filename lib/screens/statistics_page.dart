import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../widgets/category_expense_card.dart';
import 'dart:math' as math;

class StatisticsPage extends StatelessWidget {
  final List<TransactionModel> transactions;
  final bool isLoading;
  final int userId;

  StatisticsPage({
    required this.transactions,
    required this.isLoading,
    required this.userId,
  });

  Map<String, double> get categoryExpenses {
    Map<String, double> expenses = {};
    for (var transaction in transactions) {
      if (!transaction.isIncome) {
        expenses[transaction.category] =
            (expenses[transaction.category] ?? 0) + transaction.amount;
      }
    }
    return expenses;
  }

  @override
  Widget build(BuildContext context) {
    final expenses = categoryExpenses;
    final total = expenses.values.fold(0.0, (sum, amount) => sum + amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Thống kê', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0F3460),
      ),
      backgroundColor: Color(0xFF1A1A2E),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE94560)),
              ),
            )
          : expenses.isEmpty
          ? Center(
              child: Text(
                'Chưa có dữ liệu thống kê',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Color(0xFF16213E),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Tổng chi tiêu',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 10),
                          Text(
                            TransactionModel.formatCurrency(total),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE94560),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    color: Color(0xFF16213E),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Biểu đồ chi tiêu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomPieChart(expenses: expenses, total: total),
                          SizedBox(height: 20),
                          Wrap(
                            spacing: 16,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: expenses.entries.map((entry) {
                              final percentage = (entry.value / total * 100);
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color:
                                            TransactionModel.getCategoryColor(
                                              entry.key,
                                            ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${entry.key} (${percentage.toStringAsFixed(1)}%)',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Chi tiết theo danh mục',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  ...expenses.entries.map((entry) {
                    return CategoryExpenseCard(
                      category: entry.key,
                      amount: entry.value,
                      total: total,
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }
}

// Custom Pie Chart Widget
class CustomPieChart extends StatelessWidget {
  final Map<String, double> expenses;
  final double total;

  CustomPieChart({required this.expenses, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      child: Center(
        child: CustomPaint(
          size: Size(240, 240),
          painter: PieChartPainter(expenses: expenses, total: total),
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final Map<String, double> expenses;
  final double total;

  PieChartPainter({required this.expenses, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final innerRadius = radius * 0.55;

    double startAngle = -math.pi / 2;

    expenses.forEach((category, amount) {
      final sweepAngle = (amount / total) * 2 * math.pi;
      final color = TransactionModel.getCategoryColor(category);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      final percentage = (amount / total * 100);
      if (percentage > 5) {
        final middleAngle = startAngle + sweepAngle / 2;
        final textRadius = radius * 0.75;
        final textX = center.dx + textRadius * math.cos(middleAngle);
        final textY = center.dy + textRadius * math.sin(middleAngle);

        final textPainter = TextPainter(
          text: TextSpan(
            text: '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 3,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(textX - textPainter.width / 2, textY - textPainter.height / 2),
        );
      }

      startAngle += sweepAngle;
    });

    final innerPaint = Paint()
      ..color = Color(0xFF16213E)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, innerRadius, innerPaint);

    final iconPainter = TextPainter(
      text: TextSpan(text: '💰', style: TextStyle(fontSize: 40)),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        center.dx - iconPainter.width / 2,
        center.dy - iconPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
