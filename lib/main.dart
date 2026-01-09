import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(MyFinanceApp());
}

class MyFinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Tài Chính',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFF1A1A2E),
        cardColor: Color(0xFF16213E),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0F3460),
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF16213E),
          selectedItemColor: Color(0xFFE94560),
          unselectedItemColor: Colors.grey[600],
        ),
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
