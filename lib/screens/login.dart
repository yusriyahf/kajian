import 'package:flutter/material.dart';
import 'package:kajian/screens/home.dart';
// import 'package:kajian/detailKajian.dart';
import 'package:kajian/screens/admin.dart';
import 'package:kajian/screens/signup.dart';

import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/user.dart';
import 'package:kajian/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _showSuccessDialog(response.data as User); // Pass user data to the dialog
    } else {
      setState(() {
        loading = false;
      });
      _showErrorDialog(
          response.error ?? 'An unknown error occurred.'); // Show error dialog
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    // Directly use the 'role' value from the API response since it's already a string
    // Fallback to '0' if role is null

    // Cek role user dan arahkan ke halaman yang sesuai
    if (user.role == '2') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
    } else if (user.role == '1') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeAdmin()),
          (route) => false);
    } else {
      // Anda bisa menambahkan logika lain jika role tidak teridentifikasi
      _showErrorDialog('Role tidak valid');
    }
  }

  void _showSuccessDialog(User user) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        // Show the success dialog
        return AlertDialog(
          title: Text('Sukses'),
          content: Text('Anda berhasil login.'),
        );
      },
    );

    // Close the dialog after 2 seconds and then redirect
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close the dialog
      _saveAndRedirectToHome(user); // Redirect after dialog is closed
    });
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Gagal Masuk'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF724820)),
          onPressed: () {
            Navigator.pop(
                context); // Fungsi untuk kembali ke halaman sebelumnya
          },
        ),
      ),
      resizeToAvoidBottomInset: false, // Prevent offset when keyboard appears
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Masuk ke \nAkun Anda',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF724820)),
              ),
              SizedBox(height: 10),
              Text(
                'Mari masuk ke akun Anda',
                style: TextStyle(fontSize: 16, color: Color(0xFF61677D)),
              ),
              SizedBox(height: 20),
              Text('Email'),
              SizedBox(height: 5),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
                validator: (val) =>
                    val!.isEmpty ? 'Invalid email address' : null,
                decoration: InputDecoration(
                  hintText: 'Masukkan Email',
                  hintStyle: TextStyle(
                    fontWeight:
                        FontWeight.normal, // Mengatur agar teks tidak bold
                    color: Colors.grey, // Warna teks placeholder
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                autocorrect: false, // Nonaktifkan autocorrect
                enableSuggestions: false,
              ),
              SizedBox(height: 20),
              Text('Kata Sandi'),
              SizedBox(height: 5),
              TextFormField(
                obscureText: true,
                controller: txtPassword,
                validator: (val) =>
                    val!.length < 6 ? 'Required at least 6 chars' : null,
                decoration: InputDecoration(
                  hintText: 'Masukkan Kata Sandi',
                  hintStyle: TextStyle(
                    fontWeight:
                        FontWeight.normal, // Mengatur agar teks tidak bold
                    color: Colors.grey, // Warna teks placeholder
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 40),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              loading = true;

                              _loginUser();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF724820),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Masuk',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to SignUp screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Belum punya akun? ',
                      style: TextStyle(color: Color(0xFF61677D)),
                      children: [
                        TextSpan(
                          text: 'Daftar',
                          style: TextStyle(color: Color(0xFF724820)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
