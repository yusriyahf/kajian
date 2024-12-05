import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/detailkajiann.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/user.dart';
import 'package:kajian/screens/detailTiket.dart';
import 'package:kajian/screens/jadwalKajian.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/screens/profile.dart';
import 'package:kajian/screens/tiket.dart';
import 'package:kajian/services/kajian_service.dart';
import 'package:kajian/services/tiket_service.dart';
import 'package:kajian/services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;
  List<dynamic> _kajianList = [];
  List<dynamic> _tiketList = [];

  // get user detail
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        // loading = false;
        // txtNameController.text = user!.name ?? '';
      });
      print(user!.email);
      print(user!.first_name);
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

  Future<void> retrieveKajian() async {
    ApiResponse response = await getKajianToday();
    ApiResponse responseTiket = await getTiketLast();

    print('Response Data Kajian: ${response.data}');
    print('Response Data Tiket: ${responseTiket.data}');

    // Periksa error dan data dari API Kajian
    if (response.error == null) {
      if (response.data != null && response.data is List) {
        setState(() {
          _kajianList = response.data as List<dynamic>;
        });
      } else {
        print("Data Kajian tidak valid atau kosong.");
        setState(() {
          _kajianList = []; // Menangani jika data kosong atau tidak valid
        });
      }
    } else if (response.error == unauthorized) {
      // Handle unauthorized error untuk Kajian
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false)
          });
    } else {
      // Tampilkan pesan error jika ada masalah di API Kajian
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }

    // Periksa error dan data dari API Tiket
    if (responseTiket.error == null) {
      if (responseTiket.data != null && responseTiket.data is List) {
        setState(() {
          _tiketList = responseTiket.data as List<dynamic>;
        });
      } else {
        print("Data Tiket tidak valid atau kosong.");
        setState(() {
          _tiketList = []; // Menangani jika data kosong atau tidak valid
        });
      }
    } else if (responseTiket.error == unauthorized) {
      // Handle unauthorized error untuk Tiket
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false)
          });
    } else {
      // Tampilkan pesan error jika ada masalah di API Tiket
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('${responseTiket.error}'),
      // ));
      print('anjay');
    }
  }

  // get user detail

  @override
  void initState() {
    getUser();
    retrieveKajian();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 90,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 5),
              user != null
                  ? Text(
                      '${user!.first_name!} ${user!.last_name!}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/images/profile.png'), // Ganti dengan gambar pengguna
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text(
                DateFormat('EEEE, d MMM yyyy', 'id_ID').format(DateTime.now()),
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'asset/img/UstHananAttaki.png', // Ganti dengan gambar kajian
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Kajian yang akan datang",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.brown, size: 16),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => JadwalKajian()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _kajianList.isNotEmpty
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _kajianList.length,
                      itemBuilder: (context, index) {
                        final kajian = _kajianList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KajianDetailPage(
                                  kajian: kajian,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Color(0xFFEAE6CD),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    kajian.start_time != null
                                        ? '${kajian.start_time.hour}:${kajian.start_time.minute.toString().padLeft(2, '0')}'
                                        : 'Waktu tidak tersedia',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    kajian.speaker_name ??
                                        'Pembicara tidak tersedia',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    kajian.theme ?? 'Topik tidak tersedia',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.brown,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Kajian tidak tersedia',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tiket Kajian Saya",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.brown, size: 16),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Tiket()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _tiketList
                      .isNotEmpty // Ganti _myTickets sesuai dengan variabel tiket Anda
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _tiketList.length,
                      itemBuilder: (context, index) {
                        final tiket = _tiketList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailTiket(
                                  tiket: tiket,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: const Color(0xFFEAE6CD),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tiket!.kajian!.start_time != null
                                        ? '${tiket!.kajian!.start_time.hour}:${tiket!.kajian!.start_time.minute.toString().padLeft(2, '0')}'
                                        : 'Waktu tidak tersedia',
                                    // '1',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    // 'a',
                                    tiket.kajian!.title ??
                                        'Event tidak tersedia',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    // 'a',
                                    tiket.kajian!.theme ??
                                        'Pembicara tidak tersedia',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.brown,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: const Text(
                        'Tiket tidak tersedia',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
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
