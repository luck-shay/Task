import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/expense.dart';
import 'repositories/expense_repository.dart';
import 'providers/expense_provider.dart';
import 'screens/expense_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = ExpenseRepository();
  await repository.init();
  runApp(ExpenseTrackerApp(repository: repository));
}

class ExpenseTrackerApp extends StatelessWidget {
  final ExpenseRepository repository;
  const ExpenseTrackerApp({Key? key, required this.repository})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExpenseProvider(repository)..loadExpenses(),
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'System',
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: const ExpenseListScreen(),
      ),
    );
  }
}
