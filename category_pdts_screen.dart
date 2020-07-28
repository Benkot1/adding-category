import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/category.dart';
import 'package:storeapp/models/category_manager.dart';
import 'package:storeapp/models/product_manager.dart';
import 'package:storeapp/screens/products/pdt_list_tile.dart';
import 'package:storeapp/screens/products/search_dialog.dart';

class CategoryProductScreen extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryProductScreen({this.categoryModel});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<CategoryManager>(
            builder: (_, categoryManager,__){
              if (categoryManager.search.isEmpty) {
                return Text(categoryModel.name);
              }  else {
                return LayoutBuilder(
                  builder: (_, constraints){
                    return GestureDetector(
                      onTap: ()async{
                        final search = await showDialog<String>(context: context,
                            builder: (_) => SearchDialog(
                                categoryManager.search
                            ));
                        if (search != null) {
                          categoryManager.search = search;
                        }
                      },
                      child: Container(
                        width: constraints.biggest.width,
                        child: Text(
                          categoryManager.search,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                );
              }
            }
        ),
        actions: <Widget>[
          Consumer<CategoryManager>(
              builder: (_, categoryManager,__) {
                if (categoryManager.search.isEmpty) {
                  return IconButton(
                    icon: Icon(Icons.search, color: Colors.white,),
                    onPressed: () async {
                      final search = await showDialog<String>(context: context,
                          builder: (_) => SearchDialog(
                              categoryManager.search
                          ));
                      if (search != null) {
                        categoryManager.search = search;
                      }
                    },
                  );
                }else{
                  return IconButton(
                    icon: Icon(Icons.close, color: Colors.white,),
                    onPressed: () async {
                      categoryManager.search = '';
                    },
                  );
                }
              }
          ),
        ],
      ),
      body: Consumer<CategoryManager>(
          builder: (_,categoryManager,__){
            final filteredCategory = categoryManager.filteredCategory;
            if (filteredCategory.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/placeholder.png',width: 200,),
                    Text('No product in this category',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                      ),
                    )
                  ],
                ),
              );
            }
            return ListView.builder(
                itemCount: filteredCategory.length,
                itemBuilder: (_,index){
                  return ProductListTile(filteredCategory[index]);
                }
            );
          }
      ),
    );
  }
}
