import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'jadwalKajian.dart';

class AddEventPage extends StatefulWidget {
  final Function(Event) onEventAdded;

  const AddEventPage({Key? key, required this.onEventAdded}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _timeAController = TextEditingController();
  final TextEditingController _timeBController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

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
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final newEvent = Event(
        title: _titleController.text,
        subtitle: _subtitleController.text,
        timeA: _timeAController.text,
        timeB: _timeBController.text,
        duration: _durationController.text,
        date: _dateController.text,
      );
      widget.onEventAdded(newEvent);
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Jadwal Kajian',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              TextField(
                controller: _titleController,
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
              TextField(
                controller:
                    _dateController, // Use the new controller for the date
                readOnly: true, // Make it read-only
                decoration: InputDecoration(
                  hintText: 'Masukkan Tanggal Kajian',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onTap: () => _selectDate(context), // Open date picker on tap
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _timeAController,
                      decoration:
                          const InputDecoration(labelText: 'Waktu Mulai'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Waktu mulai harus diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _timeBController,
                      decoration:
                          const InputDecoration(labelText: 'Waktu Selesai'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Durasi'),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.brown, // Warna latar belakang tombol
                  ),
                  child: const Text('Simpan Jadwal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
