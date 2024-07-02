import 'package:flutter/material.dart';

class XLabelConfiguration {
  final bool showDay;
  final bool showMonth;
  final bool showYear;
  final TextStyle? labelStyle;

  XLabelConfiguration({this.labelStyle, this.showDay = true, this.showMonth = true, this.showYear = true});
}