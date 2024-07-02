//stacked_bar_chart
import 'dart:math';

import 'package:budgeting_app_v2/widgets/customStackedBarGraphWidget/custom_stacked_bar_graph.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/transaction_model.dart';
import '../providers/user_data_notifier.dart';
import '../widgets/customStackedBarGraphWidget/model/graph_bar.dart';
import '../widgets/customStackedBarGraphWidget/model/graph_bar_section.dart';
import '../widgets/customStackedBarGraphWidget/model/graph_data.dart';
import '../widgets/customStackedBarGraphWidget/model/x_label_configuration.dart';
import '../widgets/customStackedBarGraphWidget/model/y_label_configuration.dart';

class PieGraphScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);

    // Group transactions by date and category
    final groupedData = _groupTransactionsByDateAndCategory(userData.transactions);

    // //horizontal scroll controller
    //  final scrollController = useScrollController();

     //graph zoom scale factor
     final scaleFactor = useState(1.0);
     final baseScaleFactor = useState(1.0);
     final isPinching = useState(false);

    //  //global keys
    // final GlobalKey titleKey = GlobalKey();

    //piechart touched section index
    final touchedIndex = useState(-1);

    //piechart sectionRadius
    final sectionRadius = useState(50.0);

    //get list of dates from groupedData
    //List<DateTime> dates = groupedData.keys.toList();
    final dates = useState(groupedData.keys.toList());
    final selectedDateIndex = useState(dates.value.length - 1);

    // Get data for the latest date
    //final latestDate = groupedData.keys.reduce((a, b) => a.isAfter(b) ? a : b);
    final latestData = useState(groupedData[dates.value[selectedDateIndex.value]]!);

    

    // Create a list of PieChartSectionData from the latestData
    final pieChartSections = useState(
      latestData.value.entries.map((entry) {
        //random color
        final color =  Color((entry.key.hashCode & 0xFFFFFF).toUnsigned(32) | 0xFF000000);
        //Colors.primaries[Random().nextInt(Colors.primaries.length)];
        return PieChartSectionData(
          value: entry.value,
          title: entry.key,
          color: color,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          //radius: (touchedIndex.value == -1) ? sectionRadius.value * scaleFactor.value : sectionRadius.value * scaleFactor.value + 150,
          radius: sectionRadius.value * scaleFactor.value,
        );
      }).toList()
    );
    

    // for(PieChartSectionData section in pieChartSections) {
    //   if(pieChartSections.indexOf(section) == touchedIndex.value) {
    //     //section.radius = sectionRadius.value * scaleFactor.value + 150;
    //     section = PieChartSectionData(
    //       value: section.value,
    //       title: section.title,
    //       color: section.color,
    //       titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    //       radius: sectionRadius.value * scaleFactor.value + 150,
    //     );
    //   }
    // }

    //print pieChartSections
    // print("DEBUG: print pieChartSections");
    // pieChartSections.forEach((element) {
    //   print('Title: ${element.title}, Value: ${element.value}, Color: ${element.color}');
    // });


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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    //title
                    Text(
                      'Date\n${DateFormat.yMMMd().format(dates.value[selectedDateIndex.value])}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(5.0, 5.0),
                          ),
                        ],
                      ),
                    ),
                    //left and right arrow buttons with onTap functions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(flex: 2,),

                        IconButton(
                          icon: const Icon(Icons.arrow_left),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Color(Color.fromARGB(255, 19, 137, 255).value)),
                            shadowColor: WidgetStatePropertyAll(Color(Colors.black.value)),
                            overlayColor: WidgetStatePropertyAll(Color(Color.fromARGB(255, 19, 172, 255).value)),
                            iconColor: WidgetStatePropertyAll(Color(Colors.white.value)),
                          ),
                          onPressed: () {
                            if(selectedDateIndex.value > 0) {
                              selectedDateIndex.value--;
                            }
                          },
                        ),
                        Spacer(flex: 4,),
                        IconButton(
                          icon: const Icon(Icons.arrow_right),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Color(Color.fromARGB(255, 19, 137, 255).value)),
                            shadowColor: WidgetStatePropertyAll(Color(Colors.black.value)),
                            overlayColor: WidgetStatePropertyAll(Color(Color.fromARGB(255, 19, 172, 255).value)),
                            iconColor: WidgetStatePropertyAll(Color(Colors.white.value)),
                          ),
                          onPressed: () {
                            if(selectedDateIndex.value < dates.value.length - 1) {
                              selectedDateIndex.value++;
                            }
                          },
                        ),
                        Spacer(flex: 2,),
                      ],
                    ),
              
                    //sized box with height and width sized to fit PieChat
                    SizedBox(
                      height: (sectionRadius.value * 2 * scaleFactor.value + 60)*2,
                      width: (sectionRadius.value * 2 * scaleFactor.value + 60)*2,
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
                              scaleFactor.value = scaleFactor.value.clamp(0.12, 2.0);
                            },
                            onScaleEnd: (details){
                              // Set the isPinching flag to false when ending the pinch gesture
                              isPinching.value = false;
                      
                              // Store the current scale factor as the base scale factor for the next pinch gesture
                              baseScaleFactor.value = scaleFactor.value;   
                            },
                              
                            
                              
                            behavior: HitTestBehavior.translucent,
                        child: PieChart(
                          PieChartData(
                            sections: pieChartSections.value,
                            centerSpaceRadius: 60,
                            sectionsSpace: 2,
                            pieTouchData: PieTouchData(
                              enabled: false,
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                print("DEBUG");
                                print('DEBUG: event: ${event}, pieTouchResponse: ${pieTouchResponse?.touchedSection?.touchedSectionIndex}');
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex.value = -1;
                                  return;
                                }
                                else
                                {
                                  touchedIndex.value = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                        
                                    //print("DEBUG: pieTouchResponse.touchedSection!.touchedSectionIndex: ${pieTouchResponse.touchedSection!.touchedSectionIndex}");
                        
                                  if(touchedIndex.value >=0 && pieChartSections.value[touchedIndex.value].radius == sectionRadius.value * scaleFactor.value) {
                                    //section.radius = sectionRadius.value * scaleFactor.value + 150;
                                    pieChartSections.value[touchedIndex.value] = PieChartSectionData(
                                      value: pieChartSections.value[touchedIndex.value].value,
                                      title: pieChartSections.value[touchedIndex.value].title,
                                      color: pieChartSections.value[touchedIndex.value].color,
                                      titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                      radius: (sectionRadius.value * scaleFactor.value)*2,
                                    );
                                  }
                                  else
                                  {
                                    if(touchedIndex.value >=0)
                                    {
                                      pieChartSections.value[touchedIndex.value] = PieChartSectionData(
                                        value: pieChartSections.value[touchedIndex.value].value,
                                        title: pieChartSections.value[touchedIndex.value].title,
                                        color: pieChartSections.value[touchedIndex.value].color,
                                        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                        radius: sectionRadius.value * scaleFactor.value,
                                      );
                                    }   
                                  }
                                }
                                
                              
                            },
                          ),
                          ),
                          swapAnimationDuration: Duration(milliseconds: 300), // Optional
                          swapAnimationCurve: Curves.easeInOut, // Optional
                        ),
                      ),
                    ),
                    //card
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            //title
                            Text(
                              'Total Spending\n${NumberFormat.simpleCurrency().format(latestData.value.values.reduce((a, b) => a + b))}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //list of categories and amounts
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: latestData.value.length,
                              itemBuilder: (BuildContext context, int index) {
                                final category = latestData.value.keys.elementAt(index);
                                final amount = latestData.value.values.elementAt(index);
                                return ListTile(
                                  title: Text(category),
                                  trailing: Text(NumberFormat.simpleCurrency().format(amount)),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
