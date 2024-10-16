import 'package:flutter/material.dart';
import 'bukti.dart'; // Tambahkan import untuk bukti.dart

void main() {
  runApp(MyApp());
}

class BayarTiket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetailKajianScreen(),
    );
  }
}

class DetailKajianScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Detail Kajian',
          style: TextStyle(color: Colors.brown),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                'assets/img/profil.png', // Gambar profil lokal
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/dana.png', // logo DANA
              height: 60,
            ),
            SizedBox(height: 20),
            Text(
              'Silahkan lakukan pembayaran tiket kajian ke nomer di bawah ini',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '+62 813-3197-4260',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: 30),
            // Garis dengan teks "atau"
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.brown, // Warna garis
                    thickness: 1, // Ketebalan garis
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('atau',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.brown,
                      )),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.brown, // Warna garis
                    thickness: 1, // Ketebalan garis
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Image.asset(
              'assets/images/qrcode.png', // QR Code lokal
              height: 200,
            ),
            SizedBox(height: 30),
            OutlinedButton(
              onPressed: () {
                // Navigasi ke UploadScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side:
                    BorderSide(color: Colors.brown, width: 2), // Border coklat
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Upload Bukti Pembayaran',
                style: TextStyle(
                    fontSize: 16, color: Colors.brown), // Warna teks coklat
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: Colors.brown,
      //   unselectedItemColor: Colors.brown[200],
      //   showUnselectedLabels: true,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Beranda',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.calendar_today),
      //       label: 'Jadwal',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.confirmation_num),
      //       label: 'Tiket',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notes),
      //       label: 'Catatan',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Favorite',
      //     ),
      //   ],
      // ),
    );
  }
}
