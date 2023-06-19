import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g4flutterfraismensuel/bloc/expense_bloc.dart';
import 'package:g4flutterfraismensuel/bloc/expense_event.dart';
import 'package:g4flutterfraismensuel/models/expense.dart';
import 'package:g4flutterfraismensuel/ui/add_edit_screen.dart';
import 'package:g4flutterfraismensuel/ui/expense_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des frais mensuels'),
      ),
      body: ExpenseList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return AddEditScreen(
                onSave: (description, amount) {
                  BlocProvider.of<ExpenseBloc>(context).add(
                    ExpenseAdded(
                      expense: Expense(
                        id: DateTime.now().millisecondsSinceEpoch,
                        description: description,
                        amount: amount,
                        date: DateTime.now(),
                      ),
                    ),
                  );
                },
                isEditing: false,
              );
            }),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}