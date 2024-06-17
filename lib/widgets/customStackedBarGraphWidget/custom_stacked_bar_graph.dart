import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:intl/intl.dart';

import 'model/graph_bar.dart';
import 'model/graph_data.dart';
import 'model/x_label_configuration.dart';
import 'model/y_label_configuration.dart';

class CustomStackedBarGraph extends StatelessWidget {
  final GraphData data;
  final XLabelConfiguration? xLabelConfiguration;
  final YLabelConfiguration? yLabelConfiguration;
  final ScrollController? scrollController;
  final double height;
  final double? minWidth;
  final Function(GraphBar)? onBarTapped;
  final double barWidth;

  CustomStackedBarGraph(
    this.data, {
    Key? key,
    this.xLabelConfiguration,
    this.yLabelConfiguration,
    this.scrollController,
    this.height = 350,
    this.minWidth,
    this.onBarTapped,
    this.barWidth = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalWidth = (data.bars.length * barWidth).toDouble();
    double canvasWidth = minWidth != null ? (totalWidth > minWidth! ? totalWidth : minWidth!) : totalWidth;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      child: Container(
        height: height,
        width: canvasWidth,
        color: data.backgroundColor,
        child: CustomPaint(
          painter: _StackedBarGraphPainter(
            data,
            xLabelConfiguration: xLabelConfiguration,
            yLabelConfiguration: yLabelConfiguration,
            barWidth: barWidth,
            onBarTapped: onBarTapped,
          ),
        ),
      ),
    );
  }
}

class _StackedBarGraphPainter extends CustomPainter {
  final GraphData data;
  final XLabelConfiguration? xLabelConfiguration;
  final YLabelConfiguration? yLabelConfiguration;
  final double barWidth;
  final Function(GraphBar)? onBarTapped;

