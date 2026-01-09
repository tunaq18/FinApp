import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/transaction_card.dart';

class TransactionsPage extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String) onDeleteTransaction;

  TransactionsPage({
    required this.transactions,
    required this.onDeleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giao dịch', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0F3460),
      ),
      backgroundColor: Color(0xFF1A1A2E),
      body: transactions.isEmpty
          ? Center(
              child: Text(
                'Chưa có giao dịch nào',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return TransactionCard(
                  transaction: transactions[index],
                  onDelete: onDeleteTransaction,
                );
              },
            ),
    );
  }
}
