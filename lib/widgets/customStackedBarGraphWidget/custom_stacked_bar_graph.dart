import 'package:flutter/material.dart';
import 'model/graph_bar.dart';
import 'model/graph_data.dart';
import 'model/x_label_configuration.dart';
import 'model/y_label_configuration.dart';
import 'stacked_bar.dart';

class CustomStackedBarGraph extends StatefulWidget {
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
  State<CustomStackedBarGraph> createState() => _CustomStackedBarGraphState();
}

class _CustomStackedBarGraphState extends State<CustomStackedBarGraph> {
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    double totalWidth = (widget.data.bars.length * widget.barWidth).toDouble();
    double canvasWidth = widget.minWidth != null ? (totalWidth > widget.minWidth! ? totalWidth : widget.minWidth!) : totalWidth;

    // Calculate the maximum height of the graph
    double maxY = widget.yLabelConfiguration?.maxY ?? widget.data.bars.expand((bar) => bar.sections).map((s) => s.value).reduce((a, b) => a + b);
    double minY = widget.yLabelConfiguration?.minY ?? 0;
    double yScale = widget.height / (maxY - minY);

    // Extra height for X labels below the bars
    double xLabelsHeight = 40; // Adjust based on the label size and padding

    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _baseScaleFactor = _scaleFactor;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scaleFactor = _baseScaleFactor * details.scale;
        });
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: widget.scrollController,
        child: Padding(
          padding: const EdgeInsets.only(left: 55, bottom: 20, top: 20), // Add some padding for labels
          child: SizedBox(
            height: widget.height + xLabelsHeight, // Increase total height to accommodate X labels
            //width: canvasWidth,
            child: Stack(
              children: [
                // Y-axis labels and grid lines
                Positioned.fill(
                  child: CustomPaint(
                    painter: _YAxisPainter(
                      yLabelConfiguration: widget.yLabelConfiguration,
                      yScale: yScale,
                      height: widget.height,
                    ),
                  ),
                ),
                // Bars and X-axis labels
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.data.bars.map((bar) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: widget.height, // Constrain bar height to the height of the graph area
                          child: StackedBar(
                            graphBar: bar,
                            barWidth: widget.barWidth * _scaleFactor,
                            barHeight: widget.height,
                            yScale: yScale,
                            onBarTapped: widget.onBarTapped,
                          ),
                        ),
                        // X label below the bar
                        if (widget.xLabelConfiguration != null)
                          SizedBox(
                            height: xLabelsHeight, // Allocate space for the X label
                            width: widget.barWidth * _scaleFactor,
                            child: Center(
                              child: Text(
                                getFormattedDate(bar.date, widget.xLabelConfiguration!.showDay, widget.xLabelConfiguration!.showMonth, widget.xLabelConfiguration!.showYear),
                                style: widget.xLabelConfiguration?.labelStyle ?? TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getFormattedDate(DateTime date, bool showDay, bool showMonth, bool showYear) {
    String month = "";
    switch (date.month) {
      case 1: month = 'Jan'; break;
      case 2: month = 'Feb'; break;
      case 3: month = 'Mar'; break;
      case 4: month = 'Apr'; break;
      case 5: month = 'May'; break;
      case 6: month = 'Jun'; break;
      case 7: month = 'Jul'; break;
      case 8: month = 'Aug'; break;
      case 9: month = 'Sep'; break;
      case 10: month = 'Oct'; break;
      case 11: month = 'Nov'; break;
      case 12: month = 'Dec'; break;
    }

    if (showDay && showMonth && showYear) return "${(date.day < 10) ? '0${date.day}' : '${date.day}'}\n$month\n${date.year}";
    else if (showDay && showMonth) return "${(date.day < 10) ? '0${date.day}' : '${date.day}'}\n$month";
    else if (showDay && showYear) return "${(date.day < 10) ? '0${date.day}' : '${date.day}'}\n${date.year}";
    else if (showMonth && showYear) return "$month\n${date.year}";
    else if (showDay) return "${(date.day < 10) ? '0${date.day}' : '${date.day}'}";
    else if (showMonth) return "$month";
    else if (showYear) return "${date.year}";
    else return "";
  }
}

class _YAxisPainter extends CustomPainter {
  final YLabelConfiguration? yLabelConfiguration;
  final double yScale;
  final double height;

  _YAxisPainter({
    this.yLabelConfiguration,
    required this.yScale,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final textPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );

    double maxY = yLabelConfiguration?.maxY ?? 1;
    double minY = yLabelConfiguration?.minY ?? 0;

    for (int i = 0; i <= yLabelConfiguration!.labelCount; i++) {
      double yValue = minY + i * ((maxY - minY) / yLabelConfiguration!.labelCount);
      double yPosition = height - (yValue * yScale);

      textPainter.text = TextSpan(
        text: "${yLabelConfiguration?.labelPrefix ?? ""}${yValue.toStringAsFixed(yLabelConfiguration!.decimalPlaces)}${yLabelConfiguration?.labelSuffix ?? ""}",
        style: yLabelConfiguration?.labelStyle ?? TextStyle(color: Colors.black),
      );
      textPainter.layout(minWidth: 0, maxWidth: size.width);

      double labelX = -textPainter.width - 4;

      textPainter.paint(canvas, Offset(labelX, yPosition - textPainter.height / 2));

      paint.color = Color.fromARGB(255, 89, 110, 165).withOpacity(0.5);
      paint.strokeWidth = 1.0;
      paint.style = PaintingStyle.stroke;
      canvas.drawLine(Offset(0, yPosition), Offset(size.width, yPosition), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
