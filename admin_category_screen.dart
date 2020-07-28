import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/common/custom_drawer/custom_drawer.dart';
import 'package:storeapp/models/category_manager.dart';
import 'package:storeapp/models/user_manager.dart';
import 'package:storeapp/screens/category/admin_category_list_tile.dart';


class AdminCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Category Screen'),
        actions: <Widget>[
          Consumer<UserManager>(
            builder: (_,userManager,__){
              if (userManager.adminEnabled) {
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    Navigator.pushNamed(context, '/edit_category');
                  },
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      drawer: CustomDrawer(),
      body: Consumer<CategoryManager>(
        builder: (_,categoryManager,__){
        return ListView.builder(
          itemCount: categoryManager.allCategories.length,
            itemBuilder: (_,index){
              return AdminCategoryListTile(
                  categoryManager.allCategories[index],
              );
            }
        );
        }
      ),
    );
  }
}
