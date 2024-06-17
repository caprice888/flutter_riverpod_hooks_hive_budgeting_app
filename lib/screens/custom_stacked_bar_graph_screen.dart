//stacked_bar_chart
import 'package:budgeting_app_v2/widgets/customStackedBarGraphWidget/custom_stacked_bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../providers/user_data_notifier.dart';
import '../widgets/customStackedBarGraphWidget/model/graph_bar.dart';
import '../widgets/customStackedBarGraphWidget/model/graph_bar_section.dart';
import '../widgets/customStackedBarGraphWidget/model/graph_data.dart';
import '../widgets/customStackedBarGraphWidget/model/x_label_configuration.dart';
import '../widgets/customStackedBarGraphWidget/model/y_label_configuration.dart';

class CustomStackedBarGraphScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);

    // Group transactions by date and category
    final groupedData = _groupTransactionsByDateAndCategory(userData.transactions);

    //horizontal scroll controller
     final scrollController = useScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions Over Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
              child: _buildStackedBarChart(groupedData, scrollController, context),
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

  //function to find max amount contained in groupedData
  double _findMaxAmount(Map<DateTime, Map<String, double>> groupedData) {
    double maxAmount = 0;
    groupedData.forEach((key, value) {
      value.forEach((category, amount) {
        if(amount > maxAmount) {
          maxAmount = amount;
        }
      });
    });
    return maxAmount;
  }

  CustomStackedBarGraph _buildStackedBarChart(Map<DateTime, Map<String, double>> groupedData, ScrollController scrollController, BuildContext context) {
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
      print('Date: ${DateFormat("MMM dd, yyyy").format(bar.date)}');
      bar.sections.forEach((section) {
        print('Category: ${categories[bar.sections.indexOf(section)]}, Amount: ${section.value}');
      });
    });


    return CustomStackedBarGraph(
      GraphData(
        "Transactions Over Time",
        bars,
        Color.fromARGB(255, 200, 235, 255),
      ),
      yLabelConfiguration: YLabelConfiguration(
        labelCount: 5,
        maxY: _findMaxAmount(groupedData) +10, //maybe percentage of max amount
        minY: 0,
        decimalPlaces: 2,
        labelPrefix: '\$',    
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 11,
        ),
      ),
      xLabelConfiguration: XLabelConfiguration(
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 11,
        ), 
      ),
      scrollController: scrollController,
      height: MediaQuery.of(context).size.height * 0.3,
    );
  }
  // Build the Stacked Bar Chart using stacked_bar_chart
  // Widget _buildStackedBarChart(Map<DateTime, Map<String, double>> groupedData) {
  //   List<DateTime> dates = groupedData.keys.toList()..sort();
  //   List<String> categories = groupedData.values.expand((element) => element.keys).toSet().toList();

  //   List<GraphBar> bars = dates.map((date) {
  //     List<GraphBarSection> sections = categories.map((category) {
  //       double value = groupedData[date]![category] ?? 0.0;
  //       print("DEBUG: value: $value");
  //       return GraphBarSection(
  //         value,
  //         color: _getColorForCategory(category),
  //       );
  //     }).toList();
      
  //     print("DEBUG: dates.length: ${dates.length} categories.length: ${categories.length} sections.length: ${sections.length}");
  //     print("DEBUG: date: $date ");
  //     //GraphBar uses month date type!!
  //     //can only display dates by month on the x-axis
  //     return GraphBar(
  //       date,
  //       sections,
  //     );
  //   }).toList();

  //   //print graph bars
  //   print("DEBUG: print graph bars");
  //   bars.forEach((bar) {
  //     print('Date: ${DateFormat("MMM dd, yyyy").format(bar.month)}');
  //     bar.sections.forEach((section) {
  //       print('Category: ${categories[bar.sections.indexOf(section)]}, Amount: ${section.value}');
  //     });
  //   });
  //   return Graph(
  //     GraphData(
  //       "Transactions Over Time",
  //       bars,
  //       const Color.fromARGB(255, 215, 75, 75),
  //     ),
  //     yLabelConfiguration: YLabelConfiguration(
  //       labelStyle: TextStyle(
  //         color: Colors.grey,
  //         fontSize: 11,
  //       ),
  //       interval: 50,//_getYAxisInterval(bars),
  //       labelCount: 5,
  //       labelMapper: (num value) {
  //         print("DEBUG!!!: value: $value");
  //         return NumberFormat.compactCurrency(
  //           locale: "en",
  //           decimalDigits: 0,
  //           symbol: "\$",
  //         ).format(value);
  //       },
  //     ),
  //     xLabelConfiguration: XLabelConfiguration(
  //       labelStyle: TextStyle(
  //         color: Colors.grey,
  //         fontSize: 11,
  //       ),
  //       labelMapper: (DateTime date) {
  //         print("DEBUG!: date: $date");
  //         return DateFormat("MMM dd").format(date);
  //       },
  //     ),
  //     graphType: GraphType.StackedRounded, // Use GraphType.StackedRounded for rounded bars
  //     // netLine: NetLine(
  //     //   showLine: true,
  //     //   lineColor: Colors.black,
  //     //   pointBorderColor: Colors.black,
  //     //   coreColor: Colors.yellow,
  //     // ),
  //     onBarTapped: (GraphBar bar) {
  //       print('Date: ${DateFormat("MMM dd, yyyy").format(bar.month)}');
  //     },
  //   );
  // }

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
}
