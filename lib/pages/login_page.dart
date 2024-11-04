import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sepatu_client/controller/register_ctrl.dart';
import 'package:sepatu_client/pages/navbarPage.dart';
import 'package:sepatu_client/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterCtrl>(builder: (ctrl) {
      return Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueAccent[50],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Selamat Datang',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              const SizedBox(height: 20),

              // Dropdown untuk memilih metode login (email/password atau email/nomor telepon)
              DropdownButton<String>(
                value: ctrl.loginType, // Menggunakan variabel loginType dari controller
                items: const [
                  DropdownMenuItem(
                    value: 'emailPassword',
                    child: Text('Login dengan Email & Password'),
                  ),
                  DropdownMenuItem(
                    value: 'emailPhone',
                    child: Text('Login dengan Email & Nomor Telepon'),
                  ),
                ],
                onChanged: (value) {
                  ctrl.loginType = value!;
                  ctrl.update(); // Memperbarui UI
                },
              ),
              const SizedBox(height: 20),

              // Input untuk Email
              TextField(
                controller: ctrl.emailCtrl, // Menggunakan controller emailCtrl
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  prefixIcon: const Icon(Icons.email),
                  labelText: 'Email',
                  hintText: 'Masukan Email',
                ),
              ),
              const SizedBox(height: 20),

              // Jika metode login adalah "emailPassword", tampilkan input untuk password
              if (ctrl.loginType == 'emailPassword') ...[
                TextField(
                  controller: ctrl.passwordCtrl, // Menggunakan controller passwordCtrl
                  obscureText: ctrl.isPasswordHidden, // Kontrol visibilitas password
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    labelText: 'Password',
                    hintText: 'Masukan Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        ctrl.isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        ctrl.isPasswordHidden = !ctrl.isPasswordHidden;
                        ctrl.update(); // Update UI setelah mengubah visibilitas password
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Jika metode login adalah "emailPhone", tampilkan input untuk nomor telepon
              if (ctrl.loginType == 'emailPhone') ...[
                TextField(
                  controller: ctrl.phoneCtrl, // Menggunakan controller phoneCtrl
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    prefixIcon: const Icon(Icons.phone_android),
                    labelText: 'Nomor Telepon',
                    hintText: 'Masukan Nomor Telepon',
                  ),
                ),
                const SizedBox(height: 20),
              ],

              ElevatedButton(
                onPressed: () {
                  // Aksi untuk login sesuai dengan metode yang dipilih
                  if (ctrl.loginType == 'emailPassword') {
                    ctrl.loginWithEmailPassword(); // Metode login dengan email & password
                  } else {
                    ctrl.loginWithEmailPhone(); // Metode login dengan email & nomor telepon
                  }

                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text('Login'),

              ),
              const SizedBox(height: 10),

              // Navigasi ke halaman registrasi
              TextButton(
                onPressed: () {
                  Get.to(const RegisterPage());
                },
                child: const Text('Registrasi Akun Baru'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
