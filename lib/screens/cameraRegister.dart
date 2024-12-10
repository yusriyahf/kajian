import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraRegisterScreen extends StatefulWidget {
  @override
  _CameraRegisterScreenState createState() => _CameraRegisterScreenState();
}

class _CameraRegisterScreenState extends State<CameraRegisterScreen> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  Future<void>? _initializeControllerFuture;
  XFile? _image;

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

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await controller!.takePicture();
      setState(() {
        _image = image;
      });

      // After taking the picture, return to the SignUpScreen with the image and name
      Navigator.pop(context, {
        'image': _image,
        'name': 'John Doe'
      }); // Replace 'John Doe' with the actual name
    } catch (e) {
      print('Error taking picture: $e');
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initializeControllerFuture == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Kamera')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // If the camera controller is initialized, show the camera preview
            Center(
              child: _image == null
                  ? FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // Apply transformation if the camera is the front camera
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(
                                3.14159), // Flip the front camera preview
                            child: CameraPreview(controller!),
                          );
                        } else {
                          return CircularProgressIndicator(); // Loading indicator while initializing
                        }
                      },
                    )
                  : Image.file(File(
                      _image!.path)), // Show the captured image if it exists
            ),
            ElevatedButton(
              onPressed: _takePicture,
              child: Text('Take Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
