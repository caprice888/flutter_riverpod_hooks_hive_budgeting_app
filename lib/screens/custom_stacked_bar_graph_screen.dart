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

     //graph zoom scale factor
     final scaleFactor = useState(1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions Over Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: _buildStackedBarChart(groupedData, scrollController, scaleFactor, context)),
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
    // print("DEBUG: print groupedData");
    // groupedData.forEach((key, value) {
    //   print('Date: $key');
    //   value.forEach((category, amount) {
    //     print('Category: $category, Amount: $amount');
    //   });
    // });
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

  Widget _buildStackedBarChart(Map<DateTime, Map<String, double>> groupedData, ScrollController scrollController, ValueNotifier<double> scaleFactor, BuildContext context) {
    List<DateTime> dates = groupedData.keys.toList()..sort();
    List<String> categories = groupedData.values.expand((element) => element.keys).toSet().toList();

    //print categories
    // print("DEBUG: print categories");
    // categories.forEach((category) {
    //   print('Category: $category');
    // });

    List<GraphBar> bars = dates.map((date) {
      List<GraphBarSection> sections = categories.map((category) {
        double value = groupedData[date]![category] ?? 0.0;
        //print("DEBUG: value: $value");
        return GraphBarSection(
          value,
          color: _getColorForCategory(category),
        );
      }).toList();
      
      //print("DEBUG: dates.length: ${dates.length} categories.length: ${categories.length} sections.length: ${sections.length}");
      //print("DEBUG: date: $date ");
      //GraphBar uses month date type!!
      //can only display dates by month on the x-axis
      return GraphBar(
        date,
        sections,
      );
    }).toList();

    //print graph bars
    // print("DEBUG: print graph bars");
    // bars.forEach((bar) {
    //   print('Date: ${DateFormat("MMM dd, yyyy").format(bar.date)}');
    //   bar.sections.forEach((section) {
    //     print('Category: ${categories[bar.sections.indexOf(section)]}, Amount: ${section.value}');
    //   });
    // });

    return CustomStackedBarGraph(
      GraphData(
        "Transactions Over Time",
        bars,
        Color.fromARGB(255, 200, 235, 255),
      ),
      yLabelConfiguration: YLabelConfiguration(
        labelCount: 4,
        
        maxY: scaleFactor.value * _findMaxAmount(groupedData) +10, //maybe percentage of max amount
        minY: 0,
        decimalPlaces: 2,
        labelPrefix: '\$',    
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      xLabelConfiguration: XLabelConfiguration(
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ), 
      ),
      scrollController: scrollController,
      height: MediaQuery.of(context).size.height * 0.8,
      onBarTapped: (value){
        print("Bar Tapped $value");
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

}
