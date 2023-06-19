import 'package:equatable/equatable.dart';
import 'package:g4flutterfraismensuel/models/expense.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class ExpenseLoaded extends ExpenseEvent {}

class ExpenseAdded extends ExpenseEvent {
  final Expense expense;
  const ExpenseAdded({required this.expense});
  @override
  List<Object> get props => [expense];
  @override
  String toString() => 'ExpenseAdded { expense: $expense }';
}

class ExpenseUpdated extends ExpenseEvent {
  final Expense expense;
  const ExpenseUpdated({required this.expense});
  @override
  List<Object> get props => [expense];
  @override
  String toString() => 'ExpenseUpdated { expense: $expense }';
}

class ExpenseDeleted extends ExpenseEvent {
  final int id;
  const ExpenseDeleted({required this.id});
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'ExpenseDeleted { expense: $id }';
}