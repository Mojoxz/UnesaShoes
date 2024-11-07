import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:get/get.dart';
import 'package:sepatu_client/controller/cart.controller.dart';
import 'package:sepatu_client/controller/home_controller.dart';
import 'package:sepatu_client/controller/login_controller.dart';
import 'package:sepatu_client/controller/profile.controller.dart';
import 'package:sepatu_client/controller/purchase_controller.dart';
import 'package:sepatu_client/controller/register_ctrl.dart';
import 'package:sepatu_client/firebase_option.dart';
import 'package:sepatu_client/pages/login_page.dart';


void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  Stripe.publishableKey = '';
  Get.put(LoginController());
  Get.put(RegisterCtrl());
  Get.put(HomeController());
  Get.put(PurchaseController());
  Get.put(CartController());
  Get.put(ProfileController());
  // Get.put(TextEditingController());
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Unesa Shoes Shop',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  LoginPage(),
    );
  }
}


