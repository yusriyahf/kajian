import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:kajian/cange_password.dart';
import 'package:kajian/tentangAplikasi.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/user_service.dart';
import 'package:kajian/models/user.dart';

import 'package:kajian/models/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  String? userRole = '';
  // get user detail

  void getUser() async {
    ApiResponse response = await getUserDetail();

    if (response.error == null) {
      setState(() {
        user = response.data as User;
        userRole = user!.role; // Perbarui userRole di dalam setState
        print('user role : $userRole');
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            SizedBox(height: 20),
            if (user != null) // Check if 'user' is not null
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.brown.shade100),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Saya',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Username',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${user!.first_name} ${user!.last_name}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${user!.email}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(color: Colors.brown.shade100),
                    ListTile(
                      leading: Icon(Icons.lock_outline, color: Colors.brown),
                      title: Text('Ganti Password'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyAppPass()),
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.brown),
                      title: Text('Logout'),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.all(16),
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 15),
                                  Text(
                                    'Keluar dari akun',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Apakah anda ingin keluar?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 40),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(64),
                                              side: BorderSide(
                                                  color: Colors.brown),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                          ),
                                          child: Text(
                                            'Tidak',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.brown,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            logout().then((value) => {
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SplashScreen()),
                                                          (route) => false)
                                                });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.brown,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(64),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                          ),
                                          child: Text(
                                            'Iya',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                        // logout().then((value) => {
                        //       Navigator.of(context).pushAndRemoveUntil(
                        //           MaterialPageRoute(
                        //               builder: (context) => SplashScreen()),
                        //           (route) => false)
                        //     });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline, color: Colors.brown),
                      title: Text('Tentang Aplikasi'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AboutPage()), // Navigate to About Me Page
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              )
            else
              Center(
                  child:
                      CircularProgressIndicator()), // Show a loader if 'user' is null
          ],
        ),
      ),
      bottomNavigationBar: userRole == null
          ? null // Jangan tampilkan apa pun saat userRole null
          : userRole == '2'
              ? BottomNavigationBar(
                  currentIndex: 4,
                  selectedItemColor: Colors.brown,
                  unselectedItemColor: Colors.grey,
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        Navigator.pushNamed(context, '/home');
                        break;
                      case 1:
                        Navigator.pushNamed(context, '/jadwal');
                        break;
                      case 2:
                        Navigator.pushNamed(context, '/tiket');
                        break;
                      case 3:
                        Navigator.pushNamed(context, '/catatan');
                        break;
                      case 4:
                        Navigator.pushNamed(context, '/profile');
                        break;
                    }
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Beranda',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: 'Jadwal',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.receipt_long),
                      label: 'Tiket',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notes),
                      label: 'Catatan',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profil',
                    ),
                  ],
                )
              : BottomNavigationBar(
                  currentIndex: 3,
                  selectedItemColor: Colors.brown,
                  unselectedItemColor: Colors.grey,
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        Navigator.pushNamed(context, '/homeAdmin');
                        break;
                      case 1:
                        Navigator.pushNamed(context, '/jadwal');
                        break;
                      case 2:
                        Navigator.pushNamed(context, '/pembayaran');
                        break;
                      case 3:
                        Navigator.pushNamed(context, '/profile');
                        break;
                    }
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Beranda',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: 'Kajian',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.payment),
                      label: 'Pembayaran',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profil',
                    ),
                  ],
                ),
    );
  }
}
