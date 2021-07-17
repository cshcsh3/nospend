import 'package:flutter/material.dart';
import 'package:nospend/db.dart';

import 'expense_page.dart';
import 'model/expense.dart';

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
  late NospendDatabase db;

  void _navigateToExpensePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExpensePage()),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    db = NospendDatabase.instance;
  }

  Widget _expensesList(List<Expense>? expenses) {
    List<Widget> widgets = [];
    if (expenses != null) {
      for (Expense expense in expenses) {
        Widget expenseRow = Container(
            height: 50,
            child:
                Text('${expense.id}: ${expense.amount} ${expense.category}'));
        widgets.add(expenseRow);
      }
      return ListView(padding: const EdgeInsets.all(20), children: widgets);
    }
    return Text('No expenses recorded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: db.getExpenses(),
        builder: (BuildContext context, AsyncSnapshot<List<Expense>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.hasData) {
            return _expensesList(snapshot.data);
          }
          return Center(child: Text('No expenses recorded'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToExpensePage,
        tooltip: 'Add expense',
        child: Icon(Icons.add),
      ),
    );
  }
}
