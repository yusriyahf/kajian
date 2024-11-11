import 'package:flutter/material.dart';

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
                obscureText: _isPasswordVisible1,
                decoration: InputDecoration(
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
                obscureText: _isPasswordVisible2,
                decoration: InputDecoration(
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
                  onPressed: () {},
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
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 5,
      //   selectedItemColor: Colors.brown,
      //   unselectedItemColor: Colors.grey,
      //   type: BottomNavigationBarType.fixed,
      //   onTap: (index) {
      //     switch (index) {
      //       case 0:
      //         Navigator.pushNamed(context, '/home');
      //         break;
      //       case 1:
      //         Navigator.pushNamed(context, '/jadwal');
      //         break;
      //       case 2:
      //         Navigator.pushNamed(context, '/tiket');
      //         break;
      //       case 3:
      //         Navigator.pushNamed(context, '/catatan');
      //         break;
      //       case 4:
      //         Navigator.pushNamed(context, '/profile');
      //         break;
      //     }
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Beranda',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.calendar_today),
      //       label: 'Jadwal',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.receipt_long),
      //       label: 'Tiket',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notes),
      //       label: 'Catatan',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profil',
      //     ),
      //   ],
      // )
    );
  }
}
