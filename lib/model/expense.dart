class Expense {
  final int? id;
  final double amount;
  final String category;
  final int timestamp;

  Expense(
      {this.id,
      required this.amount,
      required this.category,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'timestamp': timestamp
    };
  }
}
