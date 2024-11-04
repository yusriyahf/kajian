import 'package:flutter/material.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/tiket.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/tiket_service.dart';
import 'package:kajian/services/user_service.dart';

// void main() {
//   runApp(const Tiket());
// }

class Tiket extends StatefulWidget {
  // const Tiket({super.key});

  @override
  State<Tiket> createState() => _TiketState();
}

class _TiketState extends State<Tiket> {
  List<dynamic> _tiketList = [];
  int userId = 0;
  // bool _loading = true;

  // get all posts
  Future<void> retrieveTiket() async {
    userId = await getUserId();
    ApiResponse response = await getTiket();

    if (response.error == null) {
      setState(() {
        _tiketList = response.data as List<dynamic>;
        // _loading = false;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    retrieveTiket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Tiket Saya',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.brown,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _tiketList.length,
          itemBuilder: (context, index) {
            Tiket tiket = _tiketList[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                width: 414,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Container(
                        width: 320,
                        height: 107,
                        decoration: ShapeDecoration(
                          color: Color(0xFFEAE6CD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 40,
                      top: 64,
                      child: Text(
                        'a', // Title from data
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF724820),
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 40,
                      top: 88,
                      child: Text(
                        'p', // Subtitle from data
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF724820),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                    ),
                    // Positioned(
                    //   left: 40,
                    //   top: 37,
                    //   child: Text(
                    //     ticket['time'], // Time from data
                    //     textAlign: TextAlign.left,
                    //     style: TextStyle(
                    //       color: Color(0xFF724820),
                    //       fontSize: 10,
                    //       fontFamily: 'Inter',
                    //       fontWeight: FontWeight.w500,
                    //       height: 1.2,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
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
        ),
      ),
    );
  }
}
