import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
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
    // Ambil daftar kamera yang tersedia
    cameras = await availableCameras();

    // Periksa apakah ada kamera yang tersedia
    if (cameras.isEmpty) {
      // Menampilkan pesan kesalahan jika tidak ada kamera
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('No camera available.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Inisialisasi kamera depan
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras[
          0], // fallback to the first camera if front camera is not found
    );

    controller = CameraController(frontCamera, ResolutionPreset.high);
    _initializeControllerFuture = controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Center(child: CircularProgressIndicator());
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
              padding: const EdgeInsets.all(40.0), // Adjust padding as needed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Border radius
                      child: Transform(
                        alignment: Alignment.center,
                        transform:
                            Matrix4.rotationY(3.14159), // Flip horizontally
                        child: Container(
                          height:
                              500, // Set the desired height for the camera preview
                          child: CameraPreview(controller!),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 20), // Space between camera preview and button
                  Stack(
                    alignment: Alignment.center, // Center the children
                    children: [
                      Container(
                        width:
                            80, // Width of the outer circular button (outline)
                        height: 80, // Height of the outer circular button
                        decoration: BoxDecoration(
                          color: Colors.transparent, // Make it transparent
                          shape: BoxShape.circle, // Make it circular
                          border: Border.all(
                            color: Colors.brown, // Brown outline
                            width: 3, // Width of the outline
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            await controller!.takePicture();
                            // Tambahkan logika untuk menangani foto di sini
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Container(
                          width: 60, // Width of the inner circular button
                          height: 60, // Height of the inner circular button
                          decoration: BoxDecoration(
                            color: Colors.brown, // Filled brown color
                            shape: BoxShape.circle, // Make it circular
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
