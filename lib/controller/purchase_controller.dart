import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sepatu_client/controller/register_ctrl.dart';
import 'package:sepatu_client/controller/login_controller.dart';

import 'cart.controller.dart';

class PurchaseController extends GetxController {
  TextEditingController addressController = TextEditingController();

  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';
  String transactionToken = '';

  // Ganti dengan secret key Stripe Anda
  final String secretKey = 'sk_test_51QDlWEHfM8wNsFWfpg2TJ5QIPgxsLTOMs75nBtvVfDFzmxS1QOKF7J6OCEAIHm9briR9XOGs8raOnO55UqOvrzaQ009QRw0Ffc';

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> processPayment() async {
    try {
      final paymentIntent = await _createPaymentIntent(orderPrice);

      if (paymentIntent == null || !paymentIntent.containsKey('client_secret')) {
        throw Exception('Gagal membuat PaymentIntent');
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'UnesaShoes',
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      Get.snackbar('Berhasil', 'Pembayaran selesai!', backgroundColor: Colors.green, );



    } catch (e) {
      print(e);  // Untuk debug detail
      Get.snackbar('Error', e.toString());
    }
  }

  void submitOrder({
    required double price,
    required String item,
    required String description,
  }) {
    orderPrice = price;
    itemName = item;
    orderAddress = addressController.text;

    processPayment();
  }

  Future<Map<String, dynamic>?> _createPaymentIntent(double amount) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (amount * 100).toInt().toString(),
          'currency': 'idr',
          'payment_method_types[]': 'card',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Gagal membuat PaymentIntent: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error saat membuat PaymentIntent: $e');
      Get.snackbar('Error', e.toString());
      return null;
    }
  }

    Future<void> saveTransactionToFirebase() async {
      final transactionData = {
        'address': orderAddress,
        'customer': 'Nama Pelanggan', // Sesuaikan nama pelanggan jika ada
        'dateTime': DateTime.now(),
        'email': 'email@example.com', // Gantikan dengan email yang sesuai
        'item': itemName,
        'price': orderPrice,
        'transactionId': transactionToken,
      };

      await FirebaseFirestore.instance.collection('order').add(transactionData);
    }

  }

