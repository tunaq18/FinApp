import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionCardApi extends StatelessWidget {
  final TransactionModel transaction;
  final Function(int) onDelete;

  TransactionCardApi({required this.transaction, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(transaction.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFF16213E),
              title: Text(
                'Xác nhận xóa',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                'Bạn có chắc muốn xóa giao dịch này?',
                style: TextStyle(color: Colors.grey[300]),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Hủy', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Xóa', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        onDelete(transaction.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa giao dịch'),
            backgroundColor: Color(0xFF16213E),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 10),
        color: Color(0xFF16213E),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: transaction.isIncome
                ? Colors.green[900]
                : TransactionModel.getCategoryColor(
                    transaction.category,
                  ).withOpacity(0.2),
            child: Icon(
              transaction.isIncome
                  ? Icons.add
                  : TransactionModel.getCategoryIcon(transaction.category),
              color: transaction.isIncome
                  ? Colors.green
                  : TransactionModel.getCategoryColor(transaction.category),
            ),
          ),
          title: Text(transaction.title, style: TextStyle(color: Colors.white)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.category,
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          trailing: Text(
            '${transaction.isIncome ? '+' : '-'}${TransactionModel.formatCurrency(transaction.amount).replaceAll(' đ', '')} đ',
            style: TextStyle(
              color: transaction.isIncome ? Colors.green : Color(0xFFE94560),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
