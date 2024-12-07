import 'dart:async'; // Import untuk menggunakan Timer
import 'package:flutter/material.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/pembayaran.dart';
import 'package:kajian/models/user.dart';
import 'package:kajian/screens/detailPembayaranAdmin.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/pembayaran_service.dart';
import 'package:kajian/services/user_service.dart';

class AdminKonfirmPage extends StatefulWidget {
  @override
  State<AdminKonfirmPage> createState() => _AdminKonfirmPageState();
}

class _AdminKonfirmPageState extends State<AdminKonfirmPage> {
  User? user;
  String? userRole = '';
  List<Pembayaran> _pembayaranDiproses = [];
  List<Pembayaran> _pembayaranSudahDiproses = [];
  bool _loading = true;
  Timer? _timer; // Deklarasi Timer

  Future<void> retrievePembayaran() async {
    ApiResponse response = await getPembayaran();

    if (response.error == null) {
      setState(() {
        List<dynamic> allPembayaran = response.data as List<dynamic>;
        _pembayaranDiproses = allPembayaran
            .where((p) => (p as Pembayaran).status == 'diproses')
            .cast<Pembayaran>()
            .toList();
        _pembayaranSudahDiproses = allPembayaran
            .where((p) => (p as Pembayaran).status != 'diproses')
            .cast<Pembayaran>()
            .toList();
        _loading = false;
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
        userRole = user!.role;
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
    super.initState();
    getUser();
    retrievePembayaran();

    // Set Timer untuk auto-refresh setiap 30 detik
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      retrievePembayaran();
    });
  }

  @override
  void dispose() {
    // Membatalkan timer saat halaman dihancurkan
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Pembayaran',
            style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.brown,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.brown,
            tabs: [
              Tab(text: 'Proses'),
              Tab(text: 'Sudah Diproses'),
            ],
          ),
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildPembayaranList(_pembayaranDiproses),
                  _buildPembayaranList(_pembayaranSudahDiproses),
                ],
              ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildPembayaranList(List<Pembayaran> pembayaranList) {
    if (pembayaranList.isEmpty) {
      return Center(
        child: Text(
          'Belum ada data pembayaran',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: pembayaranList.length,
      itemBuilder: (context, index) {
        Pembayaran pembayaran = pembayaranList[index];
        return _buildPembayaranCard(pembayaran);
      },
    );
  }

  Widget _buildPembayaranCard(Pembayaran pembayaran) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AdminKonfirmPageDetail(pembayaran: pembayaran),
            ),
          );
        },
        child: SizedBox(
          height: 175,
          width: double.infinity,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: const Color(0xFFEAE6CD),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pembayaran.kajian?.title ?? 'Judul Kajian',
                    style: const TextStyle(
                      color: Color(0xFF724820),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pembayaran.kajian?.theme ?? 'Deskripsi Kajian',
                    style: const TextStyle(
                      color: Color(0xFF724820),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }
}
