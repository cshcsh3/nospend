import 'package:flutter/material.dart';

class ExpensePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Add Expense')
        ),
        body: ExpenseForm()
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
                  Categories(),
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

class Categories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoriesState();
  }
}

class CategoriesState extends State<Categories> with RestorationMixin {
  final isSelected = [
    RestorableBool(false),
    RestorableBool(false),
    RestorableBool(false),
    RestorableBool(false),
  ];

  @override
  String get restorationId => 'categories';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(isSelected[0], 'item0');
    registerForRestoration(isSelected[1], 'item1');
    registerForRestoration(isSelected[2], 'item2');
    registerForRestoration(isSelected[3], 'item3');
  }

  @override
  void dispose(){
    for (final restorableBool in isSelected){
      restorableBool.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (index) {
        setState(() {
          isSelected[index].value = !isSelected[index].value;
        });
      },
      isSelected: isSelected.map((element) => element.value).toList(),
      children: [
        Column(
            children: [
              Icon(Icons.fastfood_outlined),
              Text('Food & Dining')
            ]
        ),
        Column(
          children: [
            Icon(Icons.commute_outlined),
            Text('Transport')
          ]
        ),
        Column(
          children: [
            Icon(Icons.shopping_bag_outlined),
            Text('Shopping')
          ]
        ),
        Column(
            children: [
              Icon(Icons.library_books_outlined),
              Text('Education')
            ]
        )
      ]
    );
  }
}