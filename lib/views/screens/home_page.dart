import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/helpers/product_api_helper.dart';
import 'package:provider_app/providers/add_to_cart_provider.dart';

import '../../modals/product.dart';
import '../../providers/theme_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Products"),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).changeTheme();
            },
            icon: const Icon(Icons.light_mode),
          ),
          Align(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("cart_page");
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                      "${Provider.of<AddToCartProvider>(context).totalQuantity}"),
                )
              ],
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: FutureBuilder(
        future: ProductApiHelper.productApiHelper.getProducts(),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text("${snapShot.error}"),
            );
          } else if (snapShot.hasData) {
            List<Product>? data = snapShot.data;
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, i) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Colors.blue.withOpacity(0.4),
                  height: 170,
                  child: Row(
                    children: [
                      Image.network(
                        height: 150,
                        width: 120,
                        fit: BoxFit.cover,
                        "${data[i].image}",
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data[i].title}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${data[i].category}",
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Price : ${data[i].price} \$",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Provider.of<AddToCartProvider>(context,
                                            listen: false)
                                        .addProduct(product: data[i]);
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
