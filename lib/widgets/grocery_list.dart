import 'package:flutter/material.dart';

import 'package:shop_easee/models/grocery_item.dart';
import 'package:shop_easee/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
    child: Text(
    'No items added yet.',
    style: TextStyle(color: Color.fromARGB(255, 3, 54, 2), fontSize:25), // Dark brown color
  ),
);
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                    vertical: 10, 
                    horizontal: 16,
                    ),
                  titleTextStyle: TextStyle(
                    color: const Color.fromARGB(255, 4, 21, 4),
                    fontSize: 27,
                    ),
                    title: Text(_groceryItems[index].name,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
           

              ),
        ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                _groceryItems[index].category.iconPath,
                width: 50,
                height: 50,
                ),
            ),
            trailing: Text(
              _groceryItems[index].quantity.toString(),
              style: const TextStyle(color: Color.fromARGB(255, 2, 1, 0),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              ), 
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Added items',
        style: TextStyle(
          letterSpacing : 3 ,
          color: Color.fromARGB(244, 241, 241, 241),
          fontSize: 25, 
          fontWeight: FontWeight.bold,
        ),
        ),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}