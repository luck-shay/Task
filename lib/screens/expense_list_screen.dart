import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense Tracker')),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.expenses.isEmpty) {
            return Center(child: Text('No expenses yet.'));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' ${provider.totalExpenses.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.expenses.length,
                  itemBuilder: (context, index) {
                    final expense = provider.expenses[index];
                    return Dismissible(
                      key: Key(expense.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        provider.deleteExpense(expense.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Expense deleted')),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(expense.title),
                          subtitle: Text(
                            '${expense.date.toLocal().toString().split(' ')[0]}',
                          ),
                          trailing: Text(
                            ' ${expense.amount.toStringAsFixed(2)}',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:
            () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => AddExpenseScreen())),
      ),
    );
  }
}
