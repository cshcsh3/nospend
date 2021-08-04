import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/budget.dart';
import 'model/expense.dart';

class NospendDatabase {
  static final NospendDatabase instance = NospendDatabase._init();

  static Database? _database;

  NospendDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('nospend.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE expenses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount REAL NOT NULL,
      category TEXT NOT NULL,
      timestamp INTEGER NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE budgets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      budget REAL NOT NULL,
      category TEXT NOT NULL UNIQUE
    )
    ''');
  }

  Future<bool> createExpense(Expense expense) async {
    final db = await instance.database;
    int id = await db.insert('expenses', expense.toMap());
    if (id == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<Expense>> getExpenses() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query('expenses');
    return List.generate(results.length, (i) {
      return Expense(
          id: results[i]['id'],
          amount: results[i]['amount'],
          category: results[i]['category'],
          timestamp: results[i]['timestamp']);
    });
  }

  Future<void> deleteExpense(int? expenseId) async {
    final db = await instance.database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [expenseId]);
  }

  Future<bool> createOrUpdateBudget(Budget budget) async {
    final db = await instance.database;
    Map<String, dynamic> row = {
      'budget': budget.budget,
      'category': budget.category
    };
    final List<Map<String, dynamic>> budgets = await db
        .query('budgets', where: 'category = ?', whereArgs: [budget.category]);
    int id = 0;
    if (budgets.length == 0) {
      id = await db.insert('budgets', budget.toMap());
    } else {
      final Map<String, dynamic> row = {
        'id': budgets[0]['id'],
        'budget': budget.budget,
        'category': budget.category
      };
      id = await db.update('budgets', row,
          where: 'id = ?', whereArgs: [budgets[0]['id']]);
    }
    if (id > 0) {
      return true;
    }
    return false;
  }

  Future<void> deleteBudget(int? budgetId) async {
    final db = await instance.database;
    await db.delete('budgets', where: 'id = ?', whereArgs: [budgetId]);
  }

  Future<List<Budget>> getBudgets() async {
    final db = await instance.database;

    // Get all budgets
    final List<Map<String, dynamic>> budgets = await db.query('budgets');

    // Get current month total expenses by category
    DateTime now = DateTime.now();
    DateTime startingDatetime = new DateTime(now.year, now.month, 1);
    DateTime endingDatetime = (now.month < 12)
        ? new DateTime(now.year, now.month + 1, 0)
        : new DateTime(now.year + 1, 1, 0);

    int startingTimestamp = startingDatetime.millisecondsSinceEpoch;
    int endingTimestamp = endingDatetime.millisecondsSinceEpoch;

    final List<Map<String, dynamic>> expenses = await db.rawQuery('''
        SELECT expenses.category as category, SUM(expenses.amount) AS total_spending
        FROM budgets
        LEFT JOIN expenses ON budgets.category = expenses.category
        WHERE expenses.timestamp >= ? AND expenses.timestamp <= ?
        GROUP BY expenses.category
        ''', [startingTimestamp, endingTimestamp]);

    return List.generate(budgets.length, (i) {
      return Budget(
          id: budgets[i]['id'],
          budget: budgets[i]['budget'],
          category: budgets[i]['category'],
          totalSpending: expenses.firstWhere((expense) =>
              expense['category'] == budgets[i]['category'])['total_spending']);
    });
  }
}
