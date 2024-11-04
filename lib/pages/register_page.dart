import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sepatu_client/controller/login_controller.dart';
import 'package:sepatu_client/pages/login_page.dart';
import 'package:sepatu_client/widgets/otp_txt_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (ctrl) {
      return Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.blueAccent[50],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Buat Akun Baru !!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),

              // Dropdown untuk memilih tipe autentikasi
              DropdownButton<String>(
                value: ctrl.loginType.value,
                items: const [
                  DropdownMenuItem(
                    value: 'email',
                    child: Text('Register dengan Email'),
                  ),
                  DropdownMenuItem(
                    value: 'phone',
                    child: Text('Register dengan Nomor Telepon (OTP)'),
                  ),
                ],
                onChanged: (value) {
                  ctrl.loginType.value = value!; // Set tipe login yang dipilih
                  ctrl.otpFieldShown = false; // Reset tampilan OTP
                  ctrl.update(); // Memperbarui UI sesuai pilihan
                },
              ),
              const SizedBox(height: 10),

              // Input untuk Nama
              TextField(
                controller: ctrl.registerNameCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Nama',
                  hintText: 'Masukan Nama',
                ),
              ),
              const SizedBox(height: 10),

              // Input untuk Email jika loginType adalah 'email'
              if (ctrl.loginType == 'email') ...[
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: ctrl.registerEmailCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    prefixIcon: const Icon(Icons.email),
                    labelText: 'Email',
                    hintText: 'Masukan Email',
                  ),
                ),
                const SizedBox(height: 10),

                // Input untuk Password (jika autentikasi Email)
                TextField(
                  keyboardType: TextInputType.text,
                  controller: ctrl.passwordCtrl,
                  obscureText: ctrl.isPasswordHidden,
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
                        ctrl.update();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Input untuk Nomor Telepon (jika loginType adalah 'phone')
              if (ctrl.loginType == 'phone') ...[
                TextField(
                  keyboardType: TextInputType.phone,
                  controller: ctrl.registerNumberCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    prefixIcon: const Icon(Icons.phone_android),
                    labelText: 'Nomor Telepon',
                    hintText: 'Masukan Nomor Telepon',
                  ),
                ),
                const SizedBox(height: 10),

                // OTP Field hanya jika OTP sudah dikirim
                OtpTextField(
                  otpController: ctrl.otpController,
                  visible: ctrl.otpFieldShown,
                  onComplete: (otp) {
                    ctrl.otpEnter = otp;
                  },
                ),
                const SizedBox(height: 10),
              ],

              // Input untuk Tanggal Lahir
              TextField(
                keyboardType: TextInputType.datetime,
                controller: ctrl.registerTanggalLahictrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                  labelText: 'Tanggal Lahir',
                  hintText: 'Masukan Tanggal Lahir (DD/MM/YYYY)',
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Register
              ElevatedButton(
                onPressed: () {
                  // Validasi sebelum melakukan register
                  if (ctrl.loginType == 'phone' && ctrl.otpFieldShown) {
                    // Verifikasi OTP jika sudah dikirim
                    ctrl.verifyOtp();
                  } else {
                    // Autentikasi dengan metode yang sesuai
                    ctrl.authenticate();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  backgroundColor: Colors.blueAccent,
                ),
                child: Text(ctrl.otpFieldShown && ctrl.loginType == 'phone'
                    ? 'Verifikasi OTP'
                    : 'Register'),
              ),
              const SizedBox(height: 10),

              // Tombol untuk Login
              TextButton(
                onPressed: () {
                  Get.to(const LoginPage());
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
