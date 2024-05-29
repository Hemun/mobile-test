import 'package:flutter/material.dart';
import 'package:last_exam/model/product_model.dart';
import 'package:last_exam/model/cart_model.dart';

// ignore: camel_case_types
class Global_provider extends ChangeNotifier {
  List<ProductModel> products = [];
  List<ProductModel> favoriteProducts = [];
  List<ProductModel> cartItems = [];
  int currentIdx = 0;

  void setProducts(List<ProductModel> data) {
    products = data;
    notifyListeners();
  }

  void addCartItems(ProductModel item) {
    if (cartItems.contains(item)) {
      cartItems.remove(item);
    } else {
      cartItems.add(item);
    }
    notifyListeners();
  }

  void changeCurrentIdx(int idx) {
    currentIdx = idx;
    notifyListeners();
  }

  void toggleFavoriteStatus(ProductModel product) {
    if (product.isFavorite) {
      favoriteProducts.remove(product);
    } else {
      favoriteProducts.add(product);
    }
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }

  void setCartItems(List<ProductModel> ls) {
    cartItems = ls;
    notifyListeners();
  }

  ProductModel getProductById(int id) {
    // Find the product with the specified ID
    Iterable<ProductModel> filteredProducts =
        products.where((product) => product.id == id);
    if (filteredProducts.isNotEmpty) {
      return filteredProducts.first; // Return the first product found
    } else {
      return ProductModel(); // Return a default ProductModel if no product is found
    }
  }
}
