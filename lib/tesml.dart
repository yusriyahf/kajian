import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
      home: GenderDetectionApp(), debugShowCheckedModeBanner: false));
}

class GenderDetectionApp extends StatefulWidget {
  @override
  _GenderDetectionAppState createState() => _GenderDetectionAppState();
}

class _GenderDetectionAppState extends State<GenderDetectionApp> {
  File? _image;
  String? _result;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        "http://192.168.63.16:8000/predict/"); // Ganti dengan URL server Anda
    final request = http.MultipartRequest("POST", url);
    request.files.add(await http.MultipartFile.fromPath("file", _image!.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final json = jsonDecode(responseData);
        setState(() {
          _result =
              "Gender: ${json['gender']}, Confidence: ${json['confidence']}";
        });
      } else {
        setState(() {
          _result =
              "Failed to get prediction. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Error: $e";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gender Detection"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 200, width: 200)
                : Text("No image selected"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Pick Image"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text("Predict Gender"),
            ),
            SizedBox(height: 20),
            if (_result != null) Text(_result!),
          ],
        ),
      ),
    );
  }
}
