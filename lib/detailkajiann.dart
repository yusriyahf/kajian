import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kajian/bayar_tiket.dart';
import 'package:kajian/models/kajian.dart';

// void main() {
//   runApp(MyApp());
// }

// class KajianUser extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: KajianDetailPage(),
//     );
//   }
// }

class KajianDetailPage extends StatefulWidget {
  final Kajian? kajian;
  // final Map<String, String> note; // Menerima data catatan

  KajianDetailPage({this.kajian});

  @override
  State<KajianDetailPage> createState() => _KajianDetailPageState();
}

class _KajianDetailPageState extends State<KajianDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
        title: Text(
          'Detail Kajian',
          style: TextStyle(color: Colors.brown),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian gambar dan judul
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/banner.png', // Path gambar lokal
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Kajian Ustadz Hanan Attaki',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            color: Colors.brown),
                        SizedBox(width: 8),
                        Text('Rabu, 19 Des 2024'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time_outlined, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('15:00 - 17:00'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('Masjid Borcelle'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.book_outlined, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('Kajian Akhir Zaman'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person_outlined, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('Ustadz Hanan Attaki'),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Peta Google Maps
                    // Container(
                    //   height: 200,
                    //   child: GoogleMap(
                    //     initialCameraPosition: CameraPosition(
                    //       target: LatLng(
                    //           -6.200000, 106.816666), // Koordinat Jakarta
                    //       zoom: 14,
                    //     ),
                    //     markers: {
                    //       Marker(
                    //         markerId: MarkerId('masjid_borcelle'),
                    //         position: LatLng(-6.200000, 106.816666),
                    //         infoWindow: InfoWindow(title: 'Masjid Borcelle'),
                    //       ),
                    //     },
                    //   ),
                    // ),
                    SizedBox(height: 16),
                    // Button Pesan Tiket
                    Center(
                      child: Container(
                        width: 320,
                        height: 59,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                                0xFF98614A), // Mengganti 'primary' menjadi 'backgroundColor'
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Border radius
                            ),
                          ),
                          onPressed: () {
                            // Aksi ketika button ditekan
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BayarTiket()),
                            );
                          },
                          child: Text(
                            'Pesan Tiket',
                            style: TextStyle(
                              color: Colors.white, // Warna tulisan putih
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: Colors.brown,
      //   unselectedItemColor: Colors.grey,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Beranda',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.calendar_today),
      //       label: 'Jadwal',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.receipt_long),
      //       label: 'Tiket',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notes),
      //       label: 'Catatan',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profil',
      //     ),
      //   ],
      // ),
    ));
  }
}
