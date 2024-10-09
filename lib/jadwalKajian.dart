import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:collection';
import 'AddEvent.dart';

void main() {
  runApp(const JadwalKajian());
}

class Event {
  final String title;
  final String subtitle;
  final String timeA;
  final String timeB;
  final String duration;
  final String date;
  bool isCompleted;

  Event({
    required this.title,
    this.subtitle = '',
    this.timeA = '',
    this.timeB = '',
    this.duration = '',
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

class JadwalKajian extends StatefulWidget {
  const JadwalKajian({super.key});

  @override
  _JadwalKajianState createState() => _JadwalKajianState();
}

class _JadwalKajianState extends State<JadwalKajian> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Event> _selectedEvents = [];

  final Map<DateTime, List<Event>> _events = LinkedHashMap(
    equals: isSameDay,
    hashCode: (day) => day.day * 1000000 + day.month * 10000 + day.year,
  )..addAll(_eventSource);

  static final Map<DateTime, List<Event>> _eventSource = {
    DateTime.now().subtract(const Duration(days: 2)): [
      Event(
        timeA: '10:00 AM',
        timeB: '12:00 AM',
        title: 'Kajian Hadits',
        subtitle: 'Membahas Hadits',
        duration: '2h',
      ),
      Event(
        timeA: '02:00 PM',
        timeB: '03:30 PM',
        title: 'Kajian Aqidah',
        subtitle: 'Pembahasan Aqidah',
        duration: '1h 30m',
      ),
    ],
    DateTime.now().subtract(const Duration(days: 1)): [
      Event(
        timeA: '11:00 AM',
        timeB: '13:00 AM',
        title: 'Kajian Fiqih',
        subtitle: 'Fiqih Muamalah',
        duration: '2h',
      ),
      Event(
        timeA: '03:00 PM',
        timeB: '04:00 PM',
        title: 'Kajian Bahasa Arab',
        subtitle: 'Kelas Bahasa Arab',
        duration: '1h',
      ),
    ],
    DateTime.now(): [
      Event(
        timeA: '09:00 AM',
        timeB: '10:40 AM',
        title: 'Kajian Tafsir',
        subtitle: 'Tafsir Al-Quran',
        duration: '1h 45m',
      ),
      Event(
        timeA: '04:00 PM',
        timeB: '05:30 PM',
        title: 'Kajian Sirah',
        subtitle: 'Sejarah Nabi',
        duration: '1h 30m',
      ),
    ],
    DateTime.now().add(const Duration(days: 1)): [
      Event(
        timeA: '10:00 AM',
        timeB: '12:00 AM',
        title: 'Kajian Akhlak',
        subtitle: 'Pembahasan Akhlak',
        duration: '2h',
      ),
      Event(
        timeA: '01:00 PM',
        timeB: '02:15 PM',
        title: 'Kajian Sejarah',
        subtitle: 'Sejarah Islam',
        duration: '1h 15m',
      ),
    ],
    DateTime.now().add(const Duration(days: 2)): [
      Event(
        timeA: '09:00 AM',
        timeB: '10.30 AM',
        title: 'Kajian Sirah',
        subtitle: 'Sirah Nabi',
        duration: '1h 30m',
      ),
      Event(
        timeA: '03:00 PM',
        timeB: '05:00 PM',
        title: 'Kajian Ibadah',
        subtitle: 'Pembahasan Ibadah',
        duration: '2h',
      ),
    ],
  };

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents = _getEventsForDay(selectedDay);
      });
    }
  }

  void _addEvent(String title) {
    if (title.isNotEmpty) {
      setState(() {
        if (_events[_selectedDay] != null) {
          _events[_selectedDay]!.add(Event(title: title));
        } else {
          _events[_selectedDay!] = [Event(title: title)];
        }
        _selectedEvents = _getEventsForDay(_selectedDay!);
      });
    }
  }

  void _showAddEventDialog() {
    TextEditingController eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Jadwal'),
          content: TextField(
            controller: eventController,
            decoration:
                const InputDecoration(hintText: 'Masukkan judul kajian'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addEvent(eventController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
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
            // Bagian untuk menampilkan acara
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: ListView.builder(
                  itemCount: _selectedEvents.length,
                  itemBuilder: (context, index) {
                    final event = _selectedEvents[index];
                    final isCompleted = event.isCompleted;

                    return SizedBox(
                      width: 400,
                      height: 165,
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        elevation: 3,
                        color: isCompleted
                            ? Colors.grey[300]
                            : const Color(0xFFEAE6CD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Stack(
                          children: [
                            // Bagian untuk teks dan waktu
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Waktu di bagian atas
                                  Text(
                                    "${event.timeA} - ${event.timeB}", // Menggabungkan jam awal dan durasi
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Teks lainnya
                                  Text(
                                    event.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isCompleted
                                          ? Colors.grey
                                          : Colors.brown,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    event.subtitle,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical:
                                            8), // Padding dalam persegi panjang
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .brown, // Warna latar belakang persegi panjang
                                      borderRadius: BorderRadius.circular(
                                          15), // Radius sudut persegi panjang
                                    ),
                                    child: Text(
                                      event.duration,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white, // Warna teks
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Bagian untuk icon
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TicketDetailPage(event: event),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 25, // Ukuran lingkaran
                                    backgroundColor: Colors.brown,
                                    child: Icon(
                                      Icons.arrow_forward_rounded, // Ikon panah
                                      color: Colors.white, // Warna ikon
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEventPage(
                  onEventAdded: (newEvent) {
                    setState(() {
                      if (_selectedDay != null) {
                        _events[_selectedDay!] = _events[_selectedDay!] ?? [];
                        _events[_selectedDay!]!.add(newEvent);
                        _selectedEvents = _getEventsForDay(_selectedDay!);
                      }
                    });
                  },
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(30), // Menjadikan latar belakang bulat
          ),
        ),
      ),
    );
  }
}

// Halaman detail untuk tiket
class TicketDetailPage extends StatelessWidget {
  final Event event;

  const TicketDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Subtitle: ${event.subtitle}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Time: ${event.timeA}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Duration: ${event.duration}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
