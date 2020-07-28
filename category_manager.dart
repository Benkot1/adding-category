import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:storeapp/models/category.dart';
import 'package:storeapp/models/products.dart';

class CategoryManager extends ChangeNotifier{

  List<CategoryModel> categories = [];
  List<String> categoriesNames = [];
  String selectedCategory;
  String _search = '';
  String get search => _search;

  CategoryManager(){
    _loadAllCategories();
    loadCategories();
  }

  final Firestore firestore = Firestore.instance;

  List<CategoryModel> allCategories = [];
  List<Products> getProductsByCategory = [];

  set search(String value){
    _search = value;
    notifyListeners();
  }

  List<Products> get filteredCategory{
    final List<Products> filteredPdtCategory = [];
    if (search.isEmpty) {
      filteredPdtCategory.addAll(getProductsByCategory);
    }  else{
      filteredPdtCategory.addAll(
          getProductsByCategory.where(
                  (p) => p.name.toLowerCase().contains(search.toLowerCase()))
      );
    }
    return filteredPdtCategory;
  }


  Future<void> _loadAllCategories() async{
    final QuerySnapshot snapProducts =
        await firestore.collection('categories').where('deleted',isEqualTo: false).getDocuments();

     allCategories = snapProducts.documents.map((doc) =>
     CategoryModel.fromDoc(doc)).toList();

     notifyListeners();
  }


  Future<void> loadCategories()async{
    categories = await getCategories();
    for(final CategoryModel category in categories){
      categoriesNames.add(category.name);
    }
    selectedCategory = categoriesNames[0];
    notifyListeners();
  }

  Future<List<CategoryModel>> getCategories() async =>
      firestore.collection('categories').where('deleted',isEqualTo: false).getDocuments().then((result) {
        for(final DocumentSnapshot category in result.documents){
          categories.add(CategoryModel.fromDoc(category));
        }
        return categories;
      });


  //loading Categories

//    Future<void> loadCategories()async{
//    categories = await categoryService.getCategories();
//    for(final CategoryModel category in categories){
//      categoriesNames.add(category.name);
//    }
//    selectedCategory = categoriesNames[0];
//    notifyListeners();
//  }

  void changeSelectedCategory({String newCategory}){
    selectedCategory = newCategory;
    notifyListeners();
  }

  // ignore: missing_return
  Future<List<Products>> getProductsOfCategory({String category}) async{
    final QuerySnapshot snapProducts =
    await firestore.collection('products')
        .where('deleted',isEqualTo: false)
        .where("category", isEqualTo: category)
        .getDocuments();

    getProductsByCategory = snapProducts.documents.map((doc) =>
        Products.fromDocument(doc)).toList();
    notifyListeners();
  }

  void update(CategoryModel categoryModel){
    allCategories.removeWhere((p) => p.id == categoryModel.id);
    allCategories.add(categoryModel);
    notifyListeners();
  }

  //code for deleting product
  void delete(CategoryModel categoryModel){
    categoryModel.delete();
    allCategories.removeWhere((p) => p.id == categoryModel.id);
    notifyListeners();
  }
}