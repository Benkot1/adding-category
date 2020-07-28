import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/category_manager.dart';




class EditProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // add this after build widget
    final categoryManager = context.watch<CategoryManager>();


    //add this code to your edit product screen after the ImageForm
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          const Text('Categories'),
          const SizedBox(width: 10,),
          DropdownButton<String>(
            value: categoryManager.selectedCategory,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            elevation: 0,
            onChanged: (value) {
              categoryManager.changeSelectedCategory(
                  newCategory: value.trim());
            },
            items: categoryManager.categoriesNames
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                  value: value, child: Text(value));
            }).toList(),
          ),
        ],
      ),
    );


    //when about to save, add this inside the save
    await products.save(categoryManager.selectedCategory);
  }
}
