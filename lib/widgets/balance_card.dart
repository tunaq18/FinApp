import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class BalanceCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  BalanceCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 5),
          Text(
            TransactionModel.formatCurrency(amount),
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
