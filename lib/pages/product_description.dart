import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sepatu_client/controller/cart.controller.dart';
import 'package:sepatu_client/controller/purchase_controller.dart';
import 'package:sepatu_client/model/user/product/product.dart';
import 'package:sepatu_client/pages/cart_tab.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({super.key});

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  String _selectedSize = '39'; // Default selected size
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    Product product = Get.arguments['data'];
    return GetBuilder<PurchaseController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Product',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.image ?? '',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                product.name ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                product.description ?? '',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              Text(
                'Rp: ${product.price ?? ''}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Horizontal Size Selection using ChoiceChip
              Text(
                'Pilih Ukuran:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10.0,
                children: ['39', '40', '41', '42', '43'].map((String size) {
                  return ChoiceChip(
                    label: Text(size),
                    selected: _selectedSize == size,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedSize = size;
                      });
                    },
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: _selectedSize == size ? Colors.white : Colors
                          .black,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: ctrl.addressController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Masukan Alamat Rumah anda',
                ),
              ),
              const SizedBox(height: 20),
              // Row for Beli and Favorite button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text(
                        'Beli',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () async {
                        ctrl.submitOrder(price:
                        product.price ?? 0,
                          item: product.name ?? '',
                          description: product.description ?? '',
                        );

                              // Action when Beli button is pressed
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      backgroundColor: Colors.redAccent,
                    ),
                    child: Icon(Icons.add_shopping_cart, color: Colors.white),
                    onPressed: () {
                      cartController.addToCart(product);
                      Get.snackbar('Berhasil', 'Produk ditambahkan ke keranjang', colorText: Colors.green );

                      },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
