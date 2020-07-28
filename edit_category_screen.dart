import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/category.dart';
import 'package:storeapp/models/category_manager.dart';

import 'category_images_form.dart';

class EditCategoryScreen extends StatelessWidget {
  final CategoryModel categoryModel;
  final bool editing;

  EditCategoryScreen(CategoryModel p) :
      editing = p != null,
        categoryModel = p != null ? p.clone() : CategoryModel();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: categoryModel,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
              editing ? 'Edit Category' : 'Add Category'
          ),
          centerTitle: true,
          actions: <Widget>[
            if(editing)
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: (){
                    context.read<CategoryManager>().delete(categoryModel);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
              )
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              CategoryImagesForm(categoryModel),
              Padding(
                  padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: categoryModel.name,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                      ),
                      validator: (name)=> name.length < 3 ?
                      'Title must be at least 3' : null,
                      onSaved: (title)=> categoryModel.name = title,
                    ),
                    const SizedBox(height: 20,),
                    Consumer<CategoryModel>(
                      builder: (_, category,__) {
                        return SizedBox(
                          height: 45,
                          child: RaisedButton(
                            onPressed: !category.loading ? ()async{
                              if(formKey.currentState.validate()){
                                formKey.currentState.save();
                                await category.save();
                                //code for updating product after editing
                                context.read<CategoryManager>().update(category);

                                Navigator.of(context).pop();
                              }
                            }: null,
                            textColor: Colors.white,
                            color: primaryColor,
                            disabledColor: primaryColor.withAlpha(100),
                            child: category.loading ?
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ):
                            const Text(
                                'Save',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      }
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
