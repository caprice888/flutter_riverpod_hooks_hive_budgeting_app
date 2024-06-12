import 'package:flutter/material.dart';

class ScrollToNewItemList extends StatefulWidget {
  @override
  _ScrollToNewItemListState createState() => _ScrollToNewItemListState();
}

class _ScrollToNewItemListState extends State<ScrollToNewItemList> {
  final List<String> items = List<String>.generate(20, (index) => 'Item $index');
  final ScrollController _scrollController = ScrollController();
  int _newItemIndex=0;

  void _addItem() {
    // Insert new item at a random position
    setState(() {
      _newItemIndex = items.length; // You can change this index as needed
      items.insert(_newItemIndex, 'New Item ${items.length}');
    });

    // Calculate the position of the newly added item and scroll to it
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _newItemIndex * 56.0, // Adjust the height as per your item height
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _addItem,
          child: Text('Add Item'),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
