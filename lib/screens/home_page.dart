import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_card.dart';

class HomePage extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String) onDeleteTransaction;

  HomePage({required this.transactions, required this.onDeleteTransaction});

  double get totalIncome {
    return transactions
        .where((t) => t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return transactions
        .where((t) => !t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get balance => totalIncome - totalExpense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Color(0xFF0F3460),
      ),
      backgroundColor: Color(0xFF1A1A2E),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F3460), Color(0xFF533483)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Số dư hiện tại',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    Transaction.formatCurrency(balance),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BalanceCard(
                        title: 'Thu nhập',
                        amount: totalIncome,
                        icon: Icons.arrow_downward,
                        color: Colors.green,
                      ),
                      BalanceCard(
                        title: 'Chi tiêu',
                        amount: totalExpense,
                        icon: Icons.arrow_upward,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giao dịch gần đây',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  ...transactions.take(5).map((transaction) {
                    return TransactionCard(
                      transaction: transaction,
                      onDelete: onDeleteTransaction,
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
