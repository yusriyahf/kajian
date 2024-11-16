import 'package:flutter/material.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/catatan.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/catatan_service.dart';
import 'package:kajian/services/user_service.dart';

class NoteDetail extends StatefulWidget {
  final Catatan? catatan;

  NoteDetail({this.catatan});

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _loading = false;
  bool isEditing = false; // Untuk memantau apakah mode edit aktif

  // Fungsi Edit Catatan
  void _editPost(int postId) async {
    if (!_formKey.currentState!.validate()) return; // Validasi form
    setState(() => _loading = true);

    ApiResponse response = await editCatatan(
      postId,
      _titleController.text,
      _descriptionController.text,
    );

    if (response.error == null) {
      Navigator.of(context).pop(); // Kembali setelah berhasil edit
    } else if (response.error == unauthorized) {
      logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => false));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
    setState(() => _loading = false);
  }

  // Fungsi Delete Catatan
  void _handleDeleteNotes(int catatanId) async {
    ApiResponse response = await deleteCatatan(catatanId);
    if (response.error == null) {
      Navigator.of(context).pop(true); // Kembali dan beri tahu berhasil hapus
    } else if (response.error == unauthorized) {
      logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => false));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    if (widget.catatan != null) {
      _titleController.text = widget.catatan!.title ?? '';
      _descriptionController.text = widget.catatan!.description ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Detail Catatan',
            style: TextStyle(color: Colors.brown),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon:
                Icon(isEditing ? Icons.save : Icons.edit, color: Colors.brown),
            onPressed: () {
              if (isEditing) {
                // Simpan perubahan
                _editPost(widget.catatan!.id!);
              }
              setState(() => isEditing = !isEditing);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.brown),
            onPressed: () {
              _handleDeleteNotes(widget.catatan!.id!);
            },
          )
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
                controller: _titleController,
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
                enabled: isEditing,
              ),
              const SizedBox(height: 8),
              // Deskripsi Catatan
              Expanded(
                child: TextFormField(
                  controller: _descriptionController,
                  validator: (val) =>
                      val!.isEmpty ? 'Catatan description is required' : null,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.brown,
                  ),
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Deskripsi',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                  ),
                  enabled: isEditing,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
