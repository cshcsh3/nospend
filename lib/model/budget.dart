class Budget {
  final int? id;
  final double budget;
  final String category;
  double? totalSpending;

  Budget(
      {this.id,
      required this.budget,
      required this.category,
      this.totalSpending});

  Map<String, dynamic> toMap() {
    return {'id': id, 'budget': budget, 'category': category};
  }
}
