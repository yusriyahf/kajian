import 'package:flutter/material.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/catatan.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/catatan_service.dart';
import 'package:kajian/services/user_service.dart';

class NoteDetail extends StatefulWidget {
  final Catatan? catatan;
  // final Map<String, String> note; // Menerima data catatan

  NoteDetail({this.catatan});
  // const NoteDetail({Key? key, required this.note}) : super(key: key);

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleControllerBody = TextEditingController();
  final TextEditingController _descriptionControllerBody =
      TextEditingController();
  bool _loading = false;

  void _editPost(int postId) async {
    ApiResponse response = await editCatatan(
        postId, _titleControllerBody.text, _descriptionControllerBody.text);
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
  void initState() {
    if (widget.catatan != null) {
      _titleControllerBody.text = widget.catatan!.title ?? '';
      _descriptionControllerBody.text = widget.catatan!.description ?? '';
    }
    super.initState();
  }

  // late TextEditingController _titleController;
  // late TextEditingController _dateController;
  // late TextEditingController _contentController;

  bool isEditing = false; // Untuk memantau apakah mode edit aktif

  // @override
  // void initState() {
  //   super.initState();
  //   // Inisialisasi TextEditingController dengan nilai awal dari catatan
  //   _titleController = TextEditingController(text: widget.note['title']);
  //   _dateController = TextEditingController(text: widget.note['date']);
  //   _contentController = TextEditingController(text: widget.note['content']);
  // }

  // @override
  // void dispose() {
  //   // Jangan lupa untuk membuang controller saat widget dihapus
  //   _titleController.dispose();
  //   _dateController.dispose();
  //   _contentController.dispose();
  //   super.dispose();
  // }

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
                if (_formKey.currentState!.validate()) {
                  _editPost(widget.catatan!.id ?? 0);
                }
                if (isEditing) {
                  _editPost;
                  // Simpan perubahan dan kembali ke mode non-edit
                  // widget.catatan!.title = _titleControllerBody.text;
                  // widget.catatan!.description = _descriptionControllerBody.text;
                  // widget.note['date'] = _dateController.text;
                  // Anda bisa mengembalikan hasil ini ke halaman sebelumnya jika dibutuhkan
                  Navigator.pop(context,
                      widget.catatan); // Kembalikan catatan yang sudah diubah
                }
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Catatan
              TextFormField(
                controller: _titleControllerBody,
                validator: (val) =>
                    val!.isEmpty ? 'Catatan title is required' : null,
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
              TextFormField(
                controller: _descriptionControllerBody,
                validator: (val) =>
                    val!.isEmpty ? 'Catatan description is required' : null,
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
                child: TextFormField(
                  controller: _descriptionControllerBody,
                  validator: (val) =>
                      val!.isEmpty ? 'Catatan description is required' : null,
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
      ),
    );
  }
}
