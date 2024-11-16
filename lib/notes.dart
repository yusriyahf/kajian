import 'package:flutter/material.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/kajian_service.dart';
import 'addNotes.dart'; // Import file baru
import 'noteDetail.dart'; // Import untuk melihat detail catatan
import 'package:kajian/constant.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/catatan.dart';
import 'package:kajian/services/catatan_service.dart';
import 'package:kajian/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const Notes());
}

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  // List<Map<String, String>> notes = []; // List untuk menyimpan catatan

  List<dynamic> _catatanList = [];
  int userId = 0;
  bool _loading = true;

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('EEEE, d MMM yyyy', 'id_ID')
        .format(date); // Format tanggal
  }

  // get all posts
  Future<void> retrieveCatatan() async {
    userId = await getUserId();
    ApiResponse response = await getCatatan();

    if (response.error == null) {
      setState(() {
        _catatanList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    retrieveCatatan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              'Catatan Saya',
              style: TextStyle(color: Colors.brown),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _catatanList.length, // Jumlah catatan
                  itemBuilder: (context, index) {
                    Catatan catatan = _catatanList[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 16.0), // Menambahkan jarak antar Card
                      child: InkWell(
                        // Menggunakan InkWell untuk mendeteksi klik
                        onTap: () {
                          // Navigasi ke halaman detail catatan saat item di tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoteDetail(catatan: catatan),
                            ),
                          ).then((result) {
                            if (result == true) {
                              retrieveCatatan(); // Refresh data jika perubahan berhasil
                            }
                          });
                        },
                        child: SizedBox(
                          height: 120, // Atur tinggi Card
                          width: double.infinity, // Lebar penuh dari ListView
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: const Color(0xFFEAE6CD),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${catatan.title}',
                                        style: const TextStyle(
                                          color: Color(0xFF724820),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Spacer(), // Spacer untuk mendorong tanggal ke kanan
                                      Text(
                                        catatan.createdAt != null
                                            ? formatDate(catatan.createdAt!)
                                            : 'Tanggal tidak tersedia', // Tanggal catatan
                                        style: const TextStyle(
                                          color: Color(0xFF724820),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    '${catatan.description}',
                                    style: const TextStyle(
                                      color: Color(0xFF724820),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Tunggu hasil dari navigasi ke halaman AddNote
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddNote()),
            );
            // Periksa jika ada hasil (catatan berhasil ditambahkan)
            if (result == true) {
              retrieveCatatan(); // Refresh data
            }
          },
          // onPressed: () async {
          //   final result = await Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => const AddNote()),
          //   );
          //   if (result != null) {
          //     setState(() {
          //       // Menambahkan catatan baru ke dalam list notes
          //       notes.add(result);
          //     });
          //   }
          // },
          backgroundColor: Colors.brown,
          child: const Icon(Icons.add, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(30), // Menjadikan latar belakang bulat
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 3,
          selectedItemColor: Colors.brown,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            // Navigate to the corresponding page based on the selected index
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/home');
                break;
              case 1:
                Navigator.pushNamed(context, '/jadwal');
                break;
              case 2:
                Navigator.pushNamed(context, '/tiket');
                break;
              case 3:
                Navigator.pushNamed(context, '/catatan');
                break;
              case 4:
                Navigator.pushNamed(context, '/profile');
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Jadwal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Tiket',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notes),
              label: 'Catatan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
