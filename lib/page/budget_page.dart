import 'package:flutter/material.dart';

class BudgetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BudgetPageState();
  }
}

class BudgetPageState extends State<BudgetPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add Budget')),
        body: Form(key: _formKey, child: Text('Budget page')));
  }
}
