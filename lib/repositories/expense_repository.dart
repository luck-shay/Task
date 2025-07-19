import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

class ExpenseRepository {
  static const String _boxName = 'expenses';
  Box<Expense>? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExpenseAdapter());
    _box = await Hive.openBox<Expense>(_boxName);
  }

  Future<void> addExpense(Expense expense) async {
    await _box?.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    await _box?.delete(id);
  }

  List<Expense> getAllExpenses() {
    return _box?.values.toList() ?? [];
  }

  double getTotalExpenses() {
    final expenses = getAllExpenses();
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }
}
