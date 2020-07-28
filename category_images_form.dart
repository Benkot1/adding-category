import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:storeapp/models/category.dart';
import 'package:storeapp/screens/editProduct/image_source_sheet.dart';

class CategoryImagesForm extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryImagesForm(this.categoryModel);

  @override
  Widget build(BuildContext context) {
       return FormField<List<dynamic>>(
      initialValue: List.from(categoryModel.images),
        validator: (images)=> images.isEmpty ?
        'insert at least one image': null,
           onSaved: (images)=> categoryModel.newImages = images,
        builder: (state){
          void onImageSelected(File file){
            state.value.add(file);
            state.didChange(state.value);
            Navigator.pop(context);
          }

        return Column(
          children: <Widget>[
            AspectRatio(
                aspectRatio: 1,
                child: Carousel(
                  images: state.value.map<Widget>((image) {
                    return Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        if (image is String)
                          Image.network(image,fit: BoxFit.cover,)
                         else
                          Image.file(image as File,fit: BoxFit.cover,),
                        Align(
                         alignment: Alignment.topRight,
                         child: IconButton(
                             icon: Icon(Icons.remove),
                             color: Colors.red,
                             onPressed: (){
                               state.value.remove(image);
                               state.didChange(state.value);
                             }
                         ),
                        )
                      ],
                    );
                  }).toList()..add(
                    Material(
                      color: Colors.grey[100],
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo),
                        iconSize: 50,
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          showModalBottomSheet(
                              context: context,
                              builder: (_)=> ImageSourceSheet(
                                onImageSelected: onImageSelected,)
                          );
                        },
                      ),
                    )
                  ),
                  dotSize: 4,
                  dotSpacing: 15,
                  dotBgColor: Colors.transparent,
                  dotColor: Theme.of(context).primaryColor,
                  autoplay: false,
                ),
            ),
            if(state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 16, left: 16),
                child: Text(
                    state.errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12
                  ),
                ),
              )
          ],
        );
      }
    );
  }
}
