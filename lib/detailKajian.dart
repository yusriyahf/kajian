import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kajian/models/kajian.dart';

class KajianDetailAdminPage extends StatefulWidget {
  final Kajian? kajian;

  KajianDetailAdminPage({this.kajian});

  @override
  State<KajianDetailAdminPage> createState() => _KajianDetailAdminPageState();
}

class _KajianDetailAdminPageState extends State<KajianDetailAdminPage> {
  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final timeOfDay =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Detail Kajian',
          style: TextStyle(color: Colors.brown),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian gambar dan judul
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: widget.kajian!.imageFile != null
                          ? Image.network(
                              widget.kajian!.imageFile!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey, // Placeholder color
                              child: Center(child: Text('No Image')),
                            ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Kajian ${widget.kajian!.title!}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            color: Colors.brown),
                        SizedBox(width: 8),
                        Text(DateFormat('EEEE, dd MMM yyyy', 'id_ID')
                            .format(widget.kajian!.date!)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time_outlined, color: Colors.brown),
                        SizedBox(width: 8),
                        Text(
                            '${formatTimeOfDay(widget.kajian!.start_time!)} - ${formatTimeOfDay(widget.kajian!.end_time!)}'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('${widget.kajian!.location}'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.book_outlined, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('${widget.kajian!.theme}'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person_outlined, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('${widget.kajian!.speaker_name}'),
                      ],
                    ),

                    SizedBox(height: 16),

                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.brown.shade100),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.people, color: Colors.brown),
                            title: Text('0 Orang'),
                            onTap: () {
                              // Add functionality to change password
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                          ListTile(
                            leading: Icon(Icons.man, color: Colors.brown),
                            title: Text('0 Laki-laki'),
                            onTap: () {
                              // Add functionality for logout
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                          ListTile(
                            leading: Icon(Icons.woman, color: Colors.brown),
                            title: Text('0 Perempuan'),
                            onTap: () {
                              // Add functionality for logout
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                    // Button Pesan Tiket
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: 59,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color(0xFF98614A), // Set background color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Border radius
                            ),
                          ),
                          onPressed: () {
                            // Action when the button is pressed
                            print('Pesan Tiket button pressed');
                          },
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // Center the content
                            children: [
                              Image.asset(
                                'assets/images/scanicon.png', // Path to the local icon
                                width: 24, // Width of the icon
                                height: 24, // Height of the icon
                                color: Colors
                                    .white, // Apply color to the icon (optional)
                              ),
                              // Icon(
                              //   Icons
                              //       .qr_code_scanner, // Use an appropriate scan icon
                              //   color: Colors.white, // Color of the icon
                              //   size: 24, // Size of the icon
                              // ),
                              SizedBox(width: 8), // Space between icon and text
                              Text(
                                'Scan Kehadiran',
                                style: TextStyle(
                                  color: Colors.white, // Color of the text
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 1,
      //   selectedItemColor: Colors.brown,
      //   unselectedItemColor: Colors.grey,
      //   type: BottomNavigationBarType.fixed,
      //   onTap: (index) {
      //     // Navigate to the corresponding page based on the selected index
      //     switch (index) {
      //       case 0:
      //         Navigator.pushNamed(context, '/home');
      //         break;
      //       case 1:
      //         Navigator.pushNamed(context, '/jadwal');
      //         break;
      //       case 2:
      //         Navigator.pushNamed(context, '/tiket');
      //         break;
      //       case 3:
      //         Navigator.pushNamed(context, '/catatan');
      //         break;
      //       case 4:
      //         Navigator.pushNamed(context, '/profile');
      //         break;
      //     }
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Beranda',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.calendar_today),
      //       label: 'Jadwal',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.receipt_long),
      //       label: 'Tiket',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notes),
      //       label: 'Catatan',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profil',
      //     ),
      //   ],
      // ),
    ));
  }
}
