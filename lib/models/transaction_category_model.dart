import 'package:hive/hive.dart';

part 'transaction_category_model.g.dart'; // Generated file for the Hive type adapters

@HiveType(typeId: 0)
class TransactionCategoryModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int colour;
  

  TransactionCategoryModel({
    required this.name,
    required this.colour,
  });
}