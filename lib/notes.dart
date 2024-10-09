import 'package:flutter/material.dart';
import 'addNotes.dart'; // Import file baru
import 'noteDetail.dart'; // Import untuk melihat detail catatan

void main() {
  runApp(const Notes());
}

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<Map<String, String>> notes = []; // List untuk menyimpan catatan

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
                  itemCount: notes.length, // Jumlah catatan
                  itemBuilder: (context, index) {
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
                              builder: (context) => NoteDetail(
                                note: notes[index], // Kirim data catatan
                              ),
                            ),
                          );
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
                                        notes[index]['title'] ??
                                            '', // Judul Catatan
                                        style: const TextStyle(
                                          color: Color(0xFF724820),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Spacer(), // Spacer untuk mendorong tanggal ke kanan
                                      Text(
                                        notes[index]['date'] ??
                                            '', // Tanggal catatan
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
                                    // Memastikan konten tidak null sebelum menggunakan substring
                                    (notes[index]['content']?.length ?? 0) > 20
                                        ? '${notes[index]['content']?.substring(0, 20)}...' // Batasi sampai 20 karakter dan tambahkan ellipsis
                                        : notes[index]['content'] ??
                                            '', // Tampilkan semua
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
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddNote()),
            );
            if (result != null) {
              setState(() {
                // Menambahkan catatan baru ke dalam list notes
                notes.add(result);
              });
            }
          },
          backgroundColor: Colors.brown,
          child: const Icon(Icons.add, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(30), // Menjadikan latar belakang bulat
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.brown,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
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
