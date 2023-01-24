import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/modals/coupon.dart';
import 'package:provider_app/providers/add_to_cart_provider.dart';
import 'package:provider_app/views/component/snackbar.dart';

import '../../helpers/db_helper.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<AddToCartProvider>(context, listen: false).removeCoupon();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<AddToCartProvider>(context, listen: false).removeCoupon();
  }

  TextEditingController couponController = TextEditingController();
  String coupon = "";
  int? id;

  @override
  Widget build(BuildContext context) {
    var addToCartProvider = Provider.of<AddToCartProvider>(context).products;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: addToCartProvider.length,
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
                          "${addToCartProvider[i].image}",
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${addToCartProvider[i].title}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${addToCartProvider[i].category}",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Price : ${addToCartProvider[i].price} \$",
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      Provider.of<AddToCartProvider>(context,
                                              listen: false)
                                          .removeProduct(
                                              product: addToCartProvider[i]);
                                    },
                                    icon: const Icon(Icons.remove),
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
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: couponController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Enter Coupon Hear",
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      List<Coupon> coupons =
                          await DBHelper.dbHelper.fetchAllRecords();

                      coupons.forEach((e) {
                        if (e.coupon == couponController.text &&
                            e.isUsed == false) {
                          coupon = e.coupon!;
                          id = e.id!;
                        }
                      });

                      if (coupon != "") {
                        Provider.of<AddToCartProvider>(context, listen: false)
                            .applyCoupon();

                        snackBar(
                            context: context,
                            message: "Coupon Apply Successful",
                            color: Colors.green,
                            icon: Icons.verified);
                      } else {
                        snackBar(
                            context: context,
                            message: "Coupon Not Found",
                            color: Colors.red,
                            icon: Icons.dangerous_sharp);
                      }
                    },
                    child: const Text("Apply", style: TextStyle(fontSize: 17)),
                  ),
                ],
              ),
            ),
            (Provider.of<AddToCartProvider>(context).couponApply)
                ? Text(
                    "$coupon is Applied",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  )
                : Container(),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  "Total Quantity",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  "${Provider.of<AddToCartProvider>(context).totalQuantity}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  "Total Price",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  "${(Provider.of<AddToCartProvider>(context).couponApply) ? Provider.of<AddToCartProvider>(context).discountPrice : Provider.of<AddToCartProvider>(context).totalPrice} \$",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                    ),
                    onPressed: () async {
                      if (coupon != "") {
                        await DBHelper.dbHelper.updateRecord(id: id!);
                      }
                      snackBar(
                          context: context,
                          message: "Order Successful",
                          color: Colors.green,
                          icon: Icons.shopping_cart);
                      Provider.of<AddToCartProvider>(context, listen: false)
                          .emptyCart();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/", (route) => false);
                    },
                    child:
                        const Text("Checkout", style: TextStyle(fontSize: 17)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
