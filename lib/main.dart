import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nospend/db.dart';
import 'package:nospend/util.dart';

import 'model/expense.dart';
import 'page/budget_page.dart';
import 'page/expense_page.dart';

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

  @override
  void initState() {
    super.initState();
    db = NospendDatabase.instance;
  }

  void _navigateToExpensePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExpensePage()),
    );
    setState(() {});
  }

  void _navigateToBudgetPage() async {
    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BudgetPage()),
    );
    setState(() {});
  }

  Widget _drawer() {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      const UserAccountsDrawerHeader(
          accountName: Text('NoSpend'),
          accountEmail: Text('Minimal budget tracker'),
          currentAccountPicture:
              const CircleAvatar(child: FlutterLogo(size: 42.0))),
      ListTile(
          title: const Text('Budget'),
          onTap: () {
            _navigateToBudgetPage();
          })
    ]));
  }

  Widget _expenseList(List<Expense>? expenses) {
    List<Widget> widgets = [];
    DateFormat dateFormat = DateFormat('EEE, dd MMM yyyy, hh:mm aaa');
    if (expenses != null && expenses.length != 0) {
      for (Expense expense in expenses) {
        Widget expenseRow = Dismissible(
            key: Key(expense.id.toString()),
            onDismissed: (direction) {
              db.deleteExpense(expense.id);
              setState(() {});
            },
            background: Container(color: Colors.red),
            child: Container(
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(getIconDataByCategory(expense.category)),
                  title: Text('Spent \$${expense.amount.toStringAsFixed(2)}'),
                  trailing: Text(
                      'on ${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(expense.timestamp))}'),
                )));
        widgets.add(expenseRow);
      }
      return ListView(children: widgets);
    }
    return Center(child: Text('No expense recorded'));
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
            print(snapshot.error);
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.hasData) {
            return _expenseList(snapshot.data);
          }
          return Center(child: Text('No expenses recorded'));
        },
      ),
      drawer: _drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToExpensePage,
        tooltip: 'Add expense',
        child: Icon(Icons.add),
      ),
    );
  }
}
