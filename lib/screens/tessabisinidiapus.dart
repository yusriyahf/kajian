import 'package:flutter/material.dart';

void main() {
  runApp(MenuTiket());
}

class MenuTiket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TiketPage(),
    );
  }
}

class TiketPage extends StatefulWidget {
  @override
  _TiketPageState createState() => _TiketPageState();
}

class _TiketPageState extends State<TiketPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Tiket Saya',
          style: TextStyle(color: Colors.brown),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.brown,
          labelColor: Colors.brown,
          tabs: const [
            Tab(text: 'Tiket ACC'),
            Tab(text: 'Tiket Ditolak'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tiket ACC Tab
          ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                child: Card(
                  color: Color(0xFFEAE6CD),
                  elevation: 3, // Menambahkan bayangan pada Card
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Sudut melengkung pada Card
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(
                                width:
                                    16), // Memberikan jarak antara ikon dan teks
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tiket ACC ${index + 1}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Diterima pada 7 Des 2024',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Tiket Ditolak Tab
          ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 5.0), // Jarak antar kartu
                child: Card(
                  color: const Color(0xFFEAE6CD), // Warna latar kartu
                  elevation: 4.0, // Memberikan bayangan pada kartu
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12.0), // Sudut melengkung pada kartu
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.cancel,
                        color: Colors.red), // Ikon di kiri
                    title: Text(
                      'Tiket Ditolak ${index + 1}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown),
                    ), // Judul tiket
                    subtitle: const Text('Ditolak pada 5 Des 2024',
                        style: TextStyle(color: Colors.black54)), // Subjudul
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
