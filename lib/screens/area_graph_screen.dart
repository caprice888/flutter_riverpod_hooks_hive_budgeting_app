import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../providers/user_data_notifier.dart';

class AreaGraphScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);

    // Group transactions by date and category
    final groupedData = _groupTransactionsByDateAndCategory(userData.transactions);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions Over Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _buildBarChart(groupedData),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to group transactions by date and category
  Map<DateTime, Map<String, double>> _groupTransactionsByDateAndCategory(List<TransactionModel> transactions) {
    Map<DateTime, Map<String, double>> groupedData = {};

    for (var transaction in transactions) {
      DateTime date = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);

      if (!groupedData.containsKey(date)) {
        groupedData[date] = {};
      }

      for (var category in transaction.categoryTags) {
        if (!groupedData[date]!.containsKey(category)) {
          groupedData[date]![category] = 0;
        }
        groupedData[date]![category] = groupedData[date]![category]! + transaction.amount;
      }
    }

    return groupedData;
  }

  // Build the Bar Chart using fl_chart
  Widget _buildBarChart(Map<DateTime, Map<String, double>> groupedData) {
    List<DateTime> dates = groupedData.keys.toList()..sort();
    List<String> categories = groupedData.values.expand((element) => element.keys).toSet().toList();

    List<BarChartGroupData> barGroups = dates.map((date) {
      int dateIndex = dates.indexOf(date);
      List<BarChartRodData> barRods = categories.map((category) {
        double value = groupedData[date]![category] ?? 0.0;
        return BarChartRodData(
          toY: value,
          color: _getColorForCategory(category),
          width: 16,
          borderRadius: BorderRadius.circular(4),
        );
      }).toList();

      return BarChartGroupData(
        x: dateIndex,
        barRods: barRods,
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _getYAxisInterval(barGroups),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int dateIndex = value.toInt();
                if (dateIndex < 0 || dateIndex >= dates.length) return Text('');
                final date = dates[dateIndex];
                return Text(DateFormat('MM/dd').format(date));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        barTouchData: BarTouchData(enabled: true),
        alignment: BarChartAlignment.spaceAround,
      ),
    );
  }

  // Helper method to get a color for each category
  Color _getColorForCategory(String category) {
    // You can define custom colors for each category
    switch (category) {
      case 'Food':
        return Colors.blue;
      case 'Bills':
        return Colors.red;
      case 'Entertainment':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Helper method to calculate the Y-axis interval based on data
  double _getYAxisInterval(List<BarChartGroupData> barGroups) {
    double maxAmount = barGroups.fold(0, (prev, element) {
      double elementMax = element.barRods.map((rod) => rod.toY).reduce((a, b) => a > b ? a : b);
      return prev > elementMax ? prev : elementMax;
    });
    return maxAmount / 5; // Adjust this value as needed
  }
}
