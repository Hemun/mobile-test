import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:last_exam/screens/product_detail.dart';
import 'package:last_exam/provider/authProvider.dart';
import '../model/product_model.dart';
import '../screens/signIn_page.dart';

class ProductViewShop extends StatelessWidget {
  final ProductModel data;

  const ProductViewShop(this.data, {super.key});
  // _onTap(BuildContext context ){ Navigator.push(context,MaterialPageRoute(builder: (_)=>Product_detail(data))); }
  void _onTap(BuildContext context) {
    // Check if user is logged in
    bool isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn;

    if (isLoggedIn) {
      // User is logged in, navigate to product detail page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Product_detail(data)),
      );
    } else {
      // User is not logged in, navigate to login page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SignIn()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => _onTap(context),
        child: Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image
              Container(
                height: 150.0, // Adjust the height based on your design
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(data.image!),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              // Product details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title!,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '\$${data.price!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  // Rating stars
                  const Icon(
                    Icons.star,
                    color: Colors.orange,
                  ),
                  Text(
                    '${data.rating?.rate}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const Spacer(),
                  // Favorite button
                  IconButton(
                    icon: Icon(
                      data.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: data.isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      bool isLoggedIn =
                          Provider.of<AuthProvider>(context, listen: false)
                              .isLoggedIn;

                      if (isLoggedIn) {
                        // Toggle favorite status
                        data.isFavorite = !data.isFavorite;
                        // Notify listeners to update UI
                        Provider.of<AuthProvider>(context, listen: false)
                            .notifyListeners();
                      } else {
                        // User is not logged in, navigate to login page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignIn()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ));

    // Row(
    //   children: [
    //     Box(
    //       height: width /3,
    //       width: width,
    //       margin: EdgeInsets.only(right: 10),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(8),
    //         image: DecorationImage(image: NetworkImage(data.image!), fit: BoxFit.fitHeight)
    //       ),
    //     ),
    //      Column(
    //       children: [
    //         Text(data.title==null?"": data.title!),
    //         Text(data.category==null?"": data.category!),
    //         Text('${data.price}'),
    //       ],
    //     )

    //   ],
    // );
  }
}
