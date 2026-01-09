import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final bool isIncome;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.isIncome,
  });

  // Format số tiền với dấu phẩy
  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(amount)} đ';
  }

  // Icon cho từng danh mục
  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Ăn uống':
        return Icons.restaurant;
      case 'Di chuyển':
        return Icons.directions_car;
      case 'Mua sắm':
        return Icons.shopping_bag;
      case 'Hóa đơn':
        return Icons.receipt_long;
      case 'Giải trí':
        return Icons.movie;
      case 'Sức khỏe':
        return Icons.local_hospital;
      case 'Giáo dục':
        return Icons.school;
      case 'Lương':
        return Icons.account_balance_wallet;
      case 'Khác':
        return Icons.more_horiz;
      default:
        return Icons.category;
    }
  }

  // Màu cho từng danh mục
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Ăn uống':
        return Colors.orange;
      case 'Di chuyển':
        return Colors.blue;
      case 'Mua sắm':
        return Colors.purple;
      case 'Hóa đơn':
        return Colors.red;
      case 'Giải trí':
        return Colors.pink;
      case 'Sức khỏe':
        return Colors.green;
      case 'Giáo dục':
        return Colors.indigo;
      case 'Lương':
        return Colors.teal;
      case 'Khác':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }
}
