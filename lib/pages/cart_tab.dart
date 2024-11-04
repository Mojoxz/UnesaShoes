import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sepatu_client/controller/cart.controller.dart';
import 'package:sepatu_client/controller/purchase_controller.dart';
import 'package:sepatu_client/model/user/product/product.dart';

class CartTab extends StatelessWidget {
  final CartController cartController = Get.put(CartController());
  final PurchaseController purchaseController = Get.put(PurchaseController());
  final NumberFormat currencyFormat = NumberFormat('#,##0', 'id_ID'); // Format untuk IDR

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Text(
              'Keranjang Anda kosong',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          );
        }

        return ListView.builder(
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            final product = cartController.cartItems[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Larger corner radius
              ),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Larger margin
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0), // Add padding inside the Card
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.image ?? '',
                        width: 70, // Increase image size
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16), // Add space between image and text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Increase font size
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${currencyFormat.format(product.price ?? 0)}', // Format product price
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.redAccent),
                          onPressed: () {
                            cartController.removeFromCart(product);
                          },
                        ),
                        Obx(() {
                          final quantity = cartController.productQuantities[product.id] ?? 1;
                          return Text(
                            '$quantity',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Increase font size
                          );
                        }),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.green),
                          onPressed: () {
                            cartController.addToCart(product);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            cartController.removeFromCart(product); // Remove product one by one
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: Rp ${currencyFormat.format(cartController.totalAmount)}', // Format total price
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  purchaseController.submitOrder(
                    price: cartController.totalAmount,
                    item: 'Pesanan Anda',
                    description: 'Pembayaran produk melalui aplikasi',
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  backgroundColor: Colors.white70,
                  elevation: 4,
                ),
                child: Text(
                  'Checkout',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
