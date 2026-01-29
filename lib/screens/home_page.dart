import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_card_api.dart';

class HomePage extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Function(int) onDeleteTransaction;
  final bool isLoading;
  final Future<void> Function() onRefresh;

  HomePage({
    required this.transactions,
    required this.onDeleteTransaction,
    required this.isLoading,
    required this.onRefresh,
  });

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
        title: Text('Trang chủ', style: TextStyle(color: Colors.white)),
        elevation: 0,
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
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
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
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            TransactionModel.formatCurrency(balance),
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
                          transactions.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(40),
                                    child: Text(
                                      'Chưa có giao dịch nào',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: transactions.take(5).map((
                                    transaction,
                                  ) {
                                    return TransactionCardApi(
                                      transaction: transaction,
                                      onDelete: onDeleteTransaction,
                                    );
                                  }).toList(),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
