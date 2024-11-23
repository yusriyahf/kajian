import 'package:flutter/material.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/screens/profile.dart';
import 'package:kajian/services/user_service.dart';

void main() {
  runApp(MyAppPass());
}

class MyAppPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangePasswordScreen(),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isPasswordVisible1 = true;
  bool _isPasswordVisible2 = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordControllerBody = TextEditingController();
  final TextEditingController _passwordConfirmationControllerBody =
      TextEditingController();

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sukses'),
          content: Text('Kata sandi berhasil diubah.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gagal'),
          content: Text('Kata Sandi Tidak Berhasil Diubah'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _changePassword() async {
    ApiResponse response = await updatePassword(
        _passwordControllerBody.text, _passwordConfirmationControllerBody.text);

    if (response.error == null) {
      _showSuccessDialog(); // Show success dialog
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false)
          });
    } else {
      // Use the null-aware operator to provide a default error message
      _showErrorDialog(response.error ?? 'An unknown error occurred.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profil',
          style: TextStyle(color: Colors.brown),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  'Ubah Kata Sandi',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Ubah Kata Sandi anda',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 47),
                Text(
                  'Kata Sandi',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 9),
                TextFormField(
                  controller: _passwordControllerBody,
                  validator: (val) =>
                      val!.isEmpty ? 'Password is required' : null,
                  obscureText: _isPasswordVisible1,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                    hintText: 'Kata Sandi',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible1
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible1 = !_isPasswordVisible1;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Konfirmasi Kata Sandi',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 9),
                TextFormField(
                  controller: _passwordConfirmationControllerBody,
                  validator: (val) =>
                      val!.isEmpty ? 'Password confirmation is required' : null,
                  obscureText: _isPasswordVisible2,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                    hintText: 'Konfirmasi Kata Sandi',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible2
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible2 = !_isPasswordVisible2;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _changePassword();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Reset Password',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
