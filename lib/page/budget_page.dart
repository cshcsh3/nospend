import 'package:flutter/material.dart';
import 'package:nospend/model/budget.dart';

import '../db.dart';
import '../util.dart';

class BudgetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BudgetPageState();
  }
}

class BudgetPageState extends State<BudgetPage>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);

  final _formKey = GlobalKey<FormState>();
  NospendDatabase db = NospendDatabase.instance;
  String budgetAmount = '';
  String selectedCategory = '';

  @override
  String get restorationId => 'budget_tabs';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  Widget _budgetOverviewTab() {
    return Center(child: Text('Budget Overview Tab'));
  }

  void _onAddBudgetSubmit() {
    // Can use form validator too but not going to since it's just one field
    if (budgetAmount != null ||
        budgetAmount.isNotEmpty ||
        selectedCategory != null ||
        selectedCategory.isNotEmpty) {
      double convertedBudgetAmount = double.parse(budgetAmount);
      Budget budget =
          new Budget(budget: convertedBudgetAmount, category: selectedCategory);
      db.createBudget(budget).then((isSuccess) => {
            if (isSuccess) {Navigator.pop(context, true)}
          });
    }
  }

  Widget _category(String text) {
    return Container(
        padding: const EdgeInsets.all(5),
        child: Column(children: <Widget>[
          IconButton(
            icon: Icon(getIconDataByCategory(text)),
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

  Widget _addBudgetTab() {
    const sizedBoxSpace = SizedBox(height: 24);

    return Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.all(16), children: <Widget>[
          Text('Set budget', style: TextStyle(fontWeight: FontWeight.bold)),
          TextFormField(
              onChanged: (value) {
                if (value != null || value.isNotEmpty) {
                  setState(() {
                    budgetAmount = value;
                  });
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Budget', hintText: 'Set budget amount')),
          sizedBoxSpace,
          Text('Budget category',
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
                _category('Food & Dining'),
                _category('Auto & Transport'),
                _category('Shopping'),
                _category('Personal Care'),
                _category('Health & Fitness'),
                _category('Entertainment'),
                _category('Education'),
                _category('Gifts & Donations'),
                _category('Investments'),
                _category('Fees & Charges'),
                _category('Taxes'),
                _category('Kids'),
                _category('Bills & Utilities'),
                _category('Travel'),
                _category('Others'),
              ]),
          sizedBoxSpace,
          Center(
              child: ElevatedButton(
                  onPressed: _onAddBudgetSubmit, child: Text('Submit')))
        ]));
  }

  Widget _tabHelper(int index) {
    if (index == 0) return _budgetOverviewTab();
    return _addBudgetTab();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Budget Overview', 'Add Budget'];

    return Scaffold(
        appBar: AppBar(
          title: Text('Budget'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: [
              for (final tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
            controller: _tabController,
            children: [for (int i = 0; i < tabs.length; i++) _tabHelper(i)]));
  }
}
