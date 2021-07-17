class Expense {
  final int? id;
  final double amount;
  final String category;

  Expense({this.id, required this.amount, required this.category});

  Map<String, dynamic> toMap() {
    return {'id': id, 'amount': amount, 'category': category};
  }
}
