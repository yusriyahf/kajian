import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart'; // Import paket untuk border putus-putus
import 'package:image_picker/image_picker.dart'; // Import paket untuk memilih gambar
import 'dart:io'; // Untuk mengelola file gambar

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Bukti Pembayaran',
      home: UploadScreen(),
    );
  }
}

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image; // Menyimpan gambar yang dipilih
  final ImagePicker _picker = ImagePicker(); // Instance dari ImagePicker

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path); // Mengatur gambar yang dipilih
        });
      } else {
        // Tampilkan pesan jika tidak ada gambar yang dipilih
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak ada gambar yang dipilih')),
        );
      }
    } catch (e) {
      // Tampilkan pesan jika terjadi kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: Text(
          'Detail Kajian',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.brown,),
        ),
      ),
      CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage('assets/img/profil.png'),
      ),
    ],
  ),
),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Unggah bukti pembayaran disini',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage, // Menambahkan fungsi untuk memilih gambar
              child: DottedBorder(
                color: Colors.brown.shade300, // Warna border
                strokeWidth: 2, // Ketebalan garis
                dashPattern: [6, 3], // Pola garis putus-putus
                borderType: BorderType.RRect,
                radius: Radius.circular(10), // Radius border 10
                child: Container(
                  width: 200,
                  height: 327,
                  decoration: BoxDecoration(
                    color: Colors.brown.shade50, // Warna dalam kotak
                    borderRadius: BorderRadius.circular(10), // Sudut membulat dalam kotak
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Menampilkan gambar yang dipilih jika ada
                      if (_image != null) 
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _image!,
                            width: 200,
                            height: 327,
                            fit: BoxFit.cover,
                          ),
                        ),
                      // Lingkaran border dengan latar belakang transparan
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent, // Latar belakang transparan
                          border: Border.all(
                            color: Colors.brown.shade300, // Warna border lingkaran
                            width: 2, // Ketebalan border lingkaran
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            size: 50,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Mengatur jarak 150 piksel antara kotak unggah dan tombol
            SizedBox(height: 150), 
            SizedBox(
              width: 300,
              child: OutlinedButton(
                onPressed: () {
                  // Kode untuk mengirim bukti pembayaran
                  Navigator.pop(context, true);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.brown.shade300, width: 2), // Border warna coklat
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Kirim Bukti Pembayaran',
                  style: TextStyle(color: Colors.brown.shade300, fontSize: 16), // Teks warna coklat
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.brown[200],
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num),
            label: 'Tiket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Catatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
