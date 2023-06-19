import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g4flutterfraismensuel/bloc/expense_bloc.dart';
import 'package:g4flutterfraismensuel/models/database.dart';
import 'package:g4flutterfraismensuel/repository/expense_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'ui/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseProvider databaseProvider = DatabaseProvider.instance;
  try {
    Database? database = await databaseProvider.database;
    runApp(MyApp(database: database!));
  } catch (e) {
    print('Erreur lors de l\'initialisation de la base de données : $e');
  }
}

class MyApp extends StatelessWidget {
  final Database database;
  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ExpenseBloc(expenseRepository: ExpenseRepository(database: database)),
      child: MaterialApp(
        title: 'Gestion des frais mensuels',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
