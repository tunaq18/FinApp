import 'package:flutter/material.dart';
import 'transaction.dart';

class TransactionModel {
  final int? id;
  final int userId;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final bool isIncome;

  TransactionModel({
    this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.isIncome,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['Id'] ?? json['id'],
      userId: json['UserId'] ?? json['userId'],
      title: json['Title'] ?? json['title'],
      amount: (json['Amount'] ?? json['amount']).toDouble(),
      date: DateTime.parse(json['Date'] ?? json['date']),
      category: json['Category'] ?? json['category'],
      isIncome: json['IsIncome'] ?? json['isIncome'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'isIncome': isIncome,
    };
  }

  // Sử dụng các helper methods từ Transaction model cũ
  static String formatCurrency(double amount) {
    return Transaction.formatCurrency(amount);
  }

  static IconData getCategoryIcon(String category) {
    return Transaction.getCategoryIcon(category);
  }

  static Color getCategoryColor(String category) {
    return Transaction.getCategoryColor(category);
  }
}
