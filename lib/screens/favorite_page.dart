import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:last_exam/provider/globalProvider.dart';
import '../model/product_model.dart';
import '../widgets/ProductView.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return const Center(child: Text('Favorite page'));
  // }
  @override
  Widget build(BuildContext context) {
    // Access the Global_provider instance
    final globalProvider = Provider.of<Global_provider>(context);
    // Get the list of all products from the provider
    List<ProductModel> allProducts = globalProvider.products;
    // Filter the list to get only favorite products
    List<ProductModel> favoriteProducts =
        allProducts.where((product) => product.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Products'),
      ),
      body: favoriteProducts.isEmpty
          ? const Center(
              child: Text('No favorite products yet.'),
            )
          : ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                // Build a widget for each favorite product
                return ProductViewShop(favoriteProducts[index]);
              },
            ),
    );
  }
}
