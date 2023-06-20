import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g4flutterfraismensuel/bloc/expense_bloc.dart';
import 'package:g4flutterfraismensuel/bloc/expense_event.dart';
import 'package:g4flutterfraismensuel/bloc/expense_state.dart';
import 'package:g4flutterfraismensuel/ui/add_edit_screen.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExpensesLoadSuccess) {
          final expenses = state.expenses;
          if (expenses.isEmpty) {
            return const Center(child: Text('Aucun frais enregistré'));
          } else {
            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text('${expense.description} - ${expense.id}'),
                  subtitle: Text('${expense.amount}€ - ${expense.date}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      BlocProvider.of<ExpenseBloc>(context)
                          .add(ExpenseDeleted(id: expense.id!));
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return AddEditScreen(
                          onSave: (description, amount) {
                            BlocProvider.of<ExpenseBloc>(context).add(
                              ExpenseUpdated(
                                expense: expense.copyWith(
                                  description: description,
                                  amount: amount,
                                ),
                              ),
                            );
                          },
                          isEditing: true,
                          expense: expense,
                        );
                      }),
                    );
                  },
                );
              },
            );
          }
        } else {
          return const Center(child: Text('Erreur de chargement des données'));
        }
      },
    );
  }
}
