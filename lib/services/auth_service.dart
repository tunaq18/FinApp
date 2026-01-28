import '../models/user_model.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class AuthService {
  // Đăng ký
  static Future<UserModel> register(
    String email,
    String name,
    String password,
  ) async {
    final response = await ApiService.post(
      '${ApiConfig.usersEndpoint}/register',
      {'email': email, 'name': name, 'password': password},
    );
    return UserModel.fromJson(response['user']);
  }

  // Đăng nhập
  static Future<UserModel> login(String email, String password) async {
    final response = await ApiService.post('${ApiConfig.usersEndpoint}/login', {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response['user']);
  }

  // Lấy thông tin user
  static Future<UserModel> getUser(int userId) async {
    final response = await ApiService.get('${ApiConfig.usersEndpoint}/$userId');
    return UserModel.fromJson(response);
  }
}
