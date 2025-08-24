import 'package:budgeting_app_v2/models/transaction_category_model.dart';
import 'package:hive/hive.dart';

import 'transaction_model.dart';

part 'user_data_model.g.dart'; // Generated file for the Hive type adapters

@HiveType(typeId: 1)
class UserDataModel {
  @HiveField(0)
  final List<TransactionModel> transactions;
  @HiveField(1)
  final DateTime dateJoined;
  @HiveField(2)
  final String username;
  @HiveField(3)
  final List<TransactionCategoryModel> savedTransactionCategories;

  UserDataModel({
    required this.transactions,
    required this.dateJoined,
    required this.username,
    required this.savedTransactionCategories,
  });

  UserDataModel copyWith({
    List<TransactionModel>? transactions,
    DateTime? dateJoined,
    String? username,
    List<TransactionCategoryModel>? savedTransactionCategories,
  }) {
    return UserDataModel(
      transactions: transactions ?? this.transactions,
      dateJoined: dateJoined ?? this.dateJoined,
      username: username ?? this.username,
      savedTransactionCategories: savedTransactionCategories ?? this.savedTransactionCategories,
    );
  }

  //sort this objects transactions by date
  List<TransactionModel> get sortedTransactions {
    List<TransactionModel> sortedTransactions = transactions;
    sortedTransactions.sort((a, b) => a.date.compareTo(b.date));
    return sortedTransactions;
  } 
}