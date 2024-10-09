import 'package:flutter/material.dart';
import 'package:kajian/camera.dart';
import 'package:kajian/login.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers for managing input values
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when not needed
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      resizeToAvoidBottomInset: false, // Prevent offset when keyboard appears
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Buat Akun',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF724820)),
            ),
            SizedBox(height: 10),
            Text(
              'Buat akun anda di sini',
              style: TextStyle(fontSize: 16, color: Color(0xFF61677D)),
            ),
            SizedBox(height: 20),
            Text('Nama'),
            SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Masukkan Nama',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            Text('Email'),
            SizedBox(height: 6),
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
            ),
            SizedBox(height: 20),
            Text('Kata Sandi'),
            SizedBox(height: 6),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Kata Sandi',
                hintStyle: TextStyle(
                  fontWeight:
                      FontWeight.normal, // Mengatur agar teks tidak bold
                  color: Colors.grey, // Warna teks placeholder
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            Text('Verifikasi Wajah'),
            SizedBox(height: 6),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  isDismissible: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  context: context,
                  builder: (context) => SizedBox(
                    height: 400,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          // Icon dan Teks Judul
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/avatar.png', // Path ke gambar lokal
                                width: 85, // Sesuaikan lebar
                                height: 85, // Sesuaikan tinggi
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Text left aligned
                                children: [
                                  Text(
                                    'Pengenalan Wajah',
                                    style: TextStyle(
                                      color: Color(0xFF98614A),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Silahkan menghadap kamera',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF61677D),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFFEAE6CD),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              // Padding pada teks dan ikon
                              padding: const EdgeInsets.all(
                                  16.0), // Tambahkan padding di dalam kotak
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .start, // Align to the left
                                children: [
                                  Icon(Icons.wb_sunny_outlined),
                                  SizedBox(width: 10),
                                  Text(
                                    'Pastikan cahaya cukup',
                                    style: TextStyle(color: Color(0xFF61677D)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFFEAE6CD),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              // Padding pada teks dan ikon
                              padding: const EdgeInsets.all(
                                  16.0), // Tambahkan padding di dalam kotak
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .start, // Align to the left
                                children: [
                                  Icon(Icons.remove_red_eye),
                                  SizedBox(width: 10),
                                  Text(
                                    'Pastikan Tidak ada Halangan',
                                    style: TextStyle(color: Color(0xFF61677D)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30),

                          // Tombol Mulai Verifikasi (dengan lebar yang sama)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CameraScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(
                                  0xFF8D6E63), // Warna coklat seperti di gambar
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              minimumSize: Size(double.infinity,
                                  50), // Lebar penuh dengan tinggi minimal
                            ),
                            child: Text(
                              'Mulai Verifikasi Wajah',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: 60, // Lebar kotak
                height:
                    60, // Tinggi kotak (sama dengan lebar agar berbentuk kotak)

                child: Center(
                  child: Icon(
                    Icons.camera_alt, // Ikon kamera
                    size: 30, // Ukuran ikon
                    color: Color(0xFF8D6E63), // Warna coklat
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Handle sign up
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF98614A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Daftar',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to SignUp screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    text: 'Sudah punya akun? ',
                    style: TextStyle(color: Color(0xFF61677D)),
                    children: [
                      TextSpan(
                        text: 'Masuk',
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
