import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0.0;
  DateTime _date = DateTime.now();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final expense = Expense(
        id: Uuid().v4(),
        title: _title,
        amount: _amount,
        date: _date,
      );
      Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (val) => _title = val ?? '',
                validator:
                    (val) =>
                        val == null || val.isEmpty ? 'Enter a title' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (val) => _amount = double.tryParse(val ?? '') ?? 0.0,
                validator:
                    (val) =>
                        val == null || double.tryParse(val) == null
                            ? 'Enter a valid amount'
                            : null,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${_date.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  TextButton(
                    child: Text('Select Date'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: Text('Add Expense')),
            ],
          ),
        ),
      ),
    );
  }
}
