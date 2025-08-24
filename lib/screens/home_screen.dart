import 'package:budgeting_app_v2/models/transaction_category_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
import '../providers/user_data_notifier.dart'; //userDataProvider

class HomeScreen extends HookConsumerWidget {
  //form key
  final _formKey = GlobalKey<FormState>();
  final _listviewKey = GlobalKey<AnimatedListState>();


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    
    //delete multiple transactions selection set
    final selectedTransactionsToDelete = useState(<int>{});

    //form variables
    final selectedCategoryTag = useState("");

    //form data controllers
    final nameController = useTextEditingController();
    final amountController = useTextEditingController();
    final newCategoryController = useTextEditingController(); // Controller for new category input

    //delete multiple transactions methods
    void onLongPressTransaction(int index) {   
      // Create a new set to trigger a rebuild
      final newSelection = Set<int>.from(selectedTransactionsToDelete.value);
      if (newSelection.contains(index)) {
        newSelection.remove(index);
      } else {
        newSelection.add(index);
      }
      selectedTransactionsToDelete.value = newSelection; // This assignment triggers the rebuild
    }

    void onTapTransaction(int index) {
      //if in delete selection mode
      if (selectedTransactionsToDelete.value.isNotEmpty) {
        onLongPressTransaction(index);
      }
    }

    void deleteSelectedItems() {
      //delete selected transactions
      List<String> selectedTransactionIds = [];
      for (int index in selectedTransactionsToDelete.value) {
        selectedTransactionIds.add(userData.transactions[index].id);
      }

      ref.read(userDataProvider.notifier).removeTransactions(selectedTransactionIds);
      selectedTransactionsToDelete.value = {};
    }

    // Select Categories Dialog
    void showCustomDropdown(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Categories'),
            content: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // Row for adding new category
                      Divider(),
                      TextField(
                        controller: newCategoryController,
                        decoration: InputDecoration(
                          labelText: 'Add New Category',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              final newCategory = newCategoryController.text.trim();
                              if (newCategory.isNotEmpty) { //!userData.savedTransactionCategories.contains(newCategory)) {
                                bool exists = false;
                                for(TransactionCategoryModel category in userData.savedTransactionCategories)
                                {
                                  if(category.name == newCategory)
                                  {
                                    exists = true;
                                    break;
                                  }
                                }

                                if(!exists)
                                {
                                  // Update the category tags list in the provider with new category with random color
                                  userData.savedTransactionCategories.add(TransactionCategoryModel(name: newCategory, colour: 0xFF000000 + (DateTime.now().microsecondsSinceEpoch % 0xFFFFFF)));
                                  selectedCategoryTag.value = newCategory;
                                  newCategoryController.clear();
                                  setState(() {}); // To update the UI inside the dialog
                                }
                         
                              }
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 10),                  
                      // Display existing categories with checkboxes
                      //only allow one category to be selected
                      ...userData.savedTransactionCategories.map((TransactionCategoryModel category) {
                        return CheckboxListTile(
                          title: Text(category.name),
                          value: selectedCategoryTag.value == category.name,
                          onChanged: (bool? checked) {
                            if (checked == true) {
                              selectedCategoryTag.value = category.name;
                            }
                            else {
                              selectedCategoryTag.value = "";
                            }
                            setState(() {}); // To update the UI inside the dialog
                          },
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Done'),
              ),
            ],
          );
        },
      );
    }

    return 
    Scaffold(
      appBar: selectedTransactionsToDelete.value.isNotEmpty 
        ? AppBar(
            title: Text('Delete Transactions'),
            actions: selectedTransactionsToDelete.value.isNotEmpty
                ? [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: deleteSelectedItems,
                    )
                  ]
                : [],
          )
        : null,
      body: SafeArea(
        child: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logoDark.jpg'),
                fit: BoxFit.cover,
              ),
            ),  
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  
                  //title
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Budgeting App', 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 42, 
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),]
                      ),),
                  ),
                  
                  
                  //Add Transaction Card
                  selectedTransactionsToDelete.value.isEmpty
                  ? Card(
                    //card background colour
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Form(
                        key: _formKey,
                        child: Column(                          
                          children: [
                            //card title
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text('Add Transaction', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    child: TextField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        labelText: 'Transaction Name',
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    child: TextField(
                                      controller: amountController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Amount',
                                        prefixText: '\$ ',
                                        prefixStyle: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            //text widget
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('Transaction Type', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                                ),
                                
                                // Display a button that shows the custom dropdown when pressed
                                ElevatedButton(
                                  onPressed: () => showCustomDropdown(context),
                                  child: Text(
                                    selectedCategoryTag.value == null || selectedCategoryTag.value.isEmpty 
                                      ? 'Select Category Tag'
                                      : selectedCategoryTag.value,                                    
                                  ),
                                ),
                              ],
                            ),
                            
                                                
                            //submit button
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // if (_formKey.currentState!.validate()) {
                                  //   //save to hive
                                  //   writeData(_name, _amount, _type);   
                                  // }
                                  //print("DEBUG: $_name, $_amount, $_type");
                                  //writeData(_name, _amount, _type);
                                  ref.read(userDataProvider.notifier).addTransaction(nameController.text, double.parse(amountController.text), TransactionCategoryModel(name: selectedCategoryTag.value, colour: 0xFF000000 + (DateTime.now().microsecondsSinceEpoch % 0xFFFFFF) ) );
                                  nameController.clear();
                                  amountController.clear();
                                  selectedCategoryTag.value = "";
                                },
                                child: const Text('Submit'),
                              ),
                            ),
                          ],
                          
                        ),
                      ),
                    ),
                  )
                  : Container(),
                      
                      
                  //display transactions
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      key: _listviewKey,
                      itemCount: userData.sortedTransactions.length,
                      itemBuilder: (context, index) {
                        
                        int itemCount = userData.sortedTransactions.length;
                        int reversedIndex = itemCount - 1 - index;
                        bool isSelectedForDelete = selectedTransactionsToDelete.value.contains(reversedIndex);
                        return GestureDetector(
                          onLongPress: (){onLongPressTransaction(reversedIndex);},
                          onTap: (){
                            if(kIsWeb)
                            {
                              onLongPressTransaction(reversedIndex);
                            }
                            else
                            {
                              onTapTransaction(reversedIndex);
                            } 
                          },
                          child: Card(
                            color: isSelectedForDelete ? const Color.fromARGB(255, 244, 184, 184) : null,
                            child: ListTile(
                              leading: isSelectedForDelete ? Icon(Icons.check_box) : null,
                              title: RichText(
                                text: TextSpan(
                                  text: '${DateFormat('dd-MM-yyyy - kk:mm').format(userData.sortedTransactions[reversedIndex].date)}', // Default text style
                                  style: TextStyle(color: Colors.black, fontSize: 18, fontStyle: FontStyle.italic,),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '\n${userData.sortedTransactions[reversedIndex].title}',
                                      style: TextStyle(fontStyle: FontStyle.normal, fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Text("\$${userData.sortedTransactions[reversedIndex].amount.toStringAsFixed(2)}", style: TextStyle(color: Colors.red),),
                              trailing: Text(userData.sortedTransactions[reversedIndex].category.name,),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
      floatingActionButton: selectedTransactionsToDelete.value.isNotEmpty
            ? FloatingActionButton(
                onPressed: deleteSelectedItems,
                child: Icon(Icons.delete, color: const Color.fromARGB(255, 244, 184, 184),),
                backgroundColor: Color.fromARGB(255, 222, 18, 3),
              )
            : null,
    );
  }
}


