import 'package:flutter/material.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/pembayaran.dart';
import 'package:kajian/models/user.dart';
import 'package:kajian/screens/detailPembayaranAdmin.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/pembayaran_service.dart';
import 'package:kajian/services/user_service.dart';

// void main() {
//   runApp(
//       MaterialApp(home: AdminKonfirmPage(), debugShowCheckedModeBanner: false));
// }

class AdminKonfirmPage extends StatefulWidget {
  @override
  State<AdminKonfirmPage> createState() => _AdminKonfirmPageState();
}

class _AdminKonfirmPageState extends State<AdminKonfirmPage> {
  User? user;
  String? userRole = '';
  List<dynamic> _pembayaranList = [];
  bool _loading = true;

  Future<void> retrievePembayaran() async {
    ApiResponse response = await getPembayaran();

    if (response.error == null) {
      setState(() {
        _pembayaranList = response.data as List<dynamic>;
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
    retrievePembayaran();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {},
        ),
        title: const Text(
          'Pembayaran',
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: CircleAvatar(
        //       backgroundImage: AssetImage('assets/profile.jpg'),
        //       radius: 16,
        //     ),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : _pembayaranList.isEmpty
                      ? Center(
                          child: Text(
                            'Belum ada data pembayaran',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _pembayaranList.length,
                          itemBuilder: (context, index) {
                            // Ambil data pembayaran dari _pembayaranList
                            Pembayaran pembayaran = _pembayaranList[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AdminKonfirmPageDetail(
                                              pembayaran: pembayaran),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height: 175, // Tinggi card
                                  width: double.infinity,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    color: const Color(0xFFEAE6CD),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                // Format waktu sesuai kebutuhan
                                                '${pembayaran.date?.hour}:${pembayaran.date?.minute} - Selesai',
                                                style: const TextStyle(
                                                  color: Color(0xFF724820),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            pembayaran.kajian?.title ??
                                                'Judul Kajian',
                                            style: const TextStyle(
                                              color: Color(0xFF724820),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            pembayaran.kajian?.theme ??
                                                'Deskripsi Kajian',
                                            style: const TextStyle(
                                              color: Color(0xFF724820),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  print(
                                                      'Tiket Ditolak ID: ${pembayaran.id}');
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 20),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Tolak',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              ElevatedButton(
                                                onPressed: () {
                                                  print(
                                                      'Tiket Diterima ID: ${pembayaran.id}');
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 20),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Acc',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: userRole == '2'
          ? BottomNavigationBar(
              currentIndex: 1,
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
              currentIndex: 2,
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
