import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_easee/data/categories.dart';
import 'package:shop_easee/models/category.dart';
import 'package:shop_easee/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedUnit;
  var _enteredName = '';
  var _enteredQuantity = 1;
  List<String> units = ['Kg', 'L', 'gm'];
  var _selectedCategory = categories[Categories.dairy]!;

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(
        GroceryItem(
          id: DateTime.now().toString(),
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory,
        ),
      );
    }
  }

  Future<void> uploadDatatoDb() async {
    try {
      await FirebaseFirestore.instance.collection("Added_items").add({
        "title": _enteredName,
        "categories": _selectedCategory.title,
        "quantity": _enteredQuantity,
        "id": DateTime.now().toString(),
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text(
          'Add Grocery Item',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 7, 62, 10),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[300],
        foregroundColor: Colors.green[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Item Name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green[800]!,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a valid item name';
                        }
                        return null;
                      },
                      onSaved: (value) => _enteredName = value!,
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            dropdownColor: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
                            ),
                            value: _selectedCategory,
                            decoration: InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green[800]!,
                                  width: 3.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items:
                                categories.entries.map((entry) {
                                  return DropdownMenuItem(
                                    value: entry.value,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          entry.value.iconPath,
                                          width: 40,
                                          height: 40,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          entry.value.title,
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                              255,
                                              0,
                                              0,
                                              0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green[800]!,
                                  width: 3.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            initialValue: _enteredQuantity.toString(),
                            validator: (value) {
                              if (value == null ||
                                  int.tryParse(value) == null ||
                                  int.parse(value) <= 0) {
                                return 'Enter a valid quantity';
                              }
                              return null;
                            },
                            onSaved:
                                (value) => _enteredQuantity = int.parse(value!),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            dropdownColor: Colors.white,
                            decoration: InputDecoration(
                              label: Text(
                                'Unit',
                                style: TextStyle(color: Colors.black),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green[800]!,
                                  width: 3.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: _selectedUnit,
                            items:
                                units.map((unit) {
                                  return DropdownMenuItem(
                                    value: unit,
                                    child: Text(
                                      unit,
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          185,
                                          0,
                                          0,
                                          0,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedUnit = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _formKey.currentState!.reset();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[200],
                            foregroundColor: Colors.green[900],

                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                          ),
                          child: const Text('Reset'),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _saveItem();
                              await uploadDatatoDb();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[200],
                            foregroundColor: Colors.green[900],

                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                          ),
                          child: const Text('Add Item'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
