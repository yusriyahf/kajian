import 'package:flutter/material.dart';
import 'package:kajian/detailKajian.dart';
import 'package:kajian/signup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for managing input values
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when not needed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false, // Prevent offset when keyboard appears
      body: SingleChildScrollView(
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
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Masukkan Email',
                hintStyle: TextStyle(
                  fontWeight:
                      FontWeight.normal, // Mengatur agar teks tidak bold
                  color: Colors.grey, // Warna teks placeholder
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              autocorrect: false, // Nonaktifkan autocorrect
              enableSuggestions: false,
            ),
            SizedBox(height: 20),
            Text('Kata Sandi'),
            SizedBox(height: 5),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Masukkan Kata Sandi',
                hintStyle: TextStyle(
                  fontWeight:
                      FontWeight.normal, // Mengatur agar teks tidak bold
                  color: Colors.grey, // Warna teks placeholder
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              obscureText: true,
            ),
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KajianDetailAdminPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF98614A),
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
                        style: TextStyle(color: Color(0xFF98614A)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
