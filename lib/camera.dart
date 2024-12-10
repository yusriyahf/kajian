import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Untuk MediaType
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/kajian.dart';
import 'package:kajian/screens/hasilKamera.dart';
import 'package:kajian/services/tiket_service.dart';

class CameraScreen extends StatefulWidget {
  final Kajian? kajian;

  CameraScreen({required this.kajian});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  Future<void>? _initializeControllerFuture;
  bool isLoading = false; // Status loading untuk proses prediksi

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showErrorDialog('No camera available.');
        return;
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras[0],
      );

      controller = CameraController(frontCamera, ResolutionPreset.high);
      _initializeControllerFuture = controller?.initialize();
      setState(() {});
    } catch (e) {
      _showErrorDialog('Failed to initialize cameras: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _analyzeImage(XFile imageFile) async {
    setState(() {
      isLoading = true; // Tampilkan loading saat proses berlangsung
    });

    try {
      // Prediksi wajah dan gender
      final faceResult = await _predictFace(File(imageFile.path));
      final genderResult = await _predictGender(File(imageFile.path));

      ApiResponse statusTiket =
          await checkTiket(widget.kajian!.id!, faceResult);
      ApiResponse idUser = await getIdUser(faceResult);
      int? userIdfix = idUser.data as int? ?? 0;
      bool? tiketStatus = statusTiket.data as bool? ?? false;
      setState(() {
        isLoading = false; // Sembunyikan loading setelah selesai
      });

      // Hentikan kamera sebelum navigasi
      await _stopCamera();

      // Navigasi ke halaman hasil
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreenfix(
            faceRecognitionResult: faceResult,
            genderDetectionResult: genderResult,
            imageFile: File(imageFile.path),
            kajian: widget.kajian,
            statusTiket: tiketStatus,
            idKajian: widget.kajian!.id!,
            idUser: userIdfix,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Error: $e');
    }
  }

  Future<String> _predictFace(File imageFile) async {
    final uri = Uri.parse("http://192.168.20.6:8001/predict");
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr)["predict"].toString();
    } else {
      throw Exception('Failed to predict face');
    }
  }

  Future<String> _predictGender(File imageFile) async {
    final uri = Uri.parse("http://192.168.20.6:8001/predict-gender");
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr)["predict"].toString();
    } else {
      throw Exception('Failed to predict gender');
    }
  }

  Future<void> _stopCamera() async {
    if (controller != null) {
      await controller!.dispose();
      controller = null;
    }
  }

  @override
  void dispose() {
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (controller == null || _initializeControllerFuture == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF724820),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.pop(
                      context); // Fungsi untuk kembali ke halaman sebelumnya
                },
              ),
              title: Text(
                'Pengenalan Wajah',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.14159), // Rotasi kamera
                        child: Container(
                          height: 500,
                          child: CameraPreview(controller!),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF724820),
                            width: 3,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            final image = await controller!.takePicture();
                            await _analyzeImage(image);
                          } catch (e) {
                            _showErrorDialog('Error: $e');
                          }
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFF724820),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
