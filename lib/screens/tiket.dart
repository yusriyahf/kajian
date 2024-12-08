import 'package:flutter/material.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/pembayaran.dart';
import 'package:kajian/models/tiketModel.dart';
import 'package:kajian/screens/detailPembayaranAdmin.dart';
import 'package:kajian/screens/detailPembayaranUser.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/screens/detailTiket.dart'; // Import your detail page
import 'package:kajian/services/pembayaran_service.dart';
import 'package:kajian/services/tiket_service.dart';
import 'package:kajian/services/user_service.dart';

class Tiket extends StatefulWidget {
  const Tiket({super.key});

  @override
  State<Tiket> createState() => _TiketState();
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF724820)
      ..strokeWidth = 1;

    const dashWidth = 3.0;
    const dashSpace = 5.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TiketState extends State<Tiket> {
  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final timeOfDay =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  List<dynamic> _tiketList = [];
  List<dynamic> _pembayaranList = [];
  bool _loading = true;

  // get all posts and pembayaran
  Future<void> retrieveData() async {
    // Retrieving tiket
    ApiResponse tiketResponse = await getTiket();
    if (tiketResponse.error == null) {
      setState(() {
        _tiketList = tiketResponse.data as List<dynamic>;
      });
    } else if (tiketResponse.error == unauthorized) {
      _handleUnauthorized();
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${tiketResponse.error}'),
      ));
    }

    // Retrieving pembayaran
    ApiResponse pembayaranResponse = await getPembayaranUser();
    if (pembayaranResponse.error == null) {
      setState(() {
        _pembayaranList = pembayaranResponse.data as List<dynamic>;
        _loading =
            false; // Set _loading to false after both requests are complete
      });
    } else if (pembayaranResponse.error == unauthorized) {
      _handleUnauthorized();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${pembayaranResponse.error}'),
      ));
    }
  }

  void _handleUnauthorized() {
    logout().then((value) => {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SplashScreen()),
              (route) => false)
        });
  }

  @override
  void initState() {
    retrieveData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Tiket Saya',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.brown,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tiket'),
              Tab(text: 'Proses'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // "Tiket" tab content
            Column(
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
                            height: 180, // Adjusted height
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
                                      height: 145,
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
                                        fontSize: 12,
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
                                        fontSize: 20,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 40,
                                    top: 94,
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
                                  Positioned(
                                    left: 40,
                                    top: 120,
                                    child: SizedBox(
                                      width: 283,
                                      height: 1,
                                      child: CustomPaint(
                                        painter: DashedLinePainter(),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 40,
                                    top: 128,
                                    child: Text(
                                      "Rp.156.450",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Color(0xFF724820),
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
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
            // "Proses" tab content
            _loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _pembayaranList.length,
                    itemBuilder: (context, index) {
                      Pembayaran pembayaran = _pembayaranList[
                          index]; // Assuming each item in _pembayaranList is a Map
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              '${pembayaran.kajian!.title}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status: ${pembayaran.status ?? 'Unknown'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Tanggal: ${pembayaran.date ?? 'N/A'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Jumlah: Rp ${pembayaran.kajian!.price ?? '0'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPembayaranUser(
                                    pembayaran: _pembayaranList[
                                        index], // Pass the data of the tapped payment item
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
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
        ),
      ),
    );
  }
}
