import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nospend/db.dart';

import 'model/expense.dart';

class ExpensePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExpensePageState();
  }
}

class ExpensePageState extends State<ExpensePage> {
  final _formKey = GlobalKey<FormState>();
  NospendDatabase db = NospendDatabase.instance;
  String amount = '';
  String selectedCategory = '';

  void _onSubmit() {
    // Can use form validator too but not going to since it's just one field
    if (amount != null ||
        amount.isNotEmpty ||
        selectedCategory != null ||
        selectedCategory.isNotEmpty) {
      double convertedAmount = double.parse(amount);
      Expense expense = new Expense(
          amount: convertedAmount,
          category: selectedCategory,
          timestamp: DateTime.now().millisecondsSinceEpoch);
      db.createExpense(expense).then((isSuccess) => {
            if (isSuccess) {Navigator.pop(context, true)}
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);

    return Scaffold(
        appBar: AppBar(title: Text('Add Expense')),
        body: Form(
            key: _formKey,
            child:
                ListView(padding: const EdgeInsets.all(16), children: <Widget>[
              Text('Expense amount',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                  onChanged: (value) {
                    if (value != null || value.isNotEmpty) {
                      setState(() {
                        amount = value;
                      });
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Enter expense amount spent')),
              sizedBoxSpace,
              Text('Expense category',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              sizedBoxSpace,
              GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  // to disable GridView's scrolling
                  shrinkWrap: true,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  crossAxisCount: 4,
                  children: <Widget>[
                    _category(Icons.fastfood_outlined, 'Food & Dining'),
                    _category(Icons.commute_outlined, 'Transport'),
                    _category(Icons.shopping_bag_outlined, 'Shopping'),
                    _category(Icons.spa_outlined, 'Personal Care'),
                    _category(
                        Icons.fitness_center_outlined, 'Health & Fitness'),
                    _category(Icons.videogame_asset_outlined, 'Entertainment'),
                    _category(Icons.library_books_outlined, 'Education'),
                    _category(
                        Icons.card_giftcard_outlined, 'Gifts & Donations'),
                  ]),
              sizedBoxSpace,
              Center(
                  child: ElevatedButton(
                      onPressed: _onSubmit, child: Text('Submit')))
            ])));
  }

  Widget _category(IconData icon, String text) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Column(children: <Widget>[
          IconButton(
            icon: Icon(icon),
            tooltip: text,
            color:
                selectedCategory == text ? Colors.blueAccent : Colors.black87,
            onPressed: () {
              setState(() {
                selectedCategory = text;
              });
            },
          ),
          Expanded(
              child: Center(
                  child: Text(text,
                      style: TextStyle(
                          fontSize: 10,
                          color: selectedCategory == text
                              ? Colors.blueAccent
                              : Colors.black87))))
        ]));
  }
}
