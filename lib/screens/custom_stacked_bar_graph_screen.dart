//stacked_bar_chart
import 'package:budgeting_app_v2/widgets/customStackedBarGraphWidget/custom_stacked_bar_graph.dart';
import 'package:flutter/foundation.dart';
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
     final baseScaleFactor = useState(1.0);
     final isPinching = useState(false);

     //global keys
    final GlobalKey titleKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions Over Time'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            height: double.infinity,
            decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logoPlainDark.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
            child: Column(
              children: [
                Text(
                'Double tap ${kIsWeb ? "" : "then pinch " }to zoom: ${scaleFactor.value.toStringAsFixed(2)}', 
                key: titleKey,
                style: const TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white,
                  shadows: 
                  <Shadow>[
                    Shadow(
                      offset: Offset(3.0, 3.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    Shadow(
                      offset: Offset(3.0, 3.0),
                      blurRadius: 8.0,
                      color: Color.fromARGB(123, 36, 36, 245),
                    ),
                  ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: GestureDetector(
                      onDoubleTap: () {
                        //scaleFactor.value = scaleFactor.value
                        if(kIsWeb)
                        {
                          if(scaleFactor.value < 0.06) 
                          {
                            scaleFactor.value = 1.0;
                          }
                          else
                          {
                            scaleFactor.value /= 2.0;        
                          }
                        }
                        else
                        {
                          isPinching.value = !isPinching.value;
                        }      
                      },
                      onScaleStart: (details) {
                        // Set the isPinching flag to true when starting to scale
                        isPinching.value = true;
                
                        // Store the initial scale factor when starting to scale
                        scaleFactor.value = baseScaleFactor.value;
                      },
                      onScaleUpdate: (ScaleUpdateDetails details) {
                        // Update the scale factor based on the scale details from the pinch gesture
                        scaleFactor.value = baseScaleFactor.value * details.scale;
                
                        // Clamp the scale factor to prevent it from becoming too small or too large
                        scaleFactor.value = scaleFactor.value.clamp(0.12, 4.0);
                      },
                      onScaleEnd: (details){
                        // Set the isPinching flag to false when ending the pinch gesture
                        isPinching.value = false;
                
                        // Store the current scale factor as the base scale factor for the next pinch gesture
                        baseScaleFactor.value = scaleFactor.value;   
                      },
          
                      
          
                      behavior: HitTestBehavior.translucent, 
                      child: AbsorbPointer(
                        absorbing: isPinching.value,
                        child: CustomStackedBarGraph(
                          key:  Key('scaleFactor-${scaleFactor.value.toString()}'), // Add a unique key
                          GraphData(
                            "Transactions Over Time",
                            _buildStackedBars(groupedData, scrollController, scaleFactor, context),//bars,
                            Color.fromARGB(44, 200, 235, 255),
                          ),
                          yLabelConfiguration: YLabelConfiguration(
                            labelCount: 4,
                            maxY: scaleFactor.value * _findMaxAmount(groupedData) +10,
                            minY: 0,
                            decimalPlaces: 2,
                            labelPrefix: '\$',    
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 239, 233, 233),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              shadows: 
                                <Shadow>[
                                  Shadow(
                                    //offset: Offset(3.0, 3.0),
                                    blurRadius: 6.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  Shadow(
                                    offset: Offset(3.0, 3.0),
                                    blurRadius: 8.0,
                                    color: Color.fromARGB(121, 63, 124, 255),
                                  ),
                                ],
                              ),
                            ),
                            xLabelConfiguration: XLabelConfiguration(
                              showDay: true,
                              showMonth: true,
                              showYear: false,
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 239, 233, 233),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                shadows: 
                                  <Shadow>[
                                    Shadow(
                                      offset: Offset(3.0, 3.0),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    Shadow(
                                      offset: Offset(3.0, 3.0),
                                      blurRadius: 8.0,
                                      color: Color.fromARGB(123, 36, 36, 245),
                                    ),
                                  ],
                              ), 
                            ),
                            scrollController: scrollController,
                            height: constraints.maxHeight - ((titleKey.currentContext !=null && titleKey.currentContext!.size !=null) ? titleKey.currentContext!.size!.height : 0) - 175.0,
                            onBarTapped: (GraphBar value){
                              print("Bar Tapped ${value.date} with value ${value.sections.map((e) => e.value).reduce((a, b) => a + b)}");
                            },
                          ),
                      ),
                    ),
                      
                    //_buildStackedBarChart(groupedData, scrollController, scaleFactor, context)),
                  ),
                ),
              ],
            ),
          );
        }
      )
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

  List<GraphBar> _buildStackedBars(Map<DateTime, Map<String, double>> groupedData, ScrollController scrollController, ValueNotifier<double> scaleFactor, BuildContext context) {
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

    return bars;
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
