import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g4flutterfraismensuel/models/expense.dart';
import 'package:g4flutterfraismensuel/bloc/expense_bloc.dart';
import 'package:g4flutterfraismensuel/bloc/expense_state.dart';
import 'package:g4flutterfraismensuel/models/expenses_duration.dart';
import 'package:intl/intl.dart';

class ExpenseChart extends StatefulWidget {
  const ExpenseChart({Key? key}) : super(key: key);

  @override
  State<ExpenseChart> createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> {
  Map<String, double> sortedExpenses = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpensesLoadSuccess) {
          var expenses = ExpenseModelDuration(state.expenses);
          var filteredExpenses =
              expenses.filterExpenses(const Duration(days: 365));
          var chartData = getBarChartData(filteredExpenses);
          return Center(
              child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: AspectRatio(
                aspectRatio: 1,
                child: BarChart(
                  BarChartData(
                    barGroups: chartData,
                    borderData: FlBorderData(
                        border: const Border(
                            bottom: BorderSide(), left: BorderSide())),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                      leftTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                  ),
                ),
              ),
            )
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
    // Group expenses by month and sum amounts
    Map<String, double> groupedExpenses = {};
    for (Expense expense in expenses) {
      String month = DateFormat('yyyy-MM').format(expense.date);
      groupedExpenses.update(month, (value) => value + expense.amount,
          ifAbsent: () => expense.amount);
    }

    // Sort map by keys (months)
    sortedExpenses = SplayTreeMap.from(groupedExpenses);

    // Generate chart data
    final List<BarChartGroupData> chartData = [];
    int barIndex = 0;
    sortedExpenses.forEach((month, totalAmount) {
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

    // Take last 12 months
    return chartData.length > 12
        ? chartData.sublist(chartData.length - 12)
        : chartData;
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          if (value >= 0 && value < sortedExpenses.keys.length) {
            var dateString = sortedExpenses.keys.elementAt(value.toInt());
            var date = DateTime(int.parse(dateString.split('-')[0]),
                int.parse(dateString.split('-')[1]), 1);
            return Text(DateFormat('MMM').format(date));
          } else {
            return const Text('');
          }
        },
      );
}
