import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../pages/login_page.dart';
import '../pages/navbarPage.dart';

class RegisterCtrl extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Controllers untuk input data login
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();

  bool isPasswordHidden = true;
  var loginType = 'emailPassword'; // Default login dengan email & password

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
      Get.snackbar('Success', 'Logout berhasil', colorText: Colors.green);
      Get.offAll(() => const LoginPage()); // Redirect ke LoginPage setelah logout
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout', colorText: Colors.red);
    }
  }


  // Login dengan Email & Password
  loginWithEmailPassword() async {
    try {
      if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
        Get.snackbar('Error', 'Email dan Password harus diisi', colorText: Colors.red);
        return;
      }

      // Proses login menggunakan email dan password
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        Get.snackbar('Success', 'Login berhasil', colorText: Colors.green);
        emailCtrl.clear();
        passwordCtrl.clear();
        Get.off(const HomePage());
        // Arahkan ke halaman home atau dashboard setelah login berhasil
        // Get.to(() => HomePage());
      }
    } catch (e) {
      Get.snackbar('Error', 'Email dan Password Salah', colorText: Colors.red);
    }
  }

  // Login dengan Email & Nomor Telepon
  loginWithEmailPhone() async {
    try {
      if (emailCtrl.text.isEmpty || phoneCtrl.text.isEmpty) {
        Get.snackbar('Error', 'Email dan Nomor Telepon harus diisi', colorText: Colors.red);
        return;
      }

      // Validasi nomor telepon
      if (!RegExp(r'^[0-9]+$').hasMatch(phoneCtrl.text)) {
        Get.snackbar('Error', 'Nomor telepon tidak valid', colorText: Colors.red);
        return;
      }

      // Cek apakah pengguna terdaftar dengan email dan nomor telepon di Firestore
      QuerySnapshot result = await firestore.collection('users')
          .where('email', isEqualTo: emailCtrl.text)
          .where('number', isEqualTo: int.parse(phoneCtrl.text))
          .get();

      if (result.docs.isEmpty) {
        Get.snackbar('Error', 'Pengguna dengan email dan nomor telepon ini tidak ditemukan', colorText: Colors.red);
      } else {
        Get.snackbar('Success', 'Login berhasil', colorText: Colors.green);
        emailCtrl.clear();
        phoneCtrl.clear();
        Get.off(const HomePage());
        // Arahkan ke halaman home atau dashboard setelah login berhasil
        // Get.to(() => HomePage());

      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }
}

