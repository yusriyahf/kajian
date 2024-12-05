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

  void _accPembayaran(int pembayaranId, int kajianId, String image) async {
    // if (!_formKey.currentState!.validate()) return; // Validasi form
    setState(() => _loading = true);

    ApiResponse response = await accPembayaran(
      pembayaranId,
      kajianId,
      image,
    );

    if (response.error == null) {
      Navigator.pop(context);
    } else if (response.error == unauthorized) {
      logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => false));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
    setState(() => _loading = false);
  }

  void _tolakPembayaran(int pembayaranId) async {
    // if (!_formKey.currentState!.validate()) return; // Validasi form
    setState(() => _loading = true);

    ApiResponse response = await tolakPembayaran(pembayaranId);

    if (response.error == null) {
      Navigator.pop(context);
    } else if (response.error == unauthorized) {
      logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => false));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
    setState(() => _loading = false);
  }

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
                                                  showConfirmationDialog(
                                                    context,
                                                    'Tolak',
                                                    'Apakah Anda yakin ingin menolak pembayaran ini?',
                                                    () {
                                                      print('Tiket Ditolak');
                                                      _tolakPembayaran(
                                                          pembayaran.id!);
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .red, // Green color for accept
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
                                                  showConfirmationDialog(
                                                    context,
                                                    'Acc',
                                                    'Apakah Anda yakin ingin menerima pembayaran ini?',
                                                    () {
                                                      print(
                                                          'Hasil : ${pembayaran.id!} ${pembayaran.kajian!.id!}');
                                                      _accPembayaran(
                                                          pembayaran.id!,
                                                          pembayaran
                                                              .kajian!.id!,
                                                          pembayaran
                                                              .kajian!.image!);
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .green, // Red color for reject
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

void showConfirmationDialog(BuildContext context, String title, String message,
    VoidCallback onConfirm) {
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
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              message,
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
                        borderRadius: BorderRadius.circular(64),
                        side: BorderSide(color: Colors.brown),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
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
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
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
}
