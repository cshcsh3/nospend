import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
}
