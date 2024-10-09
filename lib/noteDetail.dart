import 'package:flutter/material.dart';

class NoteDetail extends StatefulWidget {
  final Map<String, String> note; // Menerima data catatan

  const NoteDetail({Key? key, required this.note}) : super(key: key);

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _contentController;

  bool isEditing = false; // Untuk memantau apakah mode edit aktif

  @override
  void initState() {
    super.initState();
    // Inisialisasi TextEditingController dengan nilai awal dari catatan
    _titleController = TextEditingController(text: widget.note['title']);
    _dateController = TextEditingController(text: widget.note['date']);
    _contentController = TextEditingController(text: widget.note['content']);
  }

  @override
  void dispose() {
    // Jangan lupa untuk membuang controller saat widget dihapus
    _titleController.dispose();
    _dateController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: const Text(
            'Detail Catatan',
            style: TextStyle(color: Colors.brown),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.brown), // Ikon panah kembali
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context); // Kembali ke layar sebelumnya
          },
        ),
        actions: [
          IconButton(
            icon:
                Icon(isEditing ? Icons.save : Icons.edit, color: Colors.brown),
            onPressed: () {
              setState(() {
                if (isEditing) {
                  // Simpan perubahan dan kembali ke mode non-edit
                  widget.note['title'] = _titleController.text;
                  widget.note['date'] = _dateController.text;
                  widget.note['content'] = _contentController.text;
                  // Anda bisa mengembalikan hasil ini ke halaman sebelumnya jika dibutuhkan
                  Navigator.pop(context,
                      widget.note); // Kembalikan catatan yang sudah diubah
                }
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Catatan
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              decoration: const InputDecoration(
                hintText: 'Judul',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 30,
                ),
                border: InputBorder.none,
              ),
              enabled: isEditing, // Hanya bisa diedit saat mode edit
            ),
            const SizedBox(height: 8),
            // Tanggal Catatan
            TextField(
              controller: _dateController,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              decoration: const InputDecoration(
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: Colors.grey,
                  // fontSize: 30,
                ),
                border: InputBorder.none,
              ),
              enabled: false, // Hanya bisa diedit saat mode edit
            ),
            const SizedBox(height: 16),
            // Konten Catatan
            Expanded(
              child: TextField(
                controller: _contentController,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.brown,
                ),
                maxLines: null, // Agar dapat menulis dalam banyak baris
                decoration: const InputDecoration(
                  hintText: 'Deskripsi',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                ),
                enabled: isEditing, // Hanya bisa diedit saat mode edit
              ),
            ),
          ],
        ),
      ),
    );
  }
}
