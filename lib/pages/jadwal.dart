import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jawwal Kajian'),
        backgroundColor: Colors.brown,
      ),
      body: const Center(
        child: Text('Detail Jadwal Kajian', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
