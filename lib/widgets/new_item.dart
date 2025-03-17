import 'package:flutter/material.dart';

import 'package:shop_easee/data/categories.dart';
import 'package:shop_easee/models/category.dart';
import 'package:shop_easee/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Transform.rotate(
            angle: 0,
            child: const Text(
              'Grocery items',
              style: TextStyle(
                fontSize: 30,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
                //color: Colors.red,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20,),
              TextFormField(
                style: TextStyle(color: const Color.fromARGB(255, 11, 8, 7)),
                maxLength: 50,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(style: BorderStyle.solid),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: const Color.fromARGB(255, 9, 73, 7), width: 3),
                  ),
                  label: Text(
                    'Item Name',
                    style: TextStyle(
                      // backgroundColor: Colors.,
                      color: Color.fromARGB(255, 12, 12, 12),
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Invalid Input';
                  }
                  return null;
                },
                onSaved: (value) {
                  // if (value == null) {
                  //   return;
                  // }

                  _enteredName = value!;
                },
              ),
              SizedBox(height: 15,), // instead of TextField()
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(
                        color: const Color.fromARGB(255, 6, 6, 6),
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: Colors.black12),
                            
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: BorderSide(color: const Color.fromARGB(255, 9, 73, 7), width: 2
                            // color: const Color.fromARGB(255, 6, 53, 7)
                        )
                      ),
                        label: Text(
                          'Quantity',
                          style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _enteredQuantity.toString(),
                      
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid, positive number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: DropdownButtonFormField(
                      dropdownColor: const Color.fromARGB(255, 207, 237, 211),
                      elevation: 10,
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        
                         focusedBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(10),
                   
                        )

                      ),
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            
                            value: category.value,
                            child: Row(
                              children: [
                                Image.asset(
                                  category.value.iconPath,
                                  width: 45,
                                  height: 45,
                                ),

                                // Container(
                                //   width: 16,
                                //   height: 16,
                                //   color: category.value.color,
                                // ),
                                const SizedBox(width: 6),
                                Text(
                                  category.value.title,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      10,
                                      100,
                                      13,
                                    ),
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 27),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                      style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            backgroundColor: Colors.white, // Button background
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14), 
                                ),
                            elevation: 6, 
                           ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: Colors.black,
                        ),
                    ),
                  ),

                  const SizedBox(width: 15,),
                  ElevatedButton(
                    onPressed: _saveItem,
                    style: 
                        TextButton.styleFrom(
                          
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                            backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Button background
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // Rounded corners
                                ),
                           // shadowColor: Colors.black.withOpacity(0.2),
                            elevation: 5, // Adds depth effect
                           ),
                    child: const Text('Add Item',
                    style: TextStyle(
                      color: Colors.black,
                    ),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
