import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:last_exam/provider/globalProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:last_exam/provider/authProvider.dart';
import 'package:last_exam/model/product_model.dart';

class BagsPage extends StatelessWidget {
  BagsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    int? id = Provider.of<AuthProvider>(context, listen: false).getUserID();
    print(id);
    return FutureBuilder<Object?>(
      future: Future<Object?>.value(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          fetchData(context);
          return Consumer<Global_provider>(
            builder: (context, provider, child) {
              double total = provider.cartItems
                  .fold(0, (sum, item) => sum + (item.price! * item.count));
              print('cart items ${provider.cartItems}');
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Cart'),
                ),
                body: ListView.builder(
                  itemCount: provider.cartItems.length,
                  itemBuilder: (context, index) {
                    print('$index: ${provider.cartItems[index].count}');
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image.network(
                          provider.cartItems[index].image!,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(provider.cartItems[index].title!),
                        subtitle: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (provider.cartItems[index].count > 1) {
                                  provider.cartItems[index].count--;
                                  Provider.of<Global_provider>(context,
                                          listen: false)
                                      .notifyListeners();
                                }
                              },
                            ),
                            Text(provider.cartItems[index].count.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                provider.cartItems[index].count++;
                                Provider.of<Global_provider>(context,
                                        listen: false)
                                    .notifyListeners();
                              },
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            provider.cartItems[index].isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: provider.cartItems[index].isFavorite
                                ? Colors.red
                                : null,
                          ),
                          onPressed: () {
                            provider.toggleFavoriteStatus(
                                provider.cartItems[index]);
                          },
                        ),
                      ),
                    );
                  },
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement buy all logic
                          // For example, you might want to navigate to a checkout page
                          // or display a confirmation dialog.
                        },
                        child: const Text('Buy All'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<void> fetchData(BuildContext context) async {
    final id = Provider.of<AuthProvider>(context, listen: false).getUserID();
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/carts/user/$id'));
    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);
      if (responseBody.isNotEmpty) {
        var firstCartData = responseBody[0];
        List<dynamic> cartProducts = firstCartData['products'];
        List<ProductModel> products = [];
        // ProductModel productModel = ProductModel();
        for (var productData in cartProducts) {
          int productId =
              productData['productId']; // Extract productId from productData
          // print(Provider.of<Global_provider>(context, listen: false)
          //     .getProductById(productId)
          //     .title);
          ProductModel temp;
          temp = Provider.of<Global_provider>(context, listen: false)
              .getProductById(productId);
          temp.count = productData['quantity'];
          products.add(Provider.of<Global_provider>(context, listen: false)
              .getProductById(productId));
        }
        Provider.of<Global_provider>(context, listen: false)
            .setCartItems(products);
      } else {
        // If the response body is empty, there are no cart items
        Provider.of<Global_provider>(context, listen: false).cartItems = [];
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
