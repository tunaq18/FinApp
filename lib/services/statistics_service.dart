import '../config/api_config.dart';
import 'api_service.dart';

class StatisticsService {
  // Lấy thống kê tổng quan
  static Future<Map<String, dynamic>> getSummary(int userId) async {
    return await ApiService.get(
      '${ApiConfig.statisticsEndpoint}/$userId/summary',
    );
  }

  // Lấy thống kê theo danh mục
  static Future<List<dynamic>> getByCategory(
    int userId, {
    bool? isIncome,
  }) async {
    String endpoint = '${ApiConfig.statisticsEndpoint}/$userId/by-category';
    if (isIncome != null) {
      endpoint += '?isIncome=$isIncome';
    }
    return await ApiService.get(endpoint) as List;
  }

  // Lấy thống kê theo tháng
  static Future<Map<String, dynamic>> getByMonth(
    int userId, {
    int? year,
  }) async {
    String endpoint = '${ApiConfig.statisticsEndpoint}/$userId/by-month';
    if (year != null) {
      endpoint += '?year=$year';
    }
    return await ApiService.get(endpoint);
  }
}
