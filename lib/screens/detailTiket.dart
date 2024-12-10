import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kajian/models/tiketModel.dart';

// void main() {
//   runApp(DetailTiket());
// }

class DetailTiket extends StatefulWidget {
  final TiketModel? tiket;
  // final Map<String, String> note; // Menerima data catatan

  DetailTiket({this.tiket});
  // const NoteDetail({Key? key, required this.note}) : super(key: key);

  @override
  State<DetailTiket> createState() => _DetailTiketState();
}

class _DetailTiketState extends State<DetailTiket> {
  String formatCurrency(int? price) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return formatCurrency.format(price ?? 0);
  }

  String formatDateTime(DateTime dateTime) {
    List<String> days = [
      "Minggu",
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu"
    ];
    List<String> months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];

    String dayName = days[dateTime.weekday % 7];
    String day = dateTime.day.toString();
    String monthName = months[dateTime.month - 1];
    String year = dateTime.year.toString();

    // Ambil waktu dari created_at (jam dan menit)
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    // Format tanggal dan waktu
    return "$dayName, $day/$monthName/$year Pukul $hour:$minute WIB";
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final timeOfDay =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    print("Tiket title: ${widget.tiket?.kajian?.title}");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Detail Tiket")),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tiket!.kajian!.title!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Pembayaran :",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            " ${formatCurrency(widget.tiket!.kajian!.price)}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Ticket Details Container
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Detail Tiket",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      Text(
                        "Tanggal Booking : ${formatDateTime(widget.tiket!.created_at!)}",
                        // "Tanggal Booking : Kamis, 8/Agustus/2024 Pukul 19:46 WIB",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Tanggal Event Dimulai :${formatDateTime(widget.tiket!.kajian!.date!)}",
                        // "Tanggal Event Dimulai : Minggu, 6/Oktober/2024 Pukul 15:00 WIB",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 50),
                      Text(
                        "Data diri",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Nama Depan : ${widget.tiket!.user!.first_name} ",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Nama Belakang : ${widget.tiket!.user!.last_name} ",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Email :  ${widget.tiket!.user!.email}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 50),
                      Text(
                        "Informasi Pembayaran",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Event :  ${widget.tiket!.kajian!.title!}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Total Pembayaran : ${formatCurrency(widget.tiket!.kajian!.price)}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Metode Pembayaran : DANA",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Status Pembayaran : Dibayar",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
