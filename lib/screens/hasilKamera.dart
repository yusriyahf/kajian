import 'dart:io';
import 'package:flutter/material.dart';

class FaceRecognitionScreen extends StatelessWidget {
  final String faceRecognitionResult;
  final String genderDetectionResult;
  final File imageFile;

  FaceRecognitionScreen({
    required this.faceRecognitionResult,
    required this.genderDetectionResult,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengenalan Wajah',
          style: TextStyle(color: Color(0xFF724820)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF724820)),
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
                  color: Colors.brown.shade50,
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
                          child: Image.file(
                            imageFile, // Tampilkan gambar dari kamera
                            width: 200,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Deskripsi dan tombol aksi
                    Container(
                      width: double.infinity, // Lebar container
                      height: 130, // Tinggi container
                      decoration: BoxDecoration(
                        color: Color(0xFFF5EEDC), // Warna latar belakang
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          // Teks
                          Positioned(
                            top: 25, // Jarak dari atas container
                            child: Text(
                              'Face Result: $faceRecognitionResult\nGender: $genderDetectionResult',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF6D4C41), // Warna teks
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
                                print("Go to right clicked");
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
                                        .min, // Agar elemen mengikuti isi kontennya
                                    children: [
                                      Text(
                                        'GO TO RIGHT',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Colors.white, // Warna teks tombol
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              8), // Jarak antara teks dan ikon
                                      Icon(
                                        Icons.arrow_forward, // Ikon panah
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
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
                  // Logika untuk menyimpan data
                  print("Save clicked");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF724820), // Warna latar belakang
                    borderRadius: BorderRadius.circular(12), // Sudut membulat
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Center(
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // Warna teks
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
