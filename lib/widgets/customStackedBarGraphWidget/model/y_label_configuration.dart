import 'package:flutter/material.dart';

class YLabelConfiguration {
  final int labelCount;
  final double maxY;
  final double minY;
  final int decimalPlaces;
  final String? labelPrefix;
  final String? labelSuffix;
  final TextStyle? labelStyle;

  YLabelConfiguration({
    this.labelCount = 5,
    required this.maxY,
    required this.minY,
    this.decimalPlaces = 2,
    this.labelPrefix,
    this.labelSuffix,
    this.labelStyle,
  });
}