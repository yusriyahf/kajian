import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:kajian/models/kajian.dart';
import 'package:kajian/screens/hasilKamera.dart';

class CameraScreen extends StatefulWidget {
  // final int kajianId;
  final Kajian? kajian;

  CameraScreen({required this.kajian});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  Future<void>? _initializeControllerFuture;

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
    final url = Uri.parse('http://192.168.20.6:8001/analyze/');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = jsonDecode(await response.stream.bytesToString());
        final faceRecognitionResult =
            responseData['face_recognition']['label'] ?? "Unknown";
        final genderDetectionResult =
            responseData['gender_detection']['gender'] ?? "Unknown";

        // Hentikan kamera sebelum navigasi
        await _stopCamera();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreenfix(
              faceRecognitionResult: faceRecognitionResult,
              genderDetectionResult: genderDetectionResult,
              imageFile: File(imageFile.path),
              kajian: widget.kajian,
            ),
          ),
        );
      } else {
        _showErrorDialog(
            'Failed to analyze image. Status: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
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
              title: Text(
                'Pengenalan Wajah',
                style: TextStyle(color: Colors.brown),
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
                            color: Colors.brown,
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
                            color: Colors.brown,
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
