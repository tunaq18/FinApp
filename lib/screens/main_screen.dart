import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import 'home_page.dart';
import 'transactions_page.dart';
import 'statistics_page.dart';
import 'profile_page.dart';
import 'add_transaction_page.dart';

class MainScreen extends StatefulWidget {
  final UserModel user;

  MainScreen({required this.user});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<TransactionModel> transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      setState(() => _isLoading = true);
      final data = await TransactionService.getTransactions(widget.user.id);
      setState(() {
        transactions = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tải dữ liệu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteTransaction(int transactionId) async {
    try {
      await TransactionService.deleteTransaction(widget.user.id, transactionId);
      await _loadTransactions();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa giao dịch'),
            backgroundColor: Color(0xFF16213E),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi xóa giao dịch: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(
        transactions: transactions,
        onDeleteTransaction: _deleteTransaction,
        isLoading: _isLoading,
        onRefresh: _loadTransactions,
      ),
      TransactionsPage(
        transactions: transactions,
        onDeleteTransaction: _deleteTransaction,
        isLoading: _isLoading,
        onRefresh: _loadTransactions,
      ),
      StatisticsPage(
        transactions: transactions,
        isLoading: _isLoading,
        userId: widget.user.id,
      ),
      ProfilePage(user: widget.user),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 1 ? _selectedIndex + 1 : _selectedIndex,
        onTap: (index) {
          if (index != 2) {
            setState(() {
              if (index > 2) {
                _selectedIndex = index - 1;
              } else {
                _selectedIndex = index;
              }
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Giao dịch'),
          BottomNavigationBarItem(icon: SizedBox(height: 24), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionPage(userId: widget.user.id),
            ),
          );
          if (result == true) {
            await _loadTransactions();
          }
        },
        child: Icon(Icons.add, size: 30),
        backgroundColor: Color.fromARGB(255, 71, 238, 127),
        elevation: 8,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
