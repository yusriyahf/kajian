import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});
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
              const Text(
                'Admin',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                DateFormat('EEEE, d MMM yyyy').format(DateTime.now()),
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
          _buildStatItem('230', Icons.group),
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
        const SizedBox(height: 10),
        _buildKajianItem(),
        _buildKajianItem(),
        _buildKajianItem(),
      ],
    );
  }

  Widget _buildKajianItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.only(
          left: 30.0, top: 20.0, bottom: 20.0, right: 60.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '14:00 - 15:00 PM',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 5),
          Text(
            'Kajian Ustadz Hanan Attaki',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text('Rahasia Merubah Takdir'),
        ],
      ),
    );
  }

  // Widget _buildBottomNavigation() {
  //   return BottomNavigationBar(
  //     selectedItemColor: const Color(0xFFA67B5B),
  //     unselectedItemColor: Colors.grey,
  //     currentIndex: 0,
  //     items: const [
  //       BottomNavigationBarItem(icon: ImageIcon(AssetImage('asset/img/iconhome.png')), label: 'Home'),
  //       BottomNavigationBarItem(icon: ImageIcon(AssetImage('asset/img/EditProperty.png')), label: 'Kajian'),
  //       BottomNavigationBarItem(icon: ImageIcon(AssetImage('asset/img/person.png')), label: 'Akun'),
  //     ],
  //   );
  // }
}
