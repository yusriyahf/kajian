import 'package:flutter/material.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/tiketModel.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/screens/detailTiket.dart'; // Import your detail page
import 'package:kajian/services/tiket_service.dart';
import 'package:kajian/services/user_service.dart';

class Tiket extends StatefulWidget {
  const Tiket({super.key});

  @override
  State<Tiket> createState() => _TiketState();
}

class _TiketState extends State<Tiket> {
  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final timeOfDay =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  List<dynamic> _tiketList = [];
  bool _loading = true;

  // get all posts
  Future<void> retrieveTiket() async {
    ApiResponse response = await getTiket();

    if (response.error == null) {
      setState(() {
        _tiketList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
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
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _tiketList.length,
                    itemBuilder: (context, index) {
                      TiketModel tiket = _tiketList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailTiket(tiket: tiket),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 414,
                            height: 150,
                            child: Container(
                              decoration: ShapeDecoration(
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 40,
                                    top: 37,
                                    child: Text(
                                      '${formatTimeOfDay(tiket.kajian!.start_time!)} - ${formatTimeOfDay(tiket.kajian!.end_time!)} PM',
                                      textAlign: TextAlign.left,
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
                                    left: 40,
                                    top: 64,
                                    child: Text(
                                      '${tiket.kajian!.title}',
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
                                      '${tiket.kajian!.theme}',
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
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
            )));
  }
}
