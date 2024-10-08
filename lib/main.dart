import 'package:flutter/material.dart';
import 'package:kajian/camera.dart';
import 'package:kajian/detailKajian.dart';
import 'package:kajian/onboard.dart';
import 'package:kajian/profile.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/profile': (context) => ProfilePage(),
        // '/home' : (context) =>
        '/detailkajian': (context) => KajianDetailAdminPage(),
      },
    );
  }
}

class FaceRecognitionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengenalan Wajah'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Background image placeholder
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                ),
                // Face recognition image
                ClipOval(
                  child: Image.asset(
                    'assets/face_placeholder.png', // Replace with your face image asset
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                // Overlay mesh
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.5), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      'Face Mesh',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Your Gender',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Man',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the button press
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Lanjut'),
            ),
          ],
        ),
      ),
    );
  }
}
