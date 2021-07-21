import 'package:flutter/material.dart';

Map<String, IconData> categoryIcons = {
  'Food & Dining': Icons.fastfood_outlined,
  'Auto & Transport': Icons.commute_outlined,
  'Shopping': Icons.shopping_bag_outlined,
  'Personal Care': Icons.spa_outlined,
  'Health & Fitness': Icons.fitness_center_outlined,
  'Entertainment': Icons.videogame_asset_outlined,
  'Education': Icons.library_books_outlined,
  'Gifts & Donations': Icons.card_giftcard_outlined,
  'Investments': Icons.bar_chart_outlined,
  'Fees & Charges': Icons.attach_money_outlined,
  'Taxes': Icons.receipt_long_outlined,
  'Kids': Icons.child_care_outlined,
  'Bills & Utilities': Icons.build_outlined,
  'Travel': Icons.local_airport_outlined,
  'Others': Icons.category
};

IconData? getIconDataByCategory(String category) {
  if (categoryIcons[category] != null) {
    return categoryIcons[category];
  } else {
    return Icons.help_outline_outlined;
  }
}
