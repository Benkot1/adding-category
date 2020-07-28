import 'package:flutter/material.dart';
import 'package:storeapp/models/category.dart';
import 'package:storeapp/screens/editCategory/edit_category_screen.dart';


class AdminCategoryListTile extends StatelessWidget {
  final CategoryModel categoryModel;

  const AdminCategoryListTile(this.categoryModel);
  @override
  Widget build(BuildContext context) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder:
                    (context)=>EditCategoryScreen(categoryModel)));
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(4)
           ),
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1,
                    child: FadeInImage(
                        placeholder: const AssetImage('assets/placeholder.png'),
                        image: NetworkImage(categoryModel.images.first),
                    )
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(categoryModel.name,style:
                          const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                        ),
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
