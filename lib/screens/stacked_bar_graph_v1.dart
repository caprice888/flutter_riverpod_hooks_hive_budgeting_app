// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:intl/intl.dart';
// import '../models/transaction_model.dart';
// import '../providers/user_data_notifier.dart';

// class StackedBarChartV1 extends HookConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userData = ref.watch(userDataProvider);

//     // Group transactions by date and category
//     final groupedData = _groupTransactionsByDateAndCategory(userData.transactions);

//     // Create series list for the bar chart
//     final seriesList = _createSeriesList(groupedData);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Transactions Over Time'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: charts.BarChart(
//           seriesList,
//           animate: true,
//           barGroupingType: charts.BarGroupingType.stacked,
//         ),
//       ),
//     );
//   }

//   // Helper method to group transactions by date and category
//   Map<DateTime, Map<String, double>> _groupTransactionsByDateAndCategory(List<TransactionModel> transactions) {
//     Map<DateTime, Map<String, double>> groupedData = {};

//     for (var transaction in transactions) {
//       DateTime date = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);

//       if (!groupedData.containsKey(date)) {
//         groupedData[date] = {};
//       }

//       for (var category in transaction.categoryTags) {
//         if (!groupedData[date]!.containsKey(category)) {
//           groupedData[date]![category] = 0;
//         }
//         groupedData[date]![category] = groupedData[date]![category]! + transaction.amount;
//       }
//     }

//     return groupedData;
//   }

//   // Create series list for the bar chart
//   List<charts.Series<OrdinalSales, String>> _createSeriesList(Map<DateTime, Map<String, double>> groupedData) {
//     List<DateTime> dates = groupedData.keys.toList()..sort();
//     List<String> categories = groupedData.values.expand((element) => element.keys).toSet().toList();

//     List<charts.Series<OrdinalSales, String>> seriesList = [];

//     for (var category in categories) {
//       List<OrdinalSales> data = dates.map((date) {
//         return OrdinalSales(DateFormat('MM/dd').format(date), groupedData[date]![category] ?? 0.0);
//       }).toList();

//       seriesList.add(
//         charts.Series<OrdinalSales, String>(
//           id: category,
//           domainFn: (OrdinalSales sales, _) => sales.date,
//           measureFn: (OrdinalSales sales, _) => sales.amount,
//           data: data,
//           colorFn: (_, __) => _getColorForCategory(category),
//         ),
//       );
//     }

//     return seriesList;
//   }

//   // Helper method to get a color for each category
//   charts.Color _getColorForCategory(String category) {
//     switch (category) {
//       case 'Food':
//         return charts.MaterialPalette.blue.shadeDefault;
//       case 'Bills':
//         return charts.MaterialPalette.red.shadeDefault;
//       case 'Entertainment':
//         return charts.MaterialPalette.green.shadeDefault;
//       default:
//         return charts.MaterialPalette.gray.shadeDefault;
//     }
//   }
// }

// // Sample ordinal data type.
// class OrdinalSales {
//   final String date;
//   final double amount;

//   OrdinalSales(this.date, this.amount);
// }
