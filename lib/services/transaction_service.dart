import '../models/transaction_model.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class TransactionService {
  // Lấy tất cả giao dịch
  static Future<List<TransactionModel>> getTransactions(int userId) async {
    final response = await ApiService.get(
      '${ApiConfig.transactionsEndpoint}/$userId',
    );
    return (response as List)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }

  // Lấy giao dịch với filters
  static Future<List<TransactionModel>> getTransactionsWithFilters(
    int userId, {
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    bool? isIncome,
  }) async {
    String endpoint = '${ApiConfig.transactionsEndpoint}/$userId?';

    if (startDate != null) {
      endpoint += 'startDate=${startDate.toIso8601String()}&';
    }
    if (endDate != null) {
      endpoint += 'endDate=${endDate.toIso8601String()}&';
    }
    if (category != null) {
      endpoint += 'category=$category&';
    }
    if (isIncome != null) {
      endpoint += 'isIncome=$isIncome&';
    }

    final response = await ApiService.get(endpoint);
    return (response as List)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }

  // Thêm giao dịch mới
  static Future<TransactionModel> createTransaction(
    int userId,
    TransactionModel transaction,
  ) async {
    final response = await ApiService.post(
      '${ApiConfig.transactionsEndpoint}/$userId',
      transaction.toJson(),
    );
    return TransactionModel.fromJson(response);
  }

  // Cập nhật giao dịch
  static Future<TransactionModel> updateTransaction(
    int userId,
    int transactionId,
    TransactionModel transaction,
  ) async {
    final response = await ApiService.put(
      '${ApiConfig.transactionsEndpoint}/$userId/$transactionId',
      transaction.toJson(),
    );
    return TransactionModel.fromJson(response);
  }

  // Xóa giao dịch
  static Future<void> deleteTransaction(int userId, int transactionId) async {
    await ApiService.delete(
      '${ApiConfig.transactionsEndpoint}/$userId/$transactionId',
    );
  }
}
