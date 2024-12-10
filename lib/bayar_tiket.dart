import 'dart:io'; // Tambahkan untuk mendukung penggunaan File
import 'package:flutter/material.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/kajian.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/screens/tiket.dart';
import 'package:kajian/services/pembayaran_service.dart';
import 'package:kajian/services/user_service.dart';
import 'bukti.dart'; // Tambahkan import untuk bukti.dart
import 'package:image_picker/image_picker.dart'; // Import image_picker package

// void main() {
//   runApp(BayarTiket());
// }

// class BayarTiket extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DetailKajianScreen(),
//     );
//   }
// }

class DetailKajianScreen extends StatefulWidget {
  final Kajian? kajian;

  DetailKajianScreen({this.kajian});
  @override
  _DetailKajianScreenState createState() => _DetailKajianScreenState();
}

class _DetailKajianScreenState extends State<DetailKajianScreen> {
  File? _imageFile;
  bool _loading = false;

// Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Set the picked image file
      });
    } else {
      print("No image selected");
    }
  }

  void _createPembayaran() async {
    setState(() {
      _loading = true; // Menampilkan indikator loading
    });

    try {
      String? idKajian = widget.kajian?.id?.toString();
      String? image = _imageFile == null ? null : getStringImage(_imageFile);

      ApiResponse response = await createPembayaran(idKajian!, image);

      if (response.error == null) {
        // Jika tidak ada error, navigasi ke halaman Tiket
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Tiket()),
          (route) => false, // Menghapus semua route sebelumnya
        );
      } else if (response.error == unauthorized) {
        // Menangani error unauthorized (misalnya logout)
        logout().then((value) => {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false,
              ),
            });
      } else {
        // Menampilkan pesan error dari API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}')),
        );
      }
    } catch (e) {
      // Menangani jika ada exception yang terjadi selama proses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      // Menyembunyikan indikator loading setelah operasi selesai
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF724820),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Detail Pembayaran',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/profile.png',
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
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.brown,
                    thickness: 1,
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
                    color: Colors.brown,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Image.asset(
              'assets/images/qrcode.png',
              height: 200,
            ),
            Text('Unggah bukti pembayaran disini'),
            SizedBox(height: 6),
            GestureDetector(
              onTap: _pickImage,
              child: _imageFile == null
                  ? Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                    )
                  : Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: 320, // Lebar tombol
              height: 50, // Tinggi tombol
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color(0xFF724820),
                  side: BorderSide(color: Colors.brown, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Aksi ketika ditekan
                },
                child: Text(
                  'Bayar Tiket',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