  _StackedBarGraphPainter(
    this.data, {
    this.xLabelConfiguration,
    this.yLabelConfiguration,
    required this.barWidth,
    this.onBarTapped,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final textPainter = TextPainter(
      textAlign: TextAlign.right, // Right align the Y-axis labels
      textDirection: TextDirection.ltr
    );

    double maxY = yLabelConfiguration?.maxY ?? data.bars.expand((bar) => bar.sections).map((s) => s.value).reduce((a, b) => a + b);
    double minY = yLabelConfiguration?.minY ?? 0;

    double yScale = size.height / (maxY - minY);
    double xScale = size.width / data.bars.length;

    // Draw Bars
    for (int i = 0; i < data.bars.length; i++) {
      double barX = i * barWidth;
      double startY = size.height;

      for (var section in data.bars[i].sections) {
        double barHeight = section.value * yScale;

        // Draw the outline first with opacity and stroke
        paint.color = Color.fromARGB(255, 37, 22, 58).withOpacity(0.5);
        paint.strokeWidth = 3.0;
        paint.style = PaintingStyle.stroke;
        canvas.drawRect(Rect.fromLTWH(barX, startY - barHeight, barWidth, barHeight), paint);

        // Fill the bar section with the specified color
        paint.style = PaintingStyle.fill;
        paint.color = section.color;
        canvas.drawRect(Rect.fromLTWH(barX, startY - barHeight, barWidth, barHeight), paint);

        startY -= barHeight;
      }

      // Draw X labels
      if (xLabelConfiguration != null) {
        textPainter.text = TextSpan(
          text: getFormattedDate(data.bars[i].date),
          style: xLabelConfiguration?.labelStyle ?? TextStyle(color: Colors.black),
        );
        textPainter.layout(minWidth: 0, maxWidth: barWidth);
        textPainter.paint(canvas, Offset(barX + (barWidth - textPainter.width) / 2, size.height));
      }
    }

    // Draw Y labels and Y-axis lines
    if (yLabelConfiguration != null) {
      for (int i = 0; i <= yLabelConfiguration!.labelCount; i++) {
        double yValue = minY + i * ((maxY - minY) / yLabelConfiguration!.labelCount);
        double yPosition = size.height - (yValue * yScale);

        textPainter.text = TextSpan(
          text: "${yLabelConfiguration?.labelPrefix ?? ""}${yValue.toStringAsFixed(yLabelConfiguration!.decimalPlaces)}${yLabelConfiguration?.labelSuffix ?? ""}",
          style: yLabelConfiguration?.labelStyle ?? TextStyle(color: Colors.black),
        );
        textPainter.layout(minWidth: 0, maxWidth: size.width);
        
        // Position the label on the left side of the Y-axis
        double labelX = -textPainter.width - 4; // A bit of padding to the left
        
        textPainter.paint(canvas, Offset(labelX, yPosition - textPainter.height / 2));

        // Draw the Y-axis horizontal line across the graph
        paint.color = Color.fromARGB(255, 89, 110, 165).withOpacity(0.5);
        paint.strokeWidth = 1.0; // Thinner line for the grid
        paint.style = PaintingStyle.stroke;
        canvas.drawLine(Offset(0, yPosition), Offset(size.width, yPosition), paint);
      }
    }
  }
  // void paint(Canvas canvas, Size size) {
  //   final paint = Paint();
  //   final textPainter = TextPainter(textAlign: TextAlign.center, textDirection: TextDirection.ltr);

  //   double maxY = yLabelConfiguration?.maxY ?? data.bars.expand((bar) => bar.sections).map((s) => s.value).reduce((a, b) => a + b);
  //   double minY = yLabelConfiguration?.minY ?? 0;

  //   double yScale = size.height / (maxY - minY);
  //   double xScale = size.width / data.bars.length;

  //   // Draw Bars
  //   for (int i = 0; i < data.bars.length; i++) {
  //     double barX = i * barWidth;
  //     double startY = size.height;
      
  //     for (var section in data.bars[i].sections) {
  //       double barHeight = section.value * yScale;
        
  //       //paint.color = Color.lerp(section.color, Color.fromRGBO(0, 0, 0, 1), 0.5)!; // Set the fill color with opacity
  //       paint.color = Color.fromARGB(255, 37, 22, 58).withOpacity(0.5); // vertical bar line color
  //       paint.strokeWidth = 3.0;
  //       paint.style = PaintingStyle.stroke; // Add this line to set the painting style to stroke
  //       canvas.drawRect(Rect.fromLTWH(barX, startY - barHeight, barWidth, barHeight), paint);
       
  //       paint.style = PaintingStyle.fill; // Reset the painting style to fill
  //       paint.color = section.color; // Set the outline color
  //       canvas.drawRect(Rect.fromLTWH(barX, startY - barHeight, barWidth, barHeight), paint);
  //       startY -= barHeight;
  //     }

  //     // Draw X labels
  //     if (xLabelConfiguration != null) {
  //       textPainter.text = TextSpan(
  //         text: getFormattedDate(data.bars[i].date),
  //         style: xLabelConfiguration?.labelStyle ?? TextStyle(color: Colors.black),
  //       );
  //       textPainter.layout(minWidth: 0, maxWidth: barWidth);
  //       textPainter.paint(canvas, Offset(barX + (barWidth - textPainter.width) / 2, size.height));
  //     }
  //   }

  //   // Draw Y labels
  //   if (yLabelConfiguration != null) {
  //     for (int i = 0; i <= yLabelConfiguration!.labelCount; i++) {
  //       double yValue = minY + i * ((maxY - minY) / yLabelConfiguration!.labelCount);
  //       double yPosition = size.height - (yValue * yScale);

  //       textPainter.text = TextSpan(
  //         text: "${yLabelConfiguration?.labelPrefix ?? ""}${yValue.toStringAsFixed(yLabelConfiguration!.decimalPlaces)}${yLabelConfiguration?.labelSuffix ?? ""}",
  //         style: yLabelConfiguration?.labelStyle ?? TextStyle(color: Colors.black),
  //       );
  //       textPainter.layout(minWidth: 0, maxWidth: size.width);
  //       textPainter.paint(canvas, Offset(0, yPosition - textPainter.height / 2));

  //       canvas.drawLine(Offset(0, yPosition), Offset(size.width, yPosition), paint..color = Color.fromARGB(255, 89, 110, 165).withOpacity(0.5));
  //     }
  //   }
  // }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  String getFormattedDate(DateTime date) {
    //format date ourselves into a string (e.g. 'dd/mm/yyyy') instead of using DateFormat
    
    //ensure day value=1 displays 01
    //ensure month value=1 displays 01
    return "${(date.day<10)?'0${date.day}':'${date.day}'}/${(date.month<10)?'0${date.month}':'${date.month}'}\n${date.year}";
     
  }
}

//MMM dd
    // switch(date.month)
    // {
    //   case 1:
    //     return 'Jan ${date.day}';
    //   case 2:
    //     return 'Feb ${date.day}';
    //   case 3:
    //     return 'Mar ${date.day}';
    //   case 4:
    //     return 'Apr ${date.day}';
    //   case 5:
    //     return 'May ${date.day}';
    //   case 6:
    //     return 'Jun ${date.day}';
    //   case 7:
    //     return 'Jul ${date.day}';
    //   case 8:
    //     return 'Aug ${date.day}';
    //   case 9:
    //     return 'Sep ${date.day}';
    //   case 10:
    //     return 'Oct ${date.day}';
    //   case 11:
    //     return 'Nov ${date.day}';
    //   case 12:
    //     return 'Dec ${date.day}';
    //   default:
    //     return '';
    // }
