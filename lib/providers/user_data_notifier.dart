

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/transaction_category_model.dart';
import '../models/transaction_model.dart';
import '../models/user_data_model.dart';
import '../services/user_data_service.dart';

class UserDataNotifier extends StateNotifier<UserDataModel> {
  final UserDataService _service = UserDataService();

  UserDataNotifier() : super(UserDataModel(transactions: [], dateJoined: DateTime.now(), username: '', savedTransactionCategories: [ TransactionCategoryModel(name: 'Bills', colour: 0xFFE57373), TransactionCategoryModel(name: 'Groceries', colour: 0xFF81D4FA), TransactionCategoryModel(name: 'Socializing', colour: 0xFFAED581), TransactionCategoryModel(name: 'Take Out Food', colour: 0xFF9575CD), TransactionCategoryModel(name: 'Coffee', colour: 0xFFFFD54F), TransactionCategoryModel(name: 'Shopping', colour: 0xFFFFB74D) ])) {
    _loadUserData();
  }

  void _loadUserData() async {
    final loadedUserData = await _service.getUserData();
    if (loadedUserData != null) {
      state = loadedUserData;
    }
  }

  @override
  set state(UserDataModel value) {
    super.state = value;
    _service.saveUserData(value);
  }

  void updateUsername(String newUsername) {
    state = state.copyWith(username: newUsername);
  }

  void addTransaction(String title, double amount, TransactionCategoryModel category) {
    final newTransaction = TransactionModel(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      category: category,
      date: DateTime.now(),
    );
    state = state.copyWith(transactions: [...state.transactions, newTransaction]);
  }

  void addTransactionWithCustomDate(String title, double amount, TransactionCategoryModel category, DateTime date) {
    final newTransaction = TransactionModel(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      category: category,
      date: date,
    );
    state = state.copyWith(transactions: [...state.transactions, newTransaction]);
  }

  void removeTransaction(String id) {
    state = state.copyWith(
      transactions: state.transactions.where((tx) => tx.id != id).toList(),
    );
  }

  void removeTransactions(List<String> ids) {
    state = state.copyWith(
      transactions: state.transactions.where((tx) => !ids.contains(tx.id)).toList(),
    );
  }

  void updateTransaction(String id, String title, double amount, TransactionCategoryModel category) {
    final updatedTransaction = TransactionModel(
      id: id,
      title: title,
      amount: amount,
      category: category,
      date: DateTime.now(),
    );
    state = state.copyWith(
      transactions: state.transactions.map((tx) => tx.id == id ? updatedTransaction : tx).toList(),
    );
  }

  void addSavedCategoryTag(TransactionCategoryModel category) {
    state = state.copyWith(savedTransactionCategories: [...state.savedTransactionCategories, category]);
  }

  void removeSavedCategoryTag(TransactionCategoryModel category) {
    state = state.copyWith(savedTransactionCategories: state.savedTransactionCategories.where((c) => c != category).toList());
  }

  //delete user data
  void deleteUserData() {
    state = UserDataModel(transactions: [], dateJoined: DateTime.now(), username: '', savedTransactionCategories: [ TransactionCategoryModel(name: 'Bills', colour: 0xFFE57373), TransactionCategoryModel(name: 'Groceries', colour: 0xFF81D4FA), TransactionCategoryModel(name: 'Socializing', colour: 0xFFAED581), TransactionCategoryModel(name: 'Take Out Food', colour: 0xFF9575CD), TransactionCategoryModel(name: 'Coffee', colour: 0xFFFFD54F), TransactionCategoryModel(name: 'Shopping', colour: 0xFFFFB74D) ] );
  }
}

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserDataModel>((ref) => UserDataNotifier());
