import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kajian/bayar_tiket.dart';
import 'package:kajian/models/kajian.dart';
import 'package:kajian/screens/pembayaran.dart';

class KajianDetailPage extends StatefulWidget {
  final Kajian? kajian;

  KajianDetailPage({this.kajian});

  @override
  State<KajianDetailPage> createState() => _KajianDetailPageState();
}

class _KajianDetailPageState extends State<KajianDetailPage> {
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
                      child: widget.kajian!.image != null
                          ? Image.network(
                              widget.kajian!.image!,
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
                      'kajian ${widget.kajian!.title!}',
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

                        // Text('Rabu, 19 Des 2024'),
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
                        Icon(Icons.price_change_outlined, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('Rp. ${widget.kajian!.price}'),
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
                    // Peta Google Maps
                    // Container(
                    //   height: 200,
                    //   child: GoogleMap(
                    //     initialCameraPosition: CameraPosition(
                    //       target: LatLng(
                    //           -6.200000, 106.816666), // Koordinat Jakarta
                    //       zoom: 14,
                    //     ),
                    //     markers: {
                    //       Marker(
                    //         markerId: MarkerId('masjid_borcelle'),
                    //         position: LatLng(-6.200000, 106.816666),
                    //         infoWindow: InfoWindow(title: 'Masjid Borcelle'),
                    //       ),
                    //     },
                    //   ),
                    // ),
                    SizedBox(height: 16),
                    // Button Pesan Tiket
                    Center(
                      child: Container(
                        width: 320,
                        height: 59,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(
                                0xFF98614A), // Mengganti 'primary' menjadi 'backgroundColor'
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Border radius
                            ),
                          ),
                          onPressed: () {
                            // Aksi ketika button ditekan
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPembayaranTiket(
                                      kajian: widget.kajian!)),
                            );
                          },
                          child: Text(
                            'Pesan Tiket',
                            style: TextStyle(
                              color: Colors.white, // Warna tulisan putih
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
