import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/profile.controller.dart';

class ProfileTab extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (profileController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (profileController.errorMessage.isNotEmpty) {
        return Center(child: Text(profileController.errorMessage.value));
      }

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Profil Pengguna',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              // Enlarged Profile Picture with Shadow
              GestureDetector(
                onTap: profileController.isEditing.value ? profileController.pickImage : null,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 70,  // Increased radius for larger profile picture
                        backgroundImage: profileController.userPhotoUrl.value.isNotEmpty
                            ? FileImage(File(profileController.userPhotoUrl.value)) as ImageProvider
                            : AssetImage('assets/default_profile.png'),
                      ),
                    ),
                    if (profileController.isEditing.value)
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Profile Fields in Card format
              _buildProfileField(
                label: 'Nama',
                value: profileController.userName.value,
                isEditable: profileController.isEditing.value,
                onEdit: (newValue) => profileController.updateUserProfile(name: newValue),
              ),
              _buildProfileField(
                label: 'Email',
                value: profileController.userEmail.value,
                isEditable: false,
              ),
              _buildProfileField(
                label: 'Nomor Telepon',
                value: profileController.userPhone.value,
                isEditable: profileController.isEditing.value,
                onEdit: (newValue) => profileController.updateUserProfile(phone: newValue),
              ),
              _buildProfileField(
                label: 'Tanggal Lahir',
                value: profileController.userBirthDate.value,
                isEditable: profileController.isEditing.value,
                isDateField: true,
                onEdit: (newValue) => profileController.updateUserProfile(birthDate: newValue),
                onDateTap: () => profileController.pickDate(context),
              ),
              SizedBox(height: 20),

              // Separate Edit and Save Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: profileController.toggleEdit,
                    icon: Icon(Icons.edit),
                    label: Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0288D1), // Light pastel blue for 'Edit'
                      foregroundColor: Colors.white, // White text and icon color
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: profileController.isEditing.value
                        ? () => profileController.saveProfileChanges(
                      profileController.userName.value,
                      profileController.userPhone.value,
                      profileController.userBirthDate.value,
                    )
                        : null,
                    icon: Icon(Icons.save),
                    label: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF388E3C), // Mint green for 'Save'
                      foregroundColor: Colors.white, // White text and icon color
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      );
    });
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    bool isEditable = false,
    bool isDateField = false,
    ValueChanged<String>? onEdit,
    VoidCallback? onDateTap,
  }) {
    final TextEditingController controller = TextEditingController(text: value);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 6),
              isEditable
                  ? (isDateField
                  ? GestureDetector(
                onTap: onDateTap,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    value.isEmpty ? 'Pilih $label' : value,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              )
                  : TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Masukkan $label baru',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.save, color: Colors.green),
                    onPressed: () {
                      if (onEdit != null) {
                        onEdit(controller.text);
                      }
                    },
                  ),
                ),
              ))
                  : Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
