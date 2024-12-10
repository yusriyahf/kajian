import 'package:flutter/material.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/user.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/user_service.dart';

// void main() {
//   runApp(MaterialApp(
//     home: EditProfile(),
//   ));
// }

class EditProfile extends StatefulWidget {
  final User user;

  const EditProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameControllerBody =
      TextEditingController();
  final TextEditingController _lastNameControllerBody = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing user data
    _firstNameControllerBody.text = widget.user.first_name ?? '';
    _lastNameControllerBody.text = widget.user.last_name ?? '';
    _emailController.text = widget.user.email ?? '';
  }

  void _updateProfile() async {
    ApiResponse response = await editProfile(_firstNameControllerBody.text,
        _lastNameControllerBody.text, _emailController.text);

    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(
          context,
          User(
            first_name: _firstNameControllerBody.text,
            last_name: _lastNameControllerBody.text,
            email: _emailController.text,
          ));
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false)
          });
    } else {
      // Use the null-aware operator to provide a default error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error ?? "Failed to update profile."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(
                context); // Fungsi untuk kembali ke halaman sebelumnya
          },
        ),
        title: Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Color(0xFF724820),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage('assets/images/profile.png'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        'Nama Depan',
                        _firstNameControllerBody,
                      ),
                      _buildTextField('Nama Belakang', _lastNameControllerBody),
                      _buildTextField('Email', _emailController),
                      SizedBox(height: 16),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 100), // Adjust padding as needed
                          decoration: BoxDecoration(
                            color: Color(
                                0xFF724820), // Background color of the container
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _updateProfile();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .transparent, // Make the button background transparent
                              elevation: 0, // Remove button elevation
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      16), // Add vertical padding inside the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Keep rounded corners for the button
                              ),
                            ),
                            child: const Text(
                              'Simpan',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool verified = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (verified)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    '✔ VERIFIED',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter $label', // Gunakan label untuk hint
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
