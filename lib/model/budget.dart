class Budget {
  final int? id;
  final double budget;
  final String category;

  Budget({this.id, required this.budget, required this.category});

  Map<String, dynamic> toMap() {
    return {'id': id, 'budget': budget, 'category': category};
  }
}
