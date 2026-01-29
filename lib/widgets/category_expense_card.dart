import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class CategoryExpenseCard extends StatelessWidget {
  final String category;
  final double amount;
  final double total;

  CategoryExpenseCard({
    required this.category,
    required this.amount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (amount / total * 100);
    final categoryColor = TransactionModel.getCategoryColor(category);

    return Card(
      margin: EdgeInsets.only(bottom: 10),
      color: Color(0xFF16213E),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        TransactionModel.getCategoryIcon(category),
                        color: categoryColor,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  TransactionModel.formatCurrency(amount),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 10,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
              ),
            ),
            SizedBox(height: 5),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
