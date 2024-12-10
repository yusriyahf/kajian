import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AboutPage(),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF724820),
        title: Text(
          'Tentang Aplikasi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // Handle back action here
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tentang Kajian',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Aplikasi Kajian dirancang agar para pengguna, baik peserta maupun penyelenggara kajian, dapat memiliki akses mudah terhadap informasi acara kajian, serta dapat berpartisipasi dengan lebih efektif dan efisien dengan menggabungkan teknologi modern seperti pemindai wajah dan sistem tiket digital, aplikasi Kajian memfasilitasi pengalaman yang lebih terstruktur dan aman bagi pengguna, mulai dari pendaftaran hingga pelaksanaan acara.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'FAQ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ExpansionTile(
              title: Text('Apa itu Kajian?'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Aplikasi Kajian adalah sebuah platform mobile yang dikembangkan untuk membantu pengguna dalam mengatur dan mengelola berbagai aspek terkait acara kajian keagamaan.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Bagaimana cara menggunakan aplikasi ini?'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Anda dapat menggunakan aplikasi ini dengan mengikuti petunjuk di setiap fitur yang tersedia.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Apakah data saya aman?'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Kami sangat menghargai privasi Anda dan melindungi data pribadi Anda.',
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Kebijakan Privasi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Kami menghargai privasi Anda dan berkomitmen untuk melindungi data pribadi Anda. Informasi lebih lanjut tentang kebijakan privasi kami dapat ditemukan di situs web kami.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
