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
    final List<Map<String, dynamic>> maps = await db.query('expenses');
    return List.generate(maps.length, (i) {
      return Expense(
          id: maps[i]['id'],
          amount: maps[i]['amount'],
          category: maps[i]['category'],
          timestamp: maps[i]['timestamp']);
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
      print(budgets);
      print(row);
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
    final List<Map<String, dynamic>> maps = await db.query('budgets');
    return List.generate(maps.length, (i) {
      return Budget(
          id: maps[i]['id'],
          budget: maps[i]['budget'],
          category: maps[i]['category']);
    });
  }
}
