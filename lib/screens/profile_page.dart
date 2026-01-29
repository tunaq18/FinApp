import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/user_preferences.dart';
import '../widgets/profile_menu_item.dart';
import 'login_screen.dart';

class ProfilePage extends StatelessWidget {
  final UserModel user;

  ProfilePage({required this.user});

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF16213E),
          title: Text(
            'Xác nhận đăng xuất',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Bạn có chắc muốn đăng xuất?',
            style: TextStyle(color: Colors.grey[300]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Đăng xuất', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await UserPreferences.logout();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cá nhân', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF0F3460),
      ),
      backgroundColor: Color(0xFF1A1A2E),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFE94560),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(user.email, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          SizedBox(height: 30),
          ProfileMenuItem(
            icon: Icons.account_balance_wallet,
            title: 'Tài khoản ngân hàng',
          ),
          ProfileMenuItem(icon: Icons.category, title: 'Quản lý danh mục'),
          ProfileMenuItem(icon: Icons.notifications, title: 'Thông báo'),
          ProfileMenuItem(icon: Icons.security, title: 'Bảo mật'),
          ProfileMenuItem(icon: Icons.help, title: 'Trợ giúp'),
          ProfileMenuItem(icon: Icons.info, title: 'Về chúng tôi'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _logout(context),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text('Đăng xuất'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
