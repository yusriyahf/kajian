import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face & Gender Detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FaceGenderDetectionScreen(),
    );
  }
}

class FaceGenderDetectionScreen extends StatefulWidget {
  @override
  _FaceGenderDetectionScreenState createState() =>
      _FaceGenderDetectionScreenState();
}

class _FaceGenderDetectionScreenState extends State<FaceGenderDetectionScreen> {
  File? _image;
  String? _faceLabel;
  double? _faceConfidence;
  String? _gender;
  double? _genderConfidence;

  final ImagePicker _picker = ImagePicker();

  Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    final uri = Uri.parse(
        'http://192.168.20.6:8001/analyze/'); // Ganti dengan URL API-mu

    try {
      var request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        return json.decode(responseData);
      } else {
        throw Exception(
            'Failed to analyze image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      try {
        final result = await uploadImage(_image!);
        setState(() {
          _faceLabel = result['face_recognition']['label'];
          _faceConfidence = result['face_recognition']['confidence'];
          _gender = result['gender_detection']['gender'];
          _genderConfidence = result['gender_detection']['confidence'];
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face & Gender Detection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null)
              Image.file(_image!, height: 200, width: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            const SizedBox(height: 16),
            if (_faceLabel != null && _faceConfidence != null)
              Text(
                'Face: $_faceLabel (Confidence: ${(_faceConfidence! * 100).toStringAsFixed(2)}%)',
                style: TextStyle(fontSize: 16),
              ),
            if (_gender != null && _genderConfidence != null)
              Text(
                'Gender: $_gender (Confidence: ${(_genderConfidence! * 100).toStringAsFixed(2)}%)',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
