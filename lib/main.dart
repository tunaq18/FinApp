import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TransactionPage());
  }
}

class TransactionPage extends StatefulWidget {
  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List data = [];
  bool loading = true;

  fetchData() async {
    final res = await http.get(Uri.parse("http://192.168.1.54:3000/api"));
    data = jsonDecode(res.body);
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Finance App")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (c, i) => ListTile(
                title: Text(data[i]['title']),
                subtitle: Text("Amount: ${data[i]['amount']}"),
              ),
            ),
    );
  }
}
