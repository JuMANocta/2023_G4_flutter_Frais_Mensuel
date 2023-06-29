import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g4flutterfraismensuel/bloc/expense_bloc.dart';
import 'package:g4flutterfraismensuel/bloc/expense_event.dart';
import 'package:g4flutterfraismensuel/models/expense.dart';
import 'package:g4flutterfraismensuel/ui/add_edit_screen.dart';
import 'package:g4flutterfraismensuel/ui/expense_list.dart';
import 'package:g4flutterfraismensuel/ui/expense_diagramme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedMenu = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des frais mensuels'),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (int result) {
              setState(() {
                _selectedMenu = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Liste des frais'),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Diagramme des dépenses'),
              ),
            ],
          ),
        ],
      ),
      body: _selectedMenu == 0 ? const ExpenseList() : const ExpenseChart(),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
