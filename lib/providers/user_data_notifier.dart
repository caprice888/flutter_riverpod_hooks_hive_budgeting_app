

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/transaction_model.dart';
import '../models/user_data_model.dart';
import '../services/user_data_service.dart';

class UserDataNotifier extends StateNotifier<UserDataModel> {
  final UserDataService _service = UserDataService();

  UserDataNotifier() : super(UserDataModel(transactions: [], dateJoined: DateTime.now(), username: '', savedCategoryTags: ['Food', 'Bill'])) {
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

  void addTransaction(String title, double amount, List<String> categoryTags) {
    final newTransaction = TransactionModel(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      categoryTags: categoryTags,
      date: DateTime.now(),
    );
    state = state.copyWith(transactions: [...state.transactions, newTransaction]);
  }

  void addTransactionWithCustomDate(String title, double amount, List<String> categoryTags, DateTime date) {
    final newTransaction = TransactionModel(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      categoryTags: categoryTags,
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

  void updateTransaction(String id, String title, double amount, List<String> categoryTags) {
    final updatedTransaction = TransactionModel(
      id: id,
      title: title,
      amount: amount,
      categoryTags: categoryTags,
      date: DateTime.now(),
    );
    state = state.copyWith(
      transactions: state.transactions.map((tx) => tx.id == id ? updatedTransaction : tx).toList(),
    );
  }

  void addSavedCategoryTag(String tag) {
    state = state.copyWith(savedCategoryTags: [...state.savedCategoryTags, tag]);
  }

  void removeSavedCategoryTag(String tag) {
    state = state.copyWith(savedCategoryTags: state.savedCategoryTags.where((t) => t != tag).toList());
  }

  //delete user data
  void deleteUserData() {
    state = UserDataModel(transactions: [], dateJoined: DateTime.now(), username: '', savedCategoryTags: ['Food', 'Bill']);
  }
}

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserDataModel>((ref) => UserDataNotifier());
