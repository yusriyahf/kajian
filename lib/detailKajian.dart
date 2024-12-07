import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kajian/camera.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/kajian.dart';
import 'package:kajian/services/kehadiran_service.dart';
import 'package:kajian/tesfix.dart';

class KajianDetailAdminPage extends StatefulWidget {
  final Kajian? kajian;

  KajianDetailAdminPage({this.kajian});

  @override
  State<KajianDetailAdminPage> createState() => _KajianDetailAdminPageState();
}

class _KajianDetailAdminPageState extends State<KajianDetailAdminPage> {
  int _totalMale = 0;
  int _totalFemale = 0;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    if (widget.kajian != null && widget.kajian!.id != null) {
      fetchTotalMale(widget.kajian!.id!);
      fetchTotalFemale(widget.kajian!.id!);
      fetchTotal(widget.kajian!.id!);
    }
  }

  void fetchTotalMale(int kajianId) async {
    ApiResponse response = await getTotalMale(kajianId);
    if (response.error == null) {
      setState(() {
        _totalMale = response.data as int? ?? 0;
      });
    } else {
      print('Error: ${response.error}');
    }
  }

  void fetchTotalFemale(int kajianId) async {
    ApiResponse response = await getTotalFemale(kajianId);
    if (response.error == null) {
      setState(() {
        _totalFemale = response.data as int? ?? 0;
      });
    } else {
      print('Error: ${response.error}');
    }
  }

  void fetchTotal(int kajianId) async {
    ApiResponse response = await getTotal(kajianId);
    if (response.error == null) {
      setState(() {
        _total = response.data as int? ?? 0;
      });
    } else {
      print('Error: ${response.error}');
    }
  }

  String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '-';
    final now = DateTime.now();
    final timeOfDay =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.kajian == null) {
      return Scaffold(
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
        body: Center(
          child: Text(
            'Kajian tidak ditemukan',
            style: TextStyle(fontSize: 18, color: Colors.brown),
          ),
        ),
      );
    }

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
                      child: widget.kajian?.image != null
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
                      'Kajian ${widget.kajian?.title ?? 'Tidak ada judul'}',
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
                        Text(widget.kajian?.date != null
                            ? DateFormat('EEEE, dd MMM yyyy', 'id_ID')
                                .format(widget.kajian!.date!)
                            : '-'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time_outlined, color: Colors.brown),
                        SizedBox(width: 8),
                        Text(
                            '${formatTimeOfDay(widget.kajian?.start_time)} - ${formatTimeOfDay(widget.kajian?.end_time)}'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('${widget.kajian?.location ?? '-'}'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.book_outlined, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('${widget.kajian?.theme ?? '-'}'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person_outlined, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('${widget.kajian?.speaker_name ?? '-'}'),
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
                            title: Text('$_total Orang'),
                          ),
                          ListTile(
                            leading: Icon(Icons.man, color: Colors.brown),
                            title: Text('$_totalMale Laki-laki'),
                          ),
                          ListTile(
                            leading: Icon(Icons.woman, color: Colors.brown),
                            title: Text('$_totalFemale Perempuan'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: 59,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF98614A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (widget.kajian?.id != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CameraScreen(kajian: widget.kajian),
                                ),
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/scanicon.png',
                                width: 24,
                                height: 24,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Scan Kehadiran',
                                style: TextStyle(
                                  color: Colors.white,
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
    ));
  }
}
