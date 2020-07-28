import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:storeapp/models/comment.dart';
import 'package:storeapp/models/item_color.dart';
import 'package:storeapp/models/item_specification.dart';
import 'package:uuid/uuid.dart';

class Products extends ChangeNotifier{

  //add this to your declared variable
  String category;



  Products({
    //add this to your constructors
    this.category,

  })

  Products.fromDocument(DocumentSnapshot document){
   //add this inside here
    category = document['category'] as String;

  }


  //code for cloning product when editing
  Products clone(){
    return Products(
     // add this inside here
      category: category,

    );
  }

  //code for saving products in firebase

  //add String category inorder to save selected option in dropdown in
  //edit product screen 
  Future<void> save(String category)async{
   //add this inside here
      'category': category,

    };

}