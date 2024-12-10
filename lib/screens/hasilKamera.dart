import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/detailKajian.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/kajian.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/screens/profile.dart';
import 'package:kajian/services/kehadiran_service.dart';
import 'package:kajian/services/user_service.dart';

class ResultScreenfix extends StatefulWidget {
  final String faceRecognitionResult;
  final String genderDetectionResult;
  final File imageFile;
  final Kajian? kajian;
  final bool? statusTiket;
  final int? idKajian;
  final int? idUser;

  ResultScreenfix({
    required this.faceRecognitionResult,
    required this.genderDetectionResult,
    required this.imageFile,
    required this.kajian,
    required this.statusTiket,
    required this.idKajian,
    required this.idUser,
  });

  @override
  State<ResultScreenfix> createState() => _ResultScreenfixState();
}

class _ResultScreenfixState extends State<ResultScreenfix> {
  void _addKehadiran(int? kajianid, String gender, int userId) async {
    print('Creating Kehadiran for Kajian ID: $kajianid, Gender: $gender');

    ApiResponse response = await createKehadiran(kajianid!, gender, userId);

    if (response.error == null) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kehadiran berhasil ditambahkan!')),
      );

      // Navigate to KajianDetailAdminPage after a delay to let the user see the success message
      await Future.delayed(Duration(seconds: 1));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => KajianDetailAdminPage(
            kajian: widget.kajian,
          ),
        ),
        (route) => false,
      );
    } else if (response.error == unauthorized) {
      print('Unauthorized error');
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false)
          });
    } else if (response.error == 'Kehadiran already exists.') {
      // Handle the 400 error (existing Kehadiran)
      print('Kehadiran already exists');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kehadiran tidak berhasil ditambahkan!')),
      );

      // Navigate to KajianDetailAdminPage after a delay
      await Future.delayed(Duration(seconds: 5));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => KajianDetailAdminPage(
            kajian: widget.kajian,
          ),
        ),
        (route) => false,
      );
    } else {
      // Handle other errors
      print('Error: ${response.error}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data sudah ada')),
      );

      // Navigate to KajianDetailAdminPage after a delay to let the user see the success message
      await Future.delayed(Duration(seconds: 5));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => KajianDetailAdminPage(
            kajian: widget.kajian,
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.statusTiket);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengenalan Wajah',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF724820),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Kontainer untuk menampilkan gambar wajah
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFEAE6CD),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(
                                3.14159), // Rotasi 180 derajat untuk memperbaiki efek mirror
                            child: Image.file(
                              widget.imageFile, // Tampilkan gambar dari kamera
                              width: 200,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Deskripsi dan tombol aksi
                    Container(
                      width: double.infinity, // Lebar container
                      height: 150, // Tinggi container
                      decoration: BoxDecoration(
                        color: Color(0xFFEAE6CD), // Warna latar belakang
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          // Teks
                          Positioned(
                            top: 20, // Jarak dari atas container
                            child: Text(
                              widget.faceRecognitionResult == 'Unknown'
                                  ? 'Anda belum terdaftar'
                                  : '${widget.faceRecognitionResult} \n'
                                      '${widget.statusTiket! ? 'Anda sudah membeli tiket' : (widget.faceRecognitionResult == 'No face detected' ? '' : 'Anda belum membeli tiket')} \n'
                                      'Gender: ${widget.genderDetectionResult}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF724820), // Warna teks
                              ),
                            ),
                          ),

                          // Tombol
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom:
                                0, // Atur posisi tombol dari bawah container
                            child: GestureDetector(
                              onTap: () {
                                // Logika aksi saat tombol ditekan
                                print("Go to right clicked ");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFB3876A), // Warna tombol
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
                                child: Center(
                                  // Menempatkan konten di tengah
                                  child: Row(
                                    mainAxisSize: MainAxisSize
                                        .min, // Agar elemen mengikuti ukuran kontennya
                                    children: [
                                      // Icon(
                                      //   widget.genderDetectionResult ==
                                      //           "Laki-laki"
                                      //       ? Icons.male // Ikon untuk laki-laki
                                      //       : Icons
                                      //           .female, // Ikon untuk perempuan
                                      //   color: Colors.white, // Warna ikon
                                      //   size: 16,
                                      // ),
                                      SizedBox(
                                          width:
                                              8), // Jarak antara ikon dan teks
                                      Text(
                                        widget.faceRecognitionResult ==
                                                'Unknown'
                                            ? 'Silahkan Registrasi dahulu'
                                            : widget.statusTiket == false
                                                ? 'Silahkan beli tiket dulu'
                                                : 'SILAHKAN KE ${widget.genderDetectionResult == "Laki-laki" ? "KANAN" : "KIRI"}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Colors.white, // Warna teks tombol
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              SizedBox(height: 40),
              // Tombol "Simpan"
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (widget.statusTiket == true) {
                      // If statusTiket is true, add kehadiran
                      _addKehadiran(widget.kajian!.id,
                          widget.genderDetectionResult, widget.idUser!);
                      print("Kehadiran Added");
                    } else {
                      // If statusTiket is false, navigate to KajianDetailAdminPage
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => KajianDetailAdminPage(
                            kajian: widget.kajian,
                          ),
                        ),
                        (route) => false,
                      );
                      print("Navigated to KajianDetailAdminPage");
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF724820), // Warna latar belakang
                    borderRadius: BorderRadius.circular(12), // Sudut membulat
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Center(
                    child: Text(
                      widget.statusTiket == true
                          ? 'Tambah Kehadiran'
                          : 'Kembali', // Change text based on statusTiket
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // Warna teks
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
