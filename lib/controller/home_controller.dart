import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sepatu_client/model/product_category/product_category.dart';

import '../model/user/product/product.dart';

class HomeController extends GetxController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference CategoryCollection;



  List<Product> products = [];
  List<Product> productShowinUI = [];
  List<ProductCategory> productCategories = [];

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    CategoryCollection = firestore.collection('category');
    await fetchCategory();
    await fetchProduct();
    super.onInit();
  }

  fetchProduct() async{
    try {
      QuerySnapshot  productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs.map((doc) =>
          Product.fromJson(doc.data() as Map<String,dynamic>)).toList();
      products.clear();
      products.assignAll(retrievedProducts);
      productShowinUI.assignAll(products);
      Get.snackbar('Succes', 'Produk Berhasil Ditambahkan', colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    }finally{
      update();
    }

  }

  fetchCategory() async{
    try {
      QuerySnapshot  categorySnapshot = await CategoryCollection.get();
      final List<ProductCategory> retrievedCategories = categorySnapshot.docs.map((doc) =>
          ProductCategory.fromJson(doc.data() as Map<String,dynamic>)).toList();
      productCategories.clear();
      productCategories.assignAll(retrievedCategories);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    }finally{
      update();
    }

  }

  filterByCategory(String category) {
    productShowinUI.clear();
    productShowinUI = products.where((product) => product.category == category).toList();
    update();
  }

  filterByBrand(List<String> brands) {
    if (brands.isEmpty) {
      productShowinUI = products;
    } else {
      List<String> lowerCaseBrands = brands.map((brand) => brand.toLowerCase())
          .toList();
      productShowinUI =
          products.where((product) => lowerCaseBrands.contains(product.brand?.toLowerCase() ?? '')).toList();
    }
    update();
  }

  sortByPrice({required bool ascending}) {
    List<Product> sortedProducts  = List<Product>.from(productShowinUI);
    sortedProducts.sort((a,b) => ascending ? a.price!.compareTo(b.price!) : b.price!.compareTo(a.price!));
    productShowinUI = sortedProducts;
    update();
  }
}