import 'dart:math';
import 'package:g4flutterfraismensuel/models/expense.dart';
import 'package:g4flutterfraismensuel/repository/expense_repository.dart';

Future<void> generateExpense(database) async{
  final Random random = Random();

  for(int month = 1; month <= 12; month++){
    // générer entre 5 et 10 dépenses par mois
    final int nbExpense = random.nextInt(5) + 5;
    for(int i = 0; i < nbExpense; i++){
      // générer une date aléatoire dans le mois
      final int day = random.nextInt(28) + 1;
      // générer un mois aléatoire
      final int month = random.nextInt(12) + 1;
      // générer une année aléatoire entre 2021 et 2023
      final int year = random.nextInt(3) + 2021;
      // final int year = 2022;
      // générer une heure minutes et seconde aléatoire
      final int hour = random.nextInt(24);
      final int minute = random.nextInt(60);
      final int second = random.nextInt(60);
      // générer une date avec l'heure minutes seconde à partir des valeurs aléatoires
      final DateTime date = DateTime(year, month, day, hour, minute, second);
      // générer un id en time stamp selon la date trouvé
      final int id = date.millisecondsSinceEpoch;

      // générer une description aléatoire selon un tableau de description
      final List<String> descriptions = [
        'Frais de déplacement',
        'Frais de repas',
        'Frais de réception',
        'Frais de taxi',
        'Frais de parking',
        'Frais de péage',
        'Frais de carburant',
        'Frais de blabla',
        'Frais de blibli',
        'Frais de blublu',
        'Frais de blablabla',
        'Frais de bliblibli',
        'Frais de blublublu',
      ];
      // générer un montant aléatoire entre 1 et 100
      final int amount = random.nextInt(100) + 1;

      // créer la dépense et l'insérer dans la base de données
      final expense = Expense(
        id: id,
        description: descriptions[random.nextInt(descriptions.length)],
        amount: amount.toDouble(),
        date: date,
      );
      // insérer la dépence créer dans la base de données
      await ExpenseRepository(database : database).addExpense(expense);
    }
  }
}