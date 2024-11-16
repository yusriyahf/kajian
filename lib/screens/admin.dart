import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kajian/constant.dart';
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
        // loading = false;
        // txtNameController.text = user!.name ?? '';
      });
      ApiResponse totalUserResponse = await getTotalUser();
      Map<String, dynamic> data =
          totalUserResponse.data as Map<String, dynamic>;
      totalUser = totalUser = data['user'];
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

    if (response.error == null) {
      setState(() {
        _kajianList = response.data as List<dynamic>;
        // _loading = _loading ? !_loading : _loading;
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
    getUser();
    retrieveKajian();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildStatistics(),
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
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(
          left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
      color: const Color(0xFFA67B5B),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selamat Datang',
                style: TextStyle(color: Colors.white, fontSize: 16),
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
              const SizedBox(height: 5),
              Text(
                DateFormat('EEEE, d MMM yyyy', 'id_ID').format(DateTime.now()),
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(
                left: 10.0, top: 0.0, right: 20.0, bottom: 30.0),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFFA67B5B)),
            ),
          ),
        ],
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
          _buildStatItem('120', Icons.person),
          _buildStatItem('110', Icons.person_outline),
        ],
      ),
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // const SizedBox(height: 10),
        _kajianList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _kajianList.length,
                itemBuilder: (context, index) {
                  final kajian = _kajianList[index];
                  final startTime = DateFormat('h:mm a').format(DateTime(0, 0,
                      0, kajian.start_time!.hour, kajian.start_time!.minute));
                  final endTime = DateFormat('h:mm a').format(DateTime(
                      0, 0, 0, kajian.end_time!.hour, kajian.end_time!.minute));

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.only(
                        left: 30.0, top: 20.0, bottom: 20.0, right: 60.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8DC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$startTime - $endTime',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          kajian.title ?? 'Kajian Tidak Ditemukan',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(kajian.theme ?? 'Tema Tidak Tersedia'),
                      ],
                    ),
                  );
                },
              ),
        // _buildKajianItem(),
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
