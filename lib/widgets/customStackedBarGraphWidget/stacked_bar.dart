import 'package:flutter/material.dart';
import 'model/graph_bar.dart';

class StackedBar extends StatelessWidget {
  final GraphBar graphBar;
  final double barWidth;
  final double barHeight;
  final double yScale;
  final Function(GraphBar)? onBarTapped;

  StackedBar({
    required this.graphBar,
    required this.barWidth,
    required this.barHeight,
    required this.yScale,
    this.onBarTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onBarTapped != null) {
          onBarTapped!(graphBar);
        }
      },
      child: CustomPaint(
        size: Size(barWidth, barHeight), // Bar takes up full available height
        painter: _StackedBarPainter(
          graphBar: graphBar,
          barWidth: barWidth,
          yScale: yScale,
        ),
      ),
    );
  }
}

class _StackedBarPainter extends CustomPainter {
  final GraphBar graphBar;
  final double barWidth;
  final double yScale;

  _StackedBarPainter({
    required this.graphBar,
    required this.barWidth,
    required this.yScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    double startY = size.height;

    for (var section in graphBar.sections) {
      double barHeight = section.value * yScale;

      // Draw the outline first with opacity and stroke
      paint.color = Color.fromARGB(255, 37, 22, 58).withOpacity(0.5);
      paint.strokeWidth = 3.0;
      paint.style = PaintingStyle.stroke;
      canvas.drawRect(Rect.fromLTWH(0, startY - barHeight, barWidth, barHeight), paint);

      // Fill the bar section with the specified color
      paint.style = PaintingStyle.fill;
      paint.color = section.color;
      canvas.drawRect(Rect.fromLTWH(0, startY - barHeight, barWidth, barHeight), paint);

      startY -= barHeight;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
