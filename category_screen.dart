import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/common/badge.dart';
import 'package:storeapp/models/cart_manager.dart';
import 'package:storeapp/models/category_manager.dart';
import 'package:storeapp/models/user_manager.dart';
import 'package:storeapp/screens/cart/cart_screen.dart';
import 'package:storeapp/screens/category/category_list_tile.dart';
import 'package:storeapp/screens/category/category_pdts_screen.dart';


class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Category Screen'),
        actions: <Widget>[
          Consumer<CartManager>(
              builder: (context, model, child)=> Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Badge(
                  value: model.items.length.toString(),
                  child: child,),
              ),
              child: IconButton(
                  icon: Icon(Icons.shopping_basket,color: Colors.white,),
                  onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>CartScreen()));
                  }
              )
          ),
        ],
      ),
      body: Consumer<CategoryManager>(
        builder: (_,categoryManager,__){
        return ListView.builder(
          itemCount: categoryManager.allCategories.length,
            itemBuilder: (_,index){
              return GestureDetector(
                onTap: ()async{
                  await categoryManager.getProductsOfCategory(
                      category: categoryManager.categories[index].name
                  );
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>
                        CategoryProductScreen(
                            categoryModel:categoryManager.categories[index]),
                    ),
                  );
                },
                  child: CategoryListTile(
                      categoryManager.allCategories[index],
                  ),
              );
            }
        );
        }
      ),
    );
  }
}
