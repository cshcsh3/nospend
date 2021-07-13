import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpensePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Enter expense amount spent')),
              sizedBoxSpace,
              Text('Expense category',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              sizedBoxSpace,
              Categories(),
              sizedBoxSpace,
              Center(
                  child:
                      ElevatedButton(onPressed: () {}, child: Text('Submit')))
            ])));
  }
}

class Categories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoriesState();
  }
}

class CategoriesState extends State<Categories> {
  String selectedText = '';

  Container Category(IconData icon, String text) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Column(children: <Widget>[
          IconButton(
            icon: Icon(icon),
            tooltip: text,
            color: selectedText == text ? Colors.blueAccent : Colors.black87,
            onPressed: () {
              setState(() {
                selectedText = text;
              });
            },
          ),
          Expanded(
              child: Center(
                  child: Text(text,
                      style: TextStyle(
                          fontSize: 10,
                          color: selectedText == text
                              ? Colors.blueAccent
                              : Colors.black87))))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        physics: NeverScrollableScrollPhysics(),
        // to disable GridView's scrolling
        shrinkWrap: true,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 4,
        children: <Widget>[
          Category(Icons.fastfood_outlined, 'Food & Dining'),
          Category(Icons.commute_outlined, 'Transport'),
          Category(Icons.shopping_bag_outlined, 'Shopping'),
          Category(Icons.spa_outlined, 'Personal Care'),
          Category(Icons.fitness_center_outlined, 'Health & Fitness'),
          Category(Icons.videogame_asset_outlined, 'Entertainment'),
          Category(Icons.library_books_outlined, 'Education'),
          Category(Icons.card_giftcard_outlined, 'Gifts & Donations'),
        ]);
  }
}
