import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'home_page.dart';
import 'transactions_page.dart';
import 'statistics_page.dart';
import 'profile_page.dart';
import 'add_transaction_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Transaction> transactions = [
    Transaction(
      id: '1',
      title: 'Lương tháng 1',
      amount: 15000000,
      date: DateTime.now().subtract(Duration(days: 5)),
      category: 'Lương',
      isIncome: true,
    ),
    Transaction(
      id: '2',
      title: 'Tiền điện',
      amount: 500000,
      date: DateTime.now().subtract(Duration(days: 3)),
      category: 'Hóa đơn',
      isIncome: false,
    ),
    Transaction(
      id: '3',
      title: 'Ăn uống',
      amount: 200000,
      date: DateTime.now().subtract(Duration(days: 1)),
      category: 'Ăn uống',
      isIncome: false,
    ),
    Transaction(
      id: '4',
      title: 'Xăng xe',
      amount: 300000,
      date: DateTime.now(),
      category: 'Di chuyển',
      isIncome: false,
    ),
  ];

  void _addTransaction(Transaction transaction) {
    setState(() {
      transactions.insert(0, transaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(
        transactions: transactions,
        onDeleteTransaction: _deleteTransaction,
      ),
      TransactionsPage(
        transactions: transactions,
        onDeleteTransaction: _deleteTransaction,
      ),
      StatisticsPage(transactions: transactions),
      ProfilePage(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddTransactionPage(onAddTransaction: _addTransaction),
            ),
          );
        },
        child: Icon(Icons.add, size: 30),
        backgroundColor: Color.fromARGB(255, 102, 224, 66),
        elevation: 8,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
