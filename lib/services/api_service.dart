import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static Future<Map<String, dynamic>> _handleResponse(
    http.Response response,
  ) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Đã xảy ra lỗi');
    }
  }

  static Future<List<dynamic>> _handleListResponse(
    http.Response response,
  ) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body) as List;
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Đã xảy ra lỗi');
    }
  }

  // GET request
  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      final body = json.decode(response.body);
      if (body is List) {
        return _handleListResponse(response);
      } else {
        return _handleResponse(response);
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // POST request
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
