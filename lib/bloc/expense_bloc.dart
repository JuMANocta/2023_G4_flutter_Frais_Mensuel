import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g4flutterfraismensuel/bloc/expense_event.dart';
import 'package:g4flutterfraismensuel/bloc/expense_state.dart';
import 'package:g4flutterfraismensuel/models/expense.dart';
import 'package:g4flutterfraismensuel/repository/expense_repository.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository expenseRepository;

  ExpenseBloc({required this.expenseRepository}) : super(ExpenseLoading()) {
    on<ExpenseLoaded>(_onExpenseLoaded);
    on<ExpenseAdded>(_onExpenseAdded);
    on<ExpenseUpdated>(_onExpenseUpdated);
    on<ExpenseDeleted>(_onExpenseDeleted);

    add(ExpenseLoaded());
  }

  Future<void> _onExpenseLoaded(
      ExpenseLoaded event, Emitter<ExpenseState> emit) async {
    try {
      print('ExpenseLoaded');
      final expenses = await expenseRepository.getExpenses();
      print('ExpenseLoaded->ExpensesLoadSuccess');
      emit(ExpensesLoadSuccess(expenses));
    } catch (error) {
      emit(const ExpenseOperationFailure(message: 'Could not load expenses'));
    }
  }

  Future<void> _onExpenseAdded(
      ExpenseAdded event, Emitter<ExpenseState> emit) async {
    if (state is ExpensesLoadSuccess) {
      final List<Expense> updatedExpenses =
          List.from((state as ExpensesLoadSuccess).expenses)
            ..add(event.expense);
      emit(ExpensesLoadSuccess(updatedExpenses));
      await expenseRepository.addExpense(event.expense);
    }
  }

  Future<void> _onExpenseUpdated(
      ExpenseUpdated event, Emitter<ExpenseState> emit) async {
    if (state is ExpensesLoadSuccess) {
      final List<Expense> updatedExpenses = (state as ExpensesLoadSuccess)
          .expenses
          .map((expense) =>
              expense.id == event.expense.id ? event.expense : expense)
          .toList();
      emit(ExpensesLoadSuccess(updatedExpenses));
      await expenseRepository.updateExpense(event.expense);
    }
  }

  Future<void> _onExpenseDeleted(
      ExpenseDeleted event, Emitter<ExpenseState> emit) async {
    if (state is ExpensesLoadSuccess) {
      final updatedExpenses = (state as ExpensesLoadSuccess)
          .expenses
          .where((expense) => expense.id != event.id)
          .toList();
      emit(ExpensesLoadSuccess(updatedExpenses));
      await expenseRepository.deleteExpense(event.id);
    }
  }
}
