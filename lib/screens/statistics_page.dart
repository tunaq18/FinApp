import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/category_expense_card.dart';

class StatisticsPage extends StatelessWidget {
  final List<Transaction> transactions;

  StatisticsPage({required this.transactions});

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
      body: expenses.isEmpty
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
                            Transaction.formatCurrency(total),
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
                  Text(
                    'Chi tiêu theo danh mục',
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
