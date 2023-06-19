import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g4flutterfraismensuel/bloc/expense_event.dart';
import 'package:g4flutterfraismensuel/bloc/expense_state.dart';
import 'package:g4flutterfraismensuel/models/expense.dart';
import 'package:g4flutterfraismensuel/repository/expense_repository.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository expenseRepository;

  ExpenseBloc({required this.expenseRepository}) : super(ExpenseLoading());

  @override
  Stream<ExpenseState> mapEventToState(ExpenseEvent) async*{
    if (ExpenseEvent is ExpenseLoaded) {
      yield* _mapExpenseLoadedToState();
    } else if (ExpenseEvent is ExpenseAdded) {
      yield* _mapExpenseAddedToState(ExpenseEvent);
    } else if (ExpenseEvent is ExpenseUpdated) {
      yield* _mapExpenseUpdatedToState(ExpenseEvent);
    } else if (ExpenseEvent is ExpenseDeleted) {
      yield* _mapExpenseDeletedToState(ExpenseEvent);
    }
  }

  Stream<ExpenseState> _mapExpenseLoadedToState() async*{
    try {
      final expenses = await expenseRepository.getExpenses();
      yield ExpensesLoadSuccess(expenses);
    } catch (_) {
      yield const ExpenseOperationFailure(message: 'Could not load expenses');
    }
  }

  Stream<ExpenseState> _mapExpenseAddedToState(ExpenseAdded event) async*{
    if (state is ExpensesLoadSuccess) {
      final List<Expense> updatedExpenses = List.from((state as ExpensesLoadSuccess).expenses)..add(event.expense);
      yield ExpensesLoadSuccess(updatedExpenses);
      await expenseRepository.addExpense(event.expense);
    }
  }

  Stream<ExpenseState> _mapExpenseUpdatedToState(ExpenseUpdated event) async*{
    if(state is ExpensesLoadSuccess){
      final List<Expense> updatedExpenses = (state as ExpensesLoadSuccess)
        .expenses
        .map((expense)=> expense.id == event.expense.id ? event.expense : expense)
        .toList();
      yield ExpensesLoadSuccess(updatedExpenses);
      await expenseRepository.updateExpense(event.expense);
    }
  }

  
}
