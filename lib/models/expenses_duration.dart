import 'package:g4flutterfraismensuel/models/expense.dart';

class ExpenseModelDuration {
  final List<Expense> expenses;

  ExpenseModelDuration(this.expenses);

  List<Expense> filterExpenses(Duration duration) {
    final threshold = DateTime.now().subtract(duration);
    return expenses.where((expense) => expense.date.isAfter(threshold)).toList();
  }
}
