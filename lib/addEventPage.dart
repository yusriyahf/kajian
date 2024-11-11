import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kajian/screens/jadwalKajian.dart';

import 'package:kajian/constant.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/kajian.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/kajian_service.dart';
import 'package:kajian/services/user_service.dart';
import 'dart:io';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Waktu awal, bisa disesuaikan
    );

    if (pickedTime != null) {
      // Format waktu yang dipilih ke dalam format 'HH:mm'
      final String formattedTime =
          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      setState(() {
        controller.text =
            formattedTime; // Set waktu yang dipilih ke dalam TextFormField
      });
    } else {
      // Menangani kasus jika waktu tidak dipilih
      print("Waktu tidak dipilih.");
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        // Format the date and set it to the controller
        _txtControllerDate.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerTitle = TextEditingController();
  final TextEditingController _txtControllerSpeakername =
      TextEditingController();
  final TextEditingController _txtControllerTheme = TextEditingController();
  final TextEditingController _txtControllerDate = TextEditingController();
  final TextEditingController _txtControllerLocation = TextEditingController();
  final TextEditingController _txtControllerStarttime = TextEditingController();
  final TextEditingController _txtControllerEndtime = TextEditingController();
  bool _loading = false;
  File? _imageFile;

  void _createPost() async {
    DateTime parseDate(String date) {
      return DateFormat('yyyy-MM-dd').parse(date);
    }

    final String dateString = _txtControllerDate.text;
    DateTime parsedDate = parseDate(dateString);

    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    String formatTimeOfDay(TimeOfDay time) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }

    final String startTimeString = _txtControllerStarttime.text;
    final String endTimeString = _txtControllerEndtime.text;
    TimeOfDay startTime = parseTimeOfDay(startTimeString);
    final String startTimes = formatTimeOfDay(startTime);

    TimeOfDay endTime = parseTimeOfDay(endTimeString);
    final String endTimes = formatTimeOfDay(endTime);

    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createKajian(
      _txtControllerTitle.text,
      _txtControllerSpeakername.text,
      _txtControllerTheme.text,
      formattedDate,
      _txtControllerLocation.text,
      startTimes,
      endTimes,
      image,
    );

    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.brown), // Ikon panah kembali
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context); // Kembali ke layar sebelumnya
          },
        ),
        title: const Text(
          'Tambah Jadwal Kajian',
          style: TextStyle(color: Colors.brown),
        ),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Jadwal',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF724820)),
              ),
              const SizedBox(height: 10),
              Text(
                'Tambah jadwal anda di sini',
                style: TextStyle(fontSize: 16, color: Color(0xFF61677D)),
              ),
              const SizedBox(height: 32), // Add space between title and form
              Text('Nama Kajian'),
              SizedBox(height: 6),
              TextFormField(
                controller: _txtControllerTitle,
                validator: (val) =>
                    val!.isEmpty ? 'Kajian name is required' : null,
                decoration: InputDecoration(
                  hintText: 'Masukkan Nama Kajian',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              Text('Tanggal Kajian'),
              SizedBox(height: 6),
              TextFormField(
                controller:
                    _txtControllerDate, // Use the new controller for the date
                readOnly: true, // Make it read-only
                decoration: InputDecoration(
                  hintText: 'Masukkan Tanggal Kajian',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today), // Icon kalender
                    onPressed: () =>
                        _selectDate(context), // Open date picker on tap
                  ),
                ),
                onTap: () => _selectDate(context), // Open date picker on tap
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Waktu Kajian'),
                  const SizedBox(height: 6), // Adjust spacing as needed
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _txtControllerStarttime,
                      decoration: InputDecoration(
                        hintText: 'Waktu Mulai',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: GestureDetector(
                  //     onTap: () => _selectTime(context,
                  //         _txtControllerStarttime), // Tampil dialog waktu saat ketuk
                  //     child: TextFormField(
                  //       controller: _txtControllerStarttime,
                  //       readOnly: true, // Agar tidak bisa mengetik langsung
                  //       decoration: InputDecoration(
                  //         hintText: 'Waktu Mulai',
                  //         hintStyle: TextStyle(
                  //           fontWeight: FontWeight.normal,
                  //           color: Colors.grey,
                  //         ),
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10)),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _txtControllerEndtime,
                      decoration: InputDecoration(
                        hintText: 'Waktu Selesai',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Text('Lokasi Kajian'),
              SizedBox(height: 6),
              TextFormField(
                controller: _txtControllerLocation,
                decoration: InputDecoration(
                  hintText: 'Masukkan Lokasi Kajian',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              Text('Tema Kajian'),
              SizedBox(height: 6),
              TextFormField(
                controller: _txtControllerTheme,
                decoration: InputDecoration(
                  hintText: 'Masukkan Tema Kajian',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              Text('Nama Ustadz'),
              SizedBox(height: 6),
              TextFormField(
                controller: _txtControllerSpeakername,
                decoration: InputDecoration(
                  hintText: 'Masukkan Nama Ustadz',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              // TextFormField(
              //   controller: _durationController,
              //   decoration: const InputDecoration(labelText: 'Durasi'),
              // ),
              const SizedBox(height: 32),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 100), // Adjust padding as needed
                  decoration: BoxDecoration(
                    color: Colors.brown, // Background color of the box
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      print(_txtControllerStarttime);
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          // loading = !loading;
                          _createPost();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Make the button background transparent
                      elevation: 0, // Remove button elevation
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(color: Colors.white),
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
