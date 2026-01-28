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

  // Convert từ Transaction cũ
  static TransactionModel fromTransaction(dynamic transaction, int userId) {
    return TransactionModel(
      userId: userId,
      title: transaction.title,
      amount: transaction.amount,
      date: transaction.date,
      category: transaction.category,
      isIncome: transaction.isIncome,
    );
  }
}
