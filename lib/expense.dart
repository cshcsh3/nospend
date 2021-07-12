import 'package:flutter/material.dart';

class ExpensePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Add Expense')
        ),
        body: Categories()
    );
  }
}

class Categories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoriesState();
  }
}

class CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {

    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 4,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.fastfood_outlined),
                      tooltip: 'Food & Dining',
                      onPressed: () {},
                    ),
                    Expanded(child: Center(child: Text('Food & Dining', style: TextStyle(fontSize: 8))))
                  ]
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.commute_outlined),
                        tooltip: 'Transport',
                        onPressed: () {},
                      ),
                      Expanded(child: Center(child: Text('Transport', style: TextStyle(fontSize: 8))))
                    ]
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined),
                        tooltip: 'Shopping',
                        onPressed: () {},
                      ),
                      Expanded(child: Center(child: Text('Shopping', style: TextStyle(fontSize: 8))))
                    ]
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.spa_outlined),
                        tooltip: 'Personal Care',
                        onPressed: () {},
                      ),
                      Expanded(child: Center(child: Text('Personal Care', style: TextStyle(fontSize: 8))))
                    ]
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.fitness_center_outlined),
                        tooltip: 'Health & Fitness',
                        onPressed: () {},
                      ),
                      Expanded(child: Center(child: Text('Health & Fitness', style: TextStyle(fontSize: 8))))
                    ]
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.videogame_asset_outlined),
                        tooltip: 'Entertainment',
                        onPressed: () {},
                      ),
                      Expanded(child: Center(child: Text('Entertainment', style: TextStyle(fontSize: 8))))
                    ]
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.library_books_outlined),
                        tooltip: 'Education',
                        onPressed: () {},
                      ),
                      Expanded(child: Center(child: Text('Education', style: TextStyle(fontSize: 8))))
                    ]
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ExpenseForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExpenseFormState();
  }
}

class ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);

    return Form(
      key: _formKey,
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                children: [
                  sizedBoxSpace,
                  TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Amount',
                          hintText: 'Enter expense amount spent'
                      )
                  ),
                  sizedBoxSpace,
                  Text('Expense category'),
                  sizedBoxSpace,
                  Center(
                      child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Submit')
                      )
                  )
                ]
            )
        )
      )
    );
  }
}
