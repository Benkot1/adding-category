import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class CategoryModel extends ChangeNotifier{
  String id;
  String name;
  List<String>images;
  bool deleted;

  CategoryModel({
    this.id,
    this.name,
    this.images,
    this.deleted = false,
}){
    images = images ?? [];
  }

  List<dynamic> newImages;

  final Firestore firestore = Firestore.instance;
  DocumentReference get firestoreRef => firestore.document('categories/$id');

  final FirebaseStorage storage = FirebaseStorage.instance;
  StorageReference get storageRef => storage.ref().child('categories').child(id);
  
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  CategoryModel.fromDoc(DocumentSnapshot doc){
      id =  doc.documentID;
      name = doc['name'] as String;
      images = List<String>.from(doc.data['images'] as List<dynamic>);
      deleted = (doc.data['deleted'] ?? false) as bool;
  }

  //code for cloning product when editing
  CategoryModel clone(){
    return CategoryModel(
      id: id,
      name: name,
      images: List.from(images),
      deleted: deleted,
    );
  }

  Future<void> save()async{
    loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'deleted': deleted,
    };

    if (id == null) {
      final doc = await firestore.collection('categories').add(data);
      id = doc.documentID;
    }  else{
      await firestoreRef.updateData(data);
    }

    //code for saving and updating Images to firebase storage
    final List<String> updateImages = [];

    for(final newImage in newImages){
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else{
        final StorageUploadTask task = storageRef.child(Uuid().v1())
            .putFile(newImage as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        updateImages.add(url);
      }
    }
    //code for deleting images firebase storage and updating
    for(final image in images){
      if (!newImages.contains(image) && image.contains('firebase')) {
        try{
          final ref = await storage.getReferenceFromUrl(image);
          await ref.delete();
        }catch(e){
          debugPrint('Failed to delete $image');
        }
      }
    }

    await firestoreRef.updateData({'images':updateImages});
    images = updateImages;

    loading = false;
  }


  //code for deleting category
  void delete(){
    firestoreRef.updateData({'deleted': true});
  }

}