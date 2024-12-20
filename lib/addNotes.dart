import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl untuk format tanggal
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/catatan.dart';
import 'package:kajian/models/user.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/catatan_service.dart';
import 'package:kajian/services/user_service.dart';
import 'package:kajian/constant.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleControllerBody = TextEditingController();
  final TextEditingController _descriptionControllerBody =
      TextEditingController();
  bool _loading = false;

  void _createPost() async {
    setState(() {
      _loading = true; // Tampilkan indikator loading
    });

    ApiResponse response = await createCatatan(
      _titleControllerBody.text,
      _descriptionControllerBody.text,
    );

    if (response.error == null) {
      Navigator.of(context)
          .pop(true); // Kembali ke halaman sebelumnya dengan hasil true
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
      setState(() {
        _loading = false; // Sembunyikan indikator loading
      });
    }
  }

  String _formattedDate = ''; // Variabel untuk menyimpan tanggal

  @override
  void initState() {
    super.initState();
    // Mendapatkan dan memformat tanggal saat ini
    _formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF724820),
        title: Text(
          'Catatan Saya',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.white), // Ikon panah kembali
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context); // Kembali ke layar sebelumnya
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _createPost();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleControllerBody,
                  validator: (val) =>
                      val!.isEmpty ? 'Notes title is required' : null,
                  style: const TextStyle(
                    // Menentukan style text field
                    fontSize: 30, // Ukuran font
                    color: Color(0xFF724820),
                    fontWeight: FontWeight.bold, // Ketebalan font
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Judul',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 30,
                    ),
                    border: InputBorder.none, // Menghilangkan garis bawah
                  ),
                  maxLines:
                      null, // Menyebabkan FormTextField untuk menambah baris secara otomatis
                  minLines: 1, // Menampilkan minimal 10 baris secara default
                ),
                const SizedBox(height: 8.0), // Jarak antara title dan date
                Text(
                  _formattedDate, // Menampilkan tanggal tanpa kata "Date"
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF724820),
                  ),
                ),

                const SizedBox(height: 16.0), // Jarak antara date dan content
                TextFormField(
                  controller: _descriptionControllerBody,
                  validator: (val) =>
                      val!.isEmpty ? 'Catatan description is required' : null,
                  style: const TextStyle(
                    fontSize: 15, // Ukuran font
                    color: Color(0xFF724820), // Warna font
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Deskripsi',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                    border: InputBorder.none, // Menghilangkan garis bawah
                  ),
                  maxLines:
                      null, // Menyebabkan TextField untuk menambah baris secara otomatis
                  minLines: 10, // Menampilkan minimal 10 baris secara default
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
