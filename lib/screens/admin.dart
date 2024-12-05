import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/detailKajian.dart';
import 'package:kajian/detailkajiann.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/user.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/kajian_service.dart';
import 'package:kajian/services/user_service.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  User? user;
  List<dynamic> _kajianList = [];
  int? totalUser;

  void getUser() async {
    ApiResponse response = await getUserDetail();

    if (response.error == null) {
      setState(() {
        user = response.data as User;
        // txtNameController.text = user!.name ?? ''; // Uncomment jika diperlukan
      });

      // Ambil total user dari API
      ApiResponse totalUserResponse = await getTotalUser();

      // Validasi jika data dari response bernilai null
      if (totalUserResponse.data == null ||
          !(totalUserResponse.data is Map<String, dynamic>)) {
        print('Error: Data is null or not a valid map');
        return;
      }

      // Parsing data dan set nilai totalUser
      final Map<String, dynamic> data =
          totalUserResponse.data as Map<String, dynamic>;
      setState(() {
        totalUser =
            data['user']; // Pastikan key 'user' sesuai dengan struktur API Anda
      });

      // Debugging: print informasi user
      print('User Email: ${user!.email}');
      print('User First Name: ${user!.first_name}');
    } else if (response.error == unauthorized) {
      // Jika unauthorized, logout user dan kembali ke SplashScreen
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false)
          });
    } else {
      // Tampilkan error jika ada masalah
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }

  Future<void> retrieveKajian() async {
    ApiResponse response = await getKajianToday();
    print('Response Data: ${response.data}');

    if (response.error == null) {
      if (response.data != null && response.data is List) {
        setState(() {
          _kajianList = response.data as List<dynamic>;
        });
      } else {
        print("Data tidak valid atau kosong.");
        setState(() {
          _kajianList = []; // Menangani jika data kosong atau tidak valid
        });
      }
    } else if (response.error == unauthorized) {
      // Handle unauthorized error
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreen()),
                (route) => false)
          });
    } else {
      // Tampilkan pesan error jika ada masalah
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    getUser();
    retrieveKajian();
    print(' INI KAJIAN : ${_kajianList}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // _buildHeader(),
          // _buildStatistics(),
          _buildContent(),
          SizedBox(height: 40),
          _buildKajianList(),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          // Navigate to the corresponding page based on the selected index
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
            icon: Icon(Icons.calendar_today),
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

  Widget _buildHeader() {
    return SizedBox(
      width: double.infinity, // Lebar sesuai dengan lebar layar
      height: 240, // Tinggi sesuai kebutuhan
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0), // Radius untuk sudut kiri bawah
          bottomRight: Radius.circular(20.0), // Radius untuk sudut kanan bawah
        ),
        child: Container(
          padding: const EdgeInsets.only(
              left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
          color: Color(0xFF724820),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  const Text(
                    'Selamat Datang',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  user != null
                      ? Text(
                          '${user!.first_name!}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                  const SizedBox(height: 15),
                  Text(
                    DateFormat('EEEE, d MMM yyyy', 'id_ID')
                        .format(DateTime.now()),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 3.0),
                margin: const EdgeInsets.only(
                    left: 10.0, top: 0.0, right: 20.0, bottom: 30.0),
                child: const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Color(0xFFA67B5B),
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Container(
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('${totalUser}', Icons.group),
          _buildStatItem('120', Icons.male),
          _buildStatItem('110', Icons.female),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      clipBehavior: Clip.none, // Mengizinkan elemen keluar dari batas Stack
      children: [
        // Widget header berada di belakang
        _buildHeader(),
        // Widget statistik berada di depan dan memastikan ukuran asli tanpa terpotong
        Positioned(
          top: 180, // Posisi awal dari atas, sesuaikan dengan tinggi header
          left: 10, // Jarak dari kiri
          right: 10, // Jarak dari kanan
          child:
              _buildStatistics(), // Widget statistik yang akan berada di atas header
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFA67B5B)),
        const SizedBox(height: 5),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }

  Widget _buildKajianList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Text(
            'Kajian Hari ini',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF724820)),
          ),
        ),
        _kajianList.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Tidak ada kajian hari ini',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _kajianList.length,
                itemBuilder: (context, index) {
                  final kajian = _kajianList[index];
                  final startTime = DateFormat('h:mm a').format(DateTime(0, 0,
                      0, kajian.start_time!.hour, kajian.start_time!.minute));
                  final endTime = DateFormat('h:mm a').format(DateTime(
                      0, 0, 0, kajian.end_time!.hour, kajian.end_time!.minute));

                  return GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman detail kajian
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                KajianDetailAdminPage(kajian: kajian)),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.only(
                          left: 30.0, top: 20.0, bottom: 20.0, right: 60.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAE6CD),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                                0.2), // Warna shadow dengan opacity
                            blurRadius: 2, // Besar blur
                            offset: Offset(0, 4), // Arah dan jarak bayangan
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$startTime - $endTime',
                            style: const TextStyle(
                                color: Color(0xFF724820), fontSize: 13),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            kajian.title ?? 'Kajian Tidak Ditemukan',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xFF724820)),
                          ),
                          Text(
                            kajian.theme ?? 'Tema Tidak Tersedia',
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF724820)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  // Widget _buildKajianItem() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     padding: const EdgeInsets.only(
  //         left: 30.0, top: 20.0, bottom: 20.0, right: 60.0),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFFFF8DC),
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: const Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '14:00 - 15:00 PM',
  //           style: TextStyle(color: Colors.grey),
  //         ),
  //         SizedBox(height: 5),
  //         Text(
  //           'Kajian Ustadz Hanan Attaki',
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //         ),
  //         Text('Rahasia Merubah Takdir'),
  //       ],
  //     ),
  //   );
  // }
}
