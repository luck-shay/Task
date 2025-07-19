import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../repositories/expense_repository.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseRepository repository;
  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _error;

  ExpenseProvider(this.repository);

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalExpenses => _expenses.fold(0.0, (sum, e) => sum + e.amount);

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();
    try {
      _expenses = repository.getAllExpenses();
      _expenses.sort((a, b) => b.date.compareTo(a.date));
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await repository.addExpense(expense);
    _expenses.add(expense);
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    await repository.deleteExpense(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
