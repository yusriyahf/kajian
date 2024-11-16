import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kajian/detailKajian.dart';
import 'package:kajian/screens/admin.dart';
import 'package:kajian/screens/home.dart';
import 'package:kajian/screens/jadwalKajian.dart';
import 'package:kajian/notes.dart';
import 'package:kajian/screens/jadwalKajiancopy.dart';
import 'package:kajian/screens/profile.dart';
import 'package:kajian/screens/loading.dart';
import 'package:kajian/screens/tiket.dart';

void main(List<String> args) {
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loading(),
      routes: {
        '/home': (context) => HomePage(),
        '/homeAdmin': (context) => HomeAdmin(),
        '/profile': (context) => ProfilePage(),
        '/jadwal': (context) => JadwalKajianCopy(),
        '/tiket': (context) => Tiket(),
        '/catatan': (context) => Notes(),
        '/detailkajianAdmin': (context) => KajianDetailAdminPage(),
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
