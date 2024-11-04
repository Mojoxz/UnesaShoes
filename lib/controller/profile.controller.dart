import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var userEmail = ''.obs;
  var userName = ''.obs;
  var userPhone = ''.obs;
  var userBirthDate = ''.obs;
  var userPhotoUrl = ''.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var isEditing = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        fetchUserProfile();
      } else {
        clearUserProfile();
      }
    });
  }

  // Fetch user profile data
  void fetchUserProfile() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        userEmail.value = currentUser.email ?? 'Email tidak tersedia';
        userName.value = currentUser.displayName ?? 'Nama tidak tersedia';
        userPhotoUrl.value = currentUser.photoURL ?? '';

        // Retrieve phone and birth date from Firestore
        final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists) {
          userPhone.value = userDoc['phone'] ?? 'Nomor telepon tidak tersedia';
          userBirthDate.value = userDoc['birthDate'] ?? 'Tanggal lahir tidak tersedia';
        }
      } else {
        errorMessage.value = 'Pengguna belum login';
      }
    } catch (e) {
      errorMessage.value = 'Gagal mengambil data pengguna: $e';
      Get.snackbar('Error', errorMessage.value, colorText: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // Clear user profile data
  void clearUserProfile() {
    userEmail.value = '';
    userName.value = '';
    userPhone.value = '';
    userBirthDate.value = '';
    userPhotoUrl.value = '';
  }

  // Toggle edit mode
  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }

  // Update user profile
  Future<void> updateUserProfile({String? name, String? phone, String? birthDate}) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updateDisplayName(name);

        // Update Firestore with phone and birth date
        await _firestore.collection('users').doc(currentUser.uid).set({
          'phone': phone,
          'birthDate': birthDate,
        }, SetOptions(merge: true));

        // Update local variables after saving to Firestore
        userName.value = name ?? userName.value;
        userPhone.value = phone ?? userPhone.value;
        userBirthDate.value = birthDate ?? userBirthDate.value;

        Get.snackbar('Berhasil', 'Profil berhasil diperbarui', colorText: Colors.green);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui profil: $e', colorText: Colors.red);
    }
  }

  // Pick a date for birthDate
  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
    );

    if (picked != null) {
      userBirthDate.value = '${picked.day}-${picked.month}-${picked.year}';
    }
  }

  // Pick an image from gallery
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        userPhotoUrl.value = image.path;
        Get.snackbar('Berhasil', 'Foto profil berhasil diperbarui', colorText: Colors.green);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil foto: $e', colorText: Colors.red);
    }
  }

  // Save profile changes
  Future<void> saveProfileChanges(String name, String phone, String birthDate) async {
    if (isEditing.value) {
      await updateUserProfile(name: name, phone: phone, birthDate: birthDate);
      toggleEdit();
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
    clearUserProfile();
    Get.snackbar('Logout', 'Anda telah berhasil logout', colorText: Colors.green);
  }
}
