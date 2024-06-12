//stacked_bar_chart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stacked_bar_chart/stacked_bar_chart.dart';
import '../models/transaction_model.dart';
import '../providers/user_data_notifier.dart';

class StackedBarGraphV2 extends HookConsumerWidget {
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
              child: _buildStackedBarChart(groupedData),
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


    //print grounpedData
    print("DEBUG: print groupedData");
    groupedData.forEach((key, value) {
      print('Date: $key');
      value.forEach((category, amount) {
        print('Category: $category, Amount: $amount');
      });
    });
    return groupedData;
  }

  // Build the Stacked Bar Chart using stacked_bar_chart
  Widget _buildStackedBarChart(Map<DateTime, Map<String, double>> groupedData) {
    List<DateTime> dates = groupedData.keys.toList()..sort();
    List<String> categories = groupedData.values.expand((element) => element.keys).toSet().toList();

    List<GraphBar> bars = dates.map((date) {
      List<GraphBarSection> sections = categories.map((category) {
        double value = groupedData[date]![category] ?? 0.0;
        print("DEBUG: value: $value");
        return GraphBarSection(
          value,
          color: _getColorForCategory(category),
        );
      }).toList();
      
      print("DEBUG: dates.length: ${dates.length} categories.length: ${categories.length} sections.length: ${sections.length}");
      print("DEBUG: date: $date ");
      //GraphBar uses month date type!!
      //can only display dates by month on the x-axis
      return GraphBar(
        date,
        sections,
      );
    }).toList();

    //print graph bars
    print("DEBUG: print graph bars");
    bars.forEach((bar) {
      print('Date: ${DateFormat("MMM dd, yyyy").format(bar.month)}');
      bar.sections.forEach((section) {
        print('Category: ${categories[bar.sections.indexOf(section)]}, Amount: ${section.value}');
      });
    });
    return Graph(
      GraphData(
        "Transactions Over Time",
        bars,
        const Color.fromARGB(255, 215, 75, 75),
      ),
      yLabelConfiguration: YLabelConfiguration(
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 11,
        ),
        interval: 50,//_getYAxisInterval(bars),
        labelCount: 5,
        labelMapper: (num value) {
          print("DEBUG!!!: value: $value");
          return NumberFormat.compactCurrency(
            locale: "en",
            decimalDigits: 0,
            symbol: "\$",
          ).format(value);
        },
      ),
      xLabelConfiguration: XLabelConfiguration(
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 11,
        ),
        labelMapper: (DateTime date) {
          print("DEBUG!: date: $date");
          return DateFormat("MMM dd").format(date);
        },
      ),
      graphType: GraphType.StackedRounded, // Use GraphType.StackedRounded for rounded bars
      // netLine: NetLine(
      //   showLine: true,
      //   lineColor: Colors.black,
      //   pointBorderColor: Colors.black,
      //   coreColor: Colors.yellow,
      // ),
      onBarTapped: (GraphBar bar) {
        print('Date: ${DateFormat("MMM dd, yyyy").format(bar.month)}');
      },
    );
  }

  // Helper method to get a color for each category
  Color _getColorForCategory(String category) {
    // You can define custom colors for each category
    switch (category) {
      case 'Food':
        return Colors.blue;
      case 'Bill':
        return Colors.red;
      case 'streaming sub':
        return Colors.green;
      default:
        //random color
        return Color((category.hashCode & 0xFFFFFF).toUnsigned(32) | 0xFF000000);
    }
  }

  // Helper method to calculate the Y-axis interval based on data
  // double _getYAxisInterval(List<GraphBar> bars) {
  //   double maxAmount = bars.fold(0, (prev, bar) {
  //     double barMax = bar.sections.map((section) => section.value).reduce((a, b) => a + b);
  //     return prev > barMax ? prev : barMax;
  //   });
  //   return maxAmount / 5; // Adjust this value as needed
  // }

  // Helper method to calculate the Y-axis interval based on data
 
  // calculate the min and max values of the y-axis and work out the interval from passed in labelCount
  double _getYAxisInterval(List<GraphBar> bars) {
    // double maxAmount = bars.fold(0, (prev, bar) {
    //   double barMax = bar.sections.map((section) => section.value).reduce((a, b) => a + b);
    //   return prev > barMax ? prev : barMax;
    // });
    // double minAmount = bars.fold(0, (prev, bar) {
    //   double barMin = bar.sections.map((section) => section.value).reduce((a, b) => a + b);
    //   return prev < barMin ? prev : barMin;
    // });
    // double range = maxAmount - minAmount;
    // return range / 5; // Adjust this value as needed

     //print graph bars
    // print("DEBUG: print graph bars");
    // bars.forEach((bar) {
    //   print('Date: ${DateFormat("MMM dd, yyyy").format(bar.month)}');
    //   bar.sections.forEach((section) {
    //     print('Category: ${categories[bar.sections.indexOf(section)]}, Amount: ${section.value}');
    //   });
    // });

    double maxAmount = 0;
    double minAmount = 0;

    for (var bar in bars) {
      double barMax = bar.sections.map((section) => section.value).reduce((a, b) => a + b);
      double barMin = bar.sections.map((section) => section.value).reduce((a, b) => a + b);
      maxAmount = maxAmount > barMax ? maxAmount : barMax;
      minAmount = minAmount < barMin ? minAmount : barMin;
    }

    double range = maxAmount - minAmount;
    print("DEBUG!!: range: $range");
    return range / 5; // Adjust this value as needed


  }
}
