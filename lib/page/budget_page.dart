import 'package:flutter/material.dart';

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
            children: [for (final tab in tabs) Center(child: Text(tab))]));
  }
}
