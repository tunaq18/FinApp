import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_card_api.dart';

class TransactionsPage extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Function(int) onDeleteTransaction;
  final bool isLoading;
  final Future<void> Function() onRefresh;

  TransactionsPage({
    required this.transactions,
    required this.onDeleteTransaction,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giao dịch', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0F3460),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: onRefresh,
          ),
        ],
      ),
      backgroundColor: Color(0xFF1A1A2E),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        color: Color(0xFFE94560),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE94560)),
                ),
              )
            : transactions.isEmpty
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
                  return TransactionCardApi(
                    transaction: transactions[index],
                    onDelete: onDeleteTransaction,
                  );
                },
              ),
      ),
    );
  }
}
