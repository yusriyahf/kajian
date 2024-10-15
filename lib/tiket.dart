import 'package:flutter/material.dart';

void main() {
  runApp(const Tiket());
}

class Tiket extends StatelessWidget {
  const Tiket({super.key});

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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            // Center the entire Column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: [
                Container(
                  width: 414,
                  height: 896,
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
                        left: 20, // Moved closer to the left edge
                        top: 20, // Moved closer to the top edge
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
                        left: 40, // Moved closer to the left edge
                        top: 64,
                        child: Text(
                          'Kajian Ustadz Hanan Attaki',
                          textAlign: TextAlign.left, // Align text to the left
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
                        left: 40, // Moved closer to the left edge
                        top: 88,
                        child: Text(
                          'Rahasia Merubah Takdir',
                          textAlign: TextAlign.left, // Align text to the left
                          style: TextStyle(
                            color: Color(0xFF724820),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40, // Moved closer to the left edge
                        top: 37,
                        child: Text(
                          '14:00 - 15:00 PM',
                          textAlign: TextAlign.left, // Align text to the left
                          style: TextStyle(
                            color: Color(0xFF724820),
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20, // Moved closer to the left edge
                        top: 160,
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
                        left: 40, // Moved closer to the left edge
                        top: 204,
                        child: Text(
                          'Kajian Ustadz Hanan Attaki',
                          textAlign: TextAlign.left, // Align text to the left
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
                        left: 40, // Moved closer to the left edge
                        top: 228,
                        child: Text(
                          'Rahasia Merubah Takdir',
                          textAlign: TextAlign.left, // Align text to the left
                          style: TextStyle(
                            color: Color(0xFF724820),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40, // Moved closer to the left edge
                        top: 177,
                        child: Text(
                          '16:00 - 17:00 PM',
                          textAlign: TextAlign.left, // Align text to the left
                          style: TextStyle(
                            color: Color(0xFF724820),
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          selectedItemColor: Colors.brown,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            // Navigate to the corresponding page based on the selected index
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
