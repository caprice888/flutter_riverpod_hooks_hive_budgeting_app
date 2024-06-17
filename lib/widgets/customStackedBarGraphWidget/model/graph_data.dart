import 'package:flutter/material.dart';

import 'graph_bar.dart';

class GraphData {
  final String name;
  final List<GraphBar> bars;
  final Color backgroundColor;

  GraphData(this.name, this.bars, this.backgroundColor);
}