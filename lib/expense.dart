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