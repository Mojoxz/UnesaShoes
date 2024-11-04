
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';

import 'package:sepatu_client/model/user/user.dart' as UserModel;


class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;
  // final ProfileController profileController = Get.put(ProfileController());

  // Controllers untuk input data
  TextEditingController registerNameCtrl = TextEditingController();
  TextEditingController registerEmailCtrl = TextEditingController();
  TextEditingController registerNumberCtrl = TextEditingController();
  TextEditingController registerTanggalLahictrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController(); // Tambahkan untuk password
  OtpFieldControllerV2 otpController = OtpFieldControllerV2();

  bool isPasswordHidden = true;
  bool otpFieldShown = false;
  String? verificationId;
  String? otpEnter;

  // Menentukan tipe autentikasi (email atau nomor telepon)
  var loginType = 'email'.obs; // Bisa diubah antara 'email' dan 'phone'

  @override
  void onInit() {
    userCollection = firestore.collection('users');
    super.onInit();
  }

  // Logika untuk memilih autentikasi
  authenticate() {
    if (loginType.value == 'email') {
      // Pendaftaran langsung tanpa OTP
      registerWithEmail();
    } else if (loginType.value == 'phone') {
      sendOtp();
    }
  }

  // Mendaftarkan pengguna dengan email dan password
  registerWithEmail() async {
    try {
      final name = registerNameCtrl.text.trim();
      final tanggalLahir = registerTanggalLahictrl.text.trim();
      final email = registerEmailCtrl.text.trim();
      final password = passwordCtrl.text.trim();

      if (name.isEmpty || tanggalLahir.isEmpty || email.isEmpty || password.isEmpty) {
        Get.snackbar('Error', 'Silahkan Isi Semua Kolom', colorText: Colors.redAccent);
        return;
      }

      if (!isValidEmail(email)) {
        Get.snackbar('Error', 'Format email tidak valid', colorText: Colors.redAccent);
        return;
      }

      if (password.length < 6) {
        Get.snackbar('Error', 'Password harus minimal 6 karakter', colorText: Colors.redAccent);
        return;
      }

      // Mendaftarkan pengguna dengan email dan password
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Panggil addUser setelah user berhasil dibuat
      addUser();
    } catch (e) {
      Get.snackbar('Error', e.toString() ?? 'Terjadi kesalahan', colorText: Colors.redAccent);
    }
  }

  // Mengirim OTP (Phone Auth) menggunakan Firebase
  sendOtp() async {
    try {
      if (registerNameCtrl.text.isEmpty ||
          registerTanggalLahictrl.text.isEmpty ||
          registerNumberCtrl.text.isEmpty ) {
        Get.snackbar('Error', 'Silahkan Isi Semua Kolom', colorText: Colors.redAccent);
        return;
      }

      await auth.verifyPhoneNumber(
        phoneNumber: "+62${registerNumberCtrl.text}", // Ganti kode negara sesuai kebutuhan
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          Get.snackbar('Success', 'Verifikasi otomatis berhasil', colorText: Colors.green);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', e.message ?? 'Verifikasi gagal', colorText: Colors.red);
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          otpFieldShown = true;
          update(); // Memperbarui UI untuk menampilkan OTP
          Get.snackbar('Success', 'Kode OTP Terkirim !!', colorText: Colors.green);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.redAccent);
    }
  }

  // Metode untuk memvalidasi format email
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  // Verifikasi OTP yang diinput oleh user
  verifyOtp() async {
    try {
      if (otpEnter != null && verificationId != null) {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId!,
          smsCode: otpEnter!,
        );

        await auth.signInWithCredential(credential);
        Get.snackbar('Success', 'Verifikasi OTP Berhasil', colorText: Colors.green);
        addUser();  // Panggil fungsi untuk menambahkan user setelah OTP berhasil diverifikasi
      } else {
        Get.snackbar('Error', 'OTP atau Verifikasi ID tidak valid', colorText: Colors.redAccent);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.redAccent);
    }
  }

  // Menambahkan user ke Firestore
  addUser() {
    try {
      DocumentReference doc = userCollection.doc();
      UserModel.User user = UserModel.User(
        id: doc.id,
        email: registerEmailCtrl.text.trim(),
        name: registerNameCtrl.text.trim(),
        number: registerNumberCtrl.text.isEmpty
            ? null // Mengabaikan nomor jika tidak diisi (untuk email)
            : int.parse(registerNumberCtrl.text.trim()),
        tanggalLahir: registerTanggalLahictrl.text.trim(),
      );

      final userJson = user.toJson();
      doc.set(userJson);
      Get.snackbar('Success', 'User berhasil Ditambahkan', colorText: Colors.green);

      // Reset form
      registerEmailCtrl.clear();
      registerNumberCtrl.clear();
      registerTanggalLahictrl.clear();
      registerNameCtrl.clear();
      passwordCtrl.clear(); // Kosongkan input password
      // profileController.refreshUserProfile();

    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }


  // Fungsi untuk mengubah tipe autentikasi
  setLoginType(String type) {
    loginType.value = type;
    if (loginType.value == 'email') {
      registerNumberCtrl.clear(); // Kosongkan input nomor telepon saat menggunakan email
    }
    update(); // Memperbarui UI
  }



}
