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
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back_ios, color: Colors.brown),
          //   onPressed: () {
          //     Navigator.pop(
          //         context); // Fungsi untuk kembali ke halaman sebelumnya
          //   },
          // ),
          automaticallyImplyLeading: false,
          title: Text(
            'Tiket Saya',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF724820),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tiket'),
              Tab(text: 'Proses'),
            ],
            labelColor: Colors.white, // Warna teks tab yang aktif
            unselectedLabelColor:
                Colors.grey, // Warna teks tab yang tidak aktif
            indicatorColor: Colors.white, // Warna indikator tab yang aktif
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
                            height: 180,
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
            ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _pembayaranList.length,
              itemBuilder: (context, index) {
                Pembayaran pembayaran = _pembayaranList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPembayaranUser(
                            pembayaran: pembayaran,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 414,
                      height: 180,
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Background color for the main card
                            Positioned(
                              left: 20,
                              top: 20,
                              child: Container(
                                width: 320,
                                height: 145,
                                decoration: ShapeDecoration(
                                  color: Color(0xFFEAE6CD),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                            // Title of the payment (kajian's title)
                            Positioned(
                              left: 40,
                              top: 37,
                              child: Text(
                                '${pembayaran.kajian!.title}',
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
                            // Status information
                            Positioned(
                              left: 40,
                              top: 70,
                              child: Text(
                                'Status: ${pembayaran.status ?? 'Unknown'}',
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
                            // Garis putus-putus di bawah teks Status
                            Positioned(
                              left: 40,
                              top: 100, // Tempatkan di bawah teks status
                              child: SizedBox(
                                width: 283,
                                height: 1,
                                child: CustomPaint(
                                  painter: DashedLinePainter(),
                                ),
                              ),
                            ),
                            // Harga pembayaran
                            Positioned(
                              left: 40,
                              top: 120,
                              child: Text(
                                'Rp ${pembayaran.kajian!.price ?? '0'}',
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
