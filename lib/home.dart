import 'package:flutter/material.dart';
import 'package:kajian/bayar_tiket.dart';
import 'package:kajian/detailKajian.dart';
import 'package:kajian/jadwalKajian.dart';
import 'package:kajian/tiket.dart';
// import 'package:kajian/pages/jadwal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'Yusriyah F',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: Icon(Icons.menu, color: Colors.black),
        actions: [
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ProfilePage()),
              // );
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage(
                  'asset/img/fotoprofile.png'), // replace with user's image
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            const Text(
              "Rabu, 19 Des 2024",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'asset/img/UstHananAttaki.png', // replace with kajian image
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
                  "Kajian Terdekat",
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
            const KajianCard(),
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
            const KajianCard(),
          ],
        ),
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
    ));
  }
}

// Sample page for "Kajian Terdekat" navigation
// class KajianListPage extends StatelessWidget {
//   const KajianListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Kajian Terdekat'),
//         backgroundColor: Colors.brown,
//       ),
//       body: const Center(
//         child: Text('Daftar Kajian Terdekat', style: TextStyle(fontSize: 24)),
//       ),
//     );
//   }
// }

// Sample page for "Tiket Kajian Saya" navigation
// class TiketPage extends StatelessWidget {
//   const TiketPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tiket Kajian Saya'),
//         backgroundColor: Colors.brown,
//       ),
//       body: const Center(
//         child: Text('Daftar Tiket Kajian Saya', style: TextStyle(fontSize: 24)),
//       ),
//     );
//   }
// }

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tiket Kajian Saya'),
//         backgroundColor: Colors.brown,
//       ),
//       body: const Center(
//         child: Text('this is profile page', style: TextStyle(fontSize: 24)),
//       ),
//     );
//   }
// }

class KajianCard extends StatelessWidget {
  const KajianCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => KajianDetailAdminPage()),
        ); // Ganti dengan rute yang sesuai
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.brown.shade50,
        child: const Padding(
          padding: EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 60.0), // Adjusted padding for wider appearance
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "14:00 - 15:00 PM",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                "Kajian Ustadz Hanan Attaki",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 4),
              Text(
                "Rahasia Merubah Takdir",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
