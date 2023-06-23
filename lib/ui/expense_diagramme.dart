import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g4flutterfraismensuel/models/expense.dart';
import 'package:g4flutterfraismensuel/bloc/expense_bloc.dart';
import 'package:g4flutterfraismensuel/bloc/expense_state.dart';
import 'package:g4flutterfraismensuel/models/expenses_duration.dart';
import 'package:intl/intl.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpensesLoadSuccess) {
          var expenses = ExpenseModelDuration(state.expenses);
          for (var expense in expenses.filterExpenses(const Duration(days: 7))) {
            print('Description: ${expense.description}, Amount: ${expense.amount}, Date: ${expense.date}');
          }
          //print(expenses.filterExpenses(const Duration(days: 30)));
          //print(expenses.filterExpenses(const Duration(days: 365)));
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text('Weekly expenses'),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: BarChart(BarChartData(
                    barGroups: getBarChartData(
                        expenses.filterExpenses(const Duration(days: 7))),
                  )),
                ),
                // const SizedBox(height: 20),
                // const Text('Monthly expenses'),
                // const SizedBox(height: 20),
                // SizedBox(
                //   height: 200,
                //   child: BarChart(BarChartData(
                //     barGroups: getBarChartData(
                //         expenses.filterExpenses(const Duration(days: 30))),
                //   )),
                // ),
                // const SizedBox(height: 20),
                // const Text('Annual expenses'),
                // const SizedBox(height: 20),
                // SizedBox(
                //   height: 200,
                //   child: BarChart(BarChartData(
                //     barGroups: getBarChartData(
                //         expenses.filterExpenses(const Duration(days: 365))),
                //   )),
                // ),
              ],
            ),
          );
        } else if (state is ExpenseLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text('Failed to load expenses'));
        }
      },
    );
  }

  List<BarChartGroupData> getBarChartData(List<Expense> expenses) {
    // Group expenses by day and sum amounts
    Map<String, double> groupedExpenses = {};
    for (Expense expense in expenses) {
      String day = DateFormat('yyyy-MM-dd').format(expense.date);
      groupedExpenses.update(day, (value) => value + expense.amount,
          ifAbsent: () => expense.amount);
    }

    // Sort map by keys (dates)
    var sortedExpenses = SplayTreeMap.from(groupedExpenses);

    // Generate chart data
    final List<BarChartGroupData> chartData = [];
    int barIndex = 0;
    sortedExpenses.forEach((date, totalAmount) {
      chartData.add(
        BarChartGroupData(
          x: barIndex,
          barRods: [
            BarChartRodData(
              toY: totalAmount,
              color: Colors.blueAccent,
            ),
          ],
        ),
      );
      barIndex++;
    });

    // Take last 7 days
    return chartData.length > 7
        ? chartData.sublist(chartData.length - 7)
        : chartData;
  }
}
