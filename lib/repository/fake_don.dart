import 'dart:math';
import 'package:g4flutterfraismensuel/models/expense.dart';
import 'package:g4flutterfraismensuel/repository/expense_repository.dart';

Future<void> generateExpense(database) async {
  final Random random = Random();
  final DateTime now = DateTime.now();

  for (int month = 1; month <= 12; month++) {
    // générer entre 5 et 10 dépenses par mois
    final int nbExpense = random.nextInt(5) + 5;
    for (int i = 0; i < nbExpense; i++) {
      // générer une date aléatoire dans le mois
      final int day = random.nextInt(28) + 1;
      // générer un mois aléatoire
      int generatedMonth = random.nextInt(12) + 1;

      // générer une année aléatoire entre 2021 et l'année actuelle
      final int year = random.nextInt(now.year - 2020 + 1) + 2020;

      // Si l'année générée est l'année actuelle, s'assurer que le mois généré n'est pas supérieur au mois actuel
      if (year == now.year) {
        while (generatedMonth > now.month) {
          generatedMonth = random.nextInt(12) + 1;
        }
      }

      // générer une heure, minute et seconde aléatoires
      final int hour = random.nextInt(24);
      final int minute = random.nextInt(60);
      final int second = random.nextInt(60);

      // générer une date avec l'heure, minute et seconde à partir des valeurs aléatoires
      final DateTime date = DateTime(year, generatedMonth, day, hour, minute, second);

      // générer un id en timestamp selon la date trouvée
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

      // insérer la dépense créée dans la base de données
      await ExpenseRepository(database: database).addExpense(expense);
    }
  }
}
