import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:shop_easee/data/categories.dart';
import 'package:shop_easee/models/category.dart';
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
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => const NewItem()));

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
    Widget content = FutureBuilder(
      future: FirebaseFirestore.instance.collection("Added_items").get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        }

        final documents = snapshot.data!.docs;

        if (documents.isEmpty) {
          return const Center(
            child: Text(
              'No items added yet!',
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
          );
        }

        _groceryItems.clear(); // Clear previous items

        for (var doc in documents) {
          _groceryItems.add(
            GroceryItem(
              id: doc["id"],
              name: doc["title"],
              quantity: doc["quantity"],
              category: categories[Categories.values.firstWhere(
  (cat) => cat.name == doc["categories"], // Matches the actual key
  orElse: () => Categories.other,
)]!,

//               category: categories.entries.firstWhere(
//   (entry) => entry.value.title == doc["categories"], // Compare string title
//   orElse: () => MapEntry(Categories.other, categories[Categories.other]!), // Ensure valid MapEntry
// ).value, // Extract Category object
              // category:
              //     categories.entries
              //         .firstWhere(
              //           (entry) =>
              //               entry.value.title == doc["categories"][0]["title"],
              //         )
              //         .value, // Extract the Category object
              // Extract the Category object
            ),
          );
        }

        return ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder:
              (ctx, index) => Dismissible(
                key: ValueKey(_groceryItems[index].id),
                onDismissed: (direction) {
                  FirebaseFirestore.instance
                      .collection("Added_items")
                      .doc(documents[index].id)
                      .delete();
                  setState(() {
                    _groceryItems.removeAt(index);
                  });
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  title: Text(
                    _groceryItems[index].name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
                    "${_groceryItems[index].quantity}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                ),
              ),
        );
      },
    );

    // Widget content = const Center(
    //   child: Text(
    //     'No item added :)',
    //     style: TextStyle(
    //       color: Color.fromARGB(255, 0, 11, 0),
    //       fontSize: 30,
    //     ), // Dark brown color
    //   ),
    // );
    FutureBuilder(
      future: FirebaseFirestore.instance.collection("Added_items").get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 244, 241, 165),
            ),
          );
        }
        if (!snapshot.hasData) {
          return content;
        }

        return Expanded(
          child: ListView.builder(
            itemCount: _groceryItems.length,
            itemBuilder:
                (ctx, index) => Dismissible(
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
                    title: Text(
                      _groceryItems[index].name,
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
                      style: const TextStyle(
                        color: Color.fromARGB(255, 2, 1, 0),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Added items',
          style: TextStyle(
            letterSpacing: 3,
            color: Color.fromARGB(244, 241, 241, 241),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
