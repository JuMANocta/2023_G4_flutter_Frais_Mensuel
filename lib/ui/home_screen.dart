import 'package:flutter/material.dart';
import 'package:g4flutterfraismensuel/models/expense.dart';
import 'package:g4flutterfraismensuel/ui/expense_list.dart';

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des frais mensuels'),
      ),
      body: ExpenseList(),
    );
  }

}