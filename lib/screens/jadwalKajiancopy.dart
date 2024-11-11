import 'package:flutter/material.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/detailkajiann.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/kajian.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/kajian_service.dart';
import 'package:kajian/services/user_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:collection';
import '../addEventPage.dart';

void main() {
  runApp(const JadwalKajianCopy());
}

class Event {
  final String title;
  final String subtitle;
  final String timeA;
  final String timeB;
  final String duration;
  final String date;
  final String loc;
  final String theme;
  final String usName;
  bool isCompleted;

  Event({
    required this.title,
    this.subtitle = '',
    this.timeA = '',
    this.timeB = '',
    this.duration = '',
    this.loc = '',
    this.theme = '',
    this.usName = '',
    String? date, // Accept date as a String
    bool? isCompleted,
  })  : date = date ??
            DateFormat('yyyy-MM-dd')
                .format(DateTime.now()), // Use current date as default
        isCompleted = isCompleted ?? false;

  // You can add a method to parse the date if needed
  DateTime getParsedDate() {
    return DateFormat('yyyy-MM-dd').parse(date);
  }

  @override
  String toString() => title;
}

class JadwalKajianCopy extends StatefulWidget {
  const JadwalKajianCopy({super.key});

  @override
  _JadwalKajianCopyState createState() => _JadwalKajianCopyState();
}

class _JadwalKajianCopyState extends State<JadwalKajianCopy> {
  String calculateDuration(String startTimeStr, String endTimeStr) {
    try {
      // Parse the time strings into DateTime objects
      DateTime startTime = DateFormat("HH:mm").parse(startTimeStr);
      DateTime endTime = DateFormat("HH:mm").parse(endTimeStr);

      // Calculate duration
      Duration duration = endTime.difference(startTime);

      int hours = duration.inHours;
      int minutes = duration.inMinutes % 60;
      return '${hours}h ${minutes}m';
    } catch (e) {
      return 'Invalid time format';
    }
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Initialize with empty events
  final Map<DateTime, List<Event>> _events = LinkedHashMap(
    equals: isSameDay,
    hashCode: (day) => day.day * 1000000 + day.month * 10000 + day.year,
  );

  List<Event> _kajianList = [];
  int userId = 0;
  bool _loading = true;

  // Fetch Kajian data and update events
  Future<void> retrieveKajian() async {
    userId = await getUserId();
    ApiResponse response = await getKajian();

    if (response.error == null) {
      setState(() {
        _kajianList = [];
        _events.clear(); // Clear existing events

        List<dynamic> kajianList = response.data as List<dynamic>;
        // Convert each Kajian into Event and add to _events
        for (Kajian kajian in kajianList) {
          DateTime eventDate = kajian.date ?? DateTime.now();
          Event event = Event(
            title: kajian.title ?? '',
            timeA: kajian.start_time != null
                ? '${kajian.start_time?.hour}:${kajian.start_time?.minute}'
                : '',
            timeB: kajian.end_time != null
                ? '${kajian.end_time?.hour}:${kajian.end_time?.minute}'
                : '',
            date: DateFormat('yyyy-MM-dd').format(eventDate),
            theme: kajian.theme ?? '',
            usName: kajian.speaker_name ?? '',
            loc: kajian.location ?? '',
          );

          // Add event to the correct day
          if (_events.containsKey(eventDate)) {
            _events[eventDate]?.add(event);
          } else {
            _events[eventDate] = [event];
          }
        }

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

  @override
  void initState() {
    retrieveKajian();
    super.initState();
  }

  // Get events for a specific day
  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  // Handle day selection in the calendar
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        // Fetch events for the selected day
        _kajianList = _getEventsForDay(selectedDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Jadwal Kajian',
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.brown,
          ),
          body: Column(
            children: [
              // Bagian Kalender
              Container(
                height: 320,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE6CD),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(25)),
                ),
                child: TableCalendar(
                  rowHeight: 40,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: Colors.brown,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  firstDay: DateTime.utc(2000, 01, 01),
                  lastDay: DateTime(2045, 01, 01),
                  eventLoader: _getEventsForDay,
                  onDaySelected: _onDaySelected,
                  availableGestures: AvailableGestures.all,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    todayDecoration: BoxDecoration(
                      color: const Color(0xFFEAE6CD),
                      border: Border.all(color: Colors.brown, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    todayTextStyle: const TextStyle(
                      color: Colors.brown,
                    ),
                    defaultDecoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              // Tampilkan kajian yang sesuai dengan tanggal yang dipilih
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: _loading
                      ? Center(child: CircularProgressIndicator())
                      : _kajianList.isEmpty
                          ? Center(child: Text('No events on this date'))
                          : ListView.builder(
                              itemCount: _kajianList.length,
                              itemBuilder: (context, index) {
                                Event kajian = _kajianList[index];

                                return SizedBox(
                                  width: 400,
                                  height: 175,
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    elevation: 3,
                                    color: const Color(0xFFEAE6CD),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Bagian untuk teks dan waktu
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Waktu di bagian atas
                                              Text(
                                                "${kajian.timeA} - ${kajian.timeB}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.brown,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              // Nama Kajian (Title)
                                              Text(
                                                kajian.title ?? '',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.brown,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              // Tema Kajian (Subtitle)
                                              Text(
                                                kajian.theme ?? '',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.brown,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              // Nama Pembicara
                                              Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .brown, // Background color of the box
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20), // Rounded corners
                                                  ),
                                                  child: Text(
                                                    calculateDuration(
                                                        kajian.timeA ?? '',
                                                        kajian.timeB ?? ''),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors
                                                          .white, // White text color
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        // Bagian untuk gambar
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right:
                                                  16.0), // Padding untuk jarak dari sisi kanan
                                          child: Align(
                                            alignment: Alignment
                                                .centerRight, // Mengatur posisi ikon di sebelah kanan
                                            child: GestureDetector(
                                              onTap: () {
                                                // Navigasi ke halaman detail
                                              },
                                              child: CircleAvatar(
                                                radius: 25, // Ukuran lingkaran
                                                backgroundColor: Colors.brown,
                                                child: Icon(
                                                  Icons
                                                      .arrow_forward_rounded, // Ikon panah
                                                  color: Colors
                                                      .white, // Warna ikon
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 1,
            selectedItemColor: Colors.brown,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
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
          )),
    );
  }
}
