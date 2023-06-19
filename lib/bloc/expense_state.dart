import 'package:equatable/equatable.dart';
import 'package:g4flutterfraismensuel/models/expense.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  const ExpenseLoaded([this.expenses = const []]);
  @override
  List<Object> get props => [expenses];
  @override
  String toString() => 'ExpenseLoaded { expenses: $expenses }';
}

class ExpenseOperationFailure extends ExpenseState {
  final String message;
  const ExpenseOperationFailure({required this.message});
  @override
  List<Object> get props => [message];
  @override
  String toString() => 'ExpenseOperationFailure { message: $message }';
}