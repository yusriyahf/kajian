import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

void main() {
  runApp(FaceApp());
}

class FaceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Detection App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FaceHomePage(),
    );
  }
}

class FaceHomePage extends StatefulWidget {
  @override
  _FaceHomePageState createState() => _FaceHomePageState();
}

class _FaceHomePageState extends State<FaceHomePage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String _result = "";
  final TextEditingController _nameController = TextEditingController();
  bool isLoading = false; // Variabel untuk status loading

  // Fungsi untuk memilih gambar dari galeri
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Fungsi untuk mengambil gambar dari kamera
  Future<void> captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> handlePredict() async {
    if (_selectedImage != null) {
      setState(() {
        isLoading = true; // Tampilkan loading saat menunggu prediksi
      });
      try {
        final faceResult = await predictFace(_selectedImage!);
        final genderResult = await predictGender(_selectedImage!);

        setState(() {
          _result =
              "Face Prediction: $faceResult\\nGender Prediction: $genderResult";
          isLoading = false; // Sembunyikan loading setelah mendapatkan hasil
        });
      } catch (e) {
        setState(() {
          _result = "Error: $e";
          isLoading = false;
        });
      }
    } else {
      setState(() {
        _result = "Please select an image first.";
      });
    }
  }

  Future<String> predictGender(File imageFile) async {
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

  Future<String> predictFace(File imageFile) async {
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

  Future<String> registerFace(File imageFile, String name) async {
    final uri = Uri.parse("http://192.168.20.6:8001/register-face?name=$name");
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(responseBody);
      return jsonResponse["message"].toString();
    } else {
      throw Exception("Failed to register face: $responseBody");
    }
  }

  Future<void> handlePredictGender() async {
    if (_selectedImage != null) {
      setState(() {
        isLoading = true; // Tampilkan loading saat memproses prediksi
      });
      try {
        final result = await predictGender(_selectedImage!);
        setState(() {
          _result = "Gender Prediction: $result";
          isLoading = false; // Sembunyikan loading setelah hasil diterima
        });
      } catch (e) {
        setState(() {
          _result = "Error: $e";
          isLoading = false;
        });
      }
    } else {
      setState(() {
        _result = "Please select an image first.";
      });
    }
  }

  // Future<void> handlePredict() async {
  //   if (_selectedImage != null) {
  //     setState(() {
  //       isLoading = true; // Tampilkan loading saat menunggu prediksi
  //     });
  //     try {
  //       final result = await predictFace(_selectedImage!);
  //       setState(() {
  //         _result = "Prediction: $result";
  //         isLoading = false; // Sembunyikan loading setelah mendapatkan hasil
  //       });
  //     } catch (e) {
  //       setState(() {
  //         _result = "Error: $e";
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }

  Future<void> handleRegister() async {
    if (_selectedImage != null && _nameController.text.isNotEmpty) {
      setState(() {
        isLoading = true; // Tampilkan loading saat menunggu registrasi
      });
      try {
        final message =
            await registerFace(_selectedImage!, _nameController.text);
        setState(() {
          _result = message;
          isLoading = false; // Sembunyikan loading setelah mendapatkan hasil
        });
      } catch (e) {
        setState(() {
          _result = "Error: $e";
          isLoading = false;
        });
      }
    } else {
      setState(() {
        _result = "Please select an image and enter a name.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Detection App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 200)
                : Container(height: 200, color: Colors.grey[300]),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: pickImage, child: Text("Pick Image")),
                ElevatedButton(
                    onPressed: captureImage, child: Text("Capture Image")),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Enter Name"),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: handlePredict, child: Text("Predict")),
                ElevatedButton(
                    onPressed: handleRegister, child: Text("Register")),
                // ElevatedButton(
                //     onPressed: handlePredictGender,
                //     child: Text("Predict Gender")),
              ],
            ),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator() // Tampilkan loading saat isLoading true
                : Text("Result: $_result"),
          ],
        ),
      ),
    );
  }
}
