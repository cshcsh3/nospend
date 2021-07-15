import 'package:flutter/material.dart';
import 'expense_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nospend',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Nospend'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _navigateToExpensePage() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExpensePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('Main page')
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToExpensePage,
        tooltip: 'Add expense',
        child: Icon(Icons.add),
      ),
    );
  }
}
