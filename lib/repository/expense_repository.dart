import 'package:sqflite/sqflite.dart';
import 'package:g4flutterfraismensuel/models/expense.dart';

class ExpenseRepository {
  final Database database;

  ExpenseRepository({required this.database});

  Future<List<Expense>> getExpenses() async{
    final List<Map<String, dynamic>> maps = await database.query('expenses');
    return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
  }

  Future<int> addExpense(Expense expense) async{
    return await database.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }

  Future<void> updateExpense(Expense expense) async{
    await database.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<void> deleteExpense(int id) async{
    await database.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
