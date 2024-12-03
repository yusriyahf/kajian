import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kajian/bayar_tiket.dart';
import 'package:kajian/bukti.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/models/kajian.dart';
import 'package:kajian/models/tiketModel.dart';
import 'package:kajian/models/user.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/user_service.dart';

// void main() {
//   runApp(DetailPembayaranTiket());
// }

class DetailPembayaranTiket extends StatefulWidget {
  final Kajian kajian;

  DetailPembayaranTiket({required this.kajian});

  @override
  State<DetailPembayaranTiket> createState() => _DetailPembayaranTiketState();
}

class _DetailPembayaranTiketState extends State<DetailPembayaranTiket> {
  User? user;
  // get user detail
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SplashScreen()),
            (route) => false);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
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
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Tiket title: ${widget.kajian.title}");

    if (user == null) {
      // Show a loading indicator while user data is being fetched
      return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Pembayaran Tiket")),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: CircularProgressIndicator(), // Loading spinner
        ),
      );
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Pembayaran Tiket")),
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
                        'judul',
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
                            "Rp.${widget.kajian.price}",
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
                        "Detail Pembayaran Tiket",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      // Text(
                      //   "Booking #T2351817303268K9JXU",
                      //   style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      // ),
                      // SizedBox(height: 16),
                      Text(
                        "Tanggal Booking : ${DateFormat('EEEE, d MMM yyyy', 'id_ID').format(DateTime.now())}",
                        // "Tanggal Booking : Kamis, 8/Agustus/2024 Pukul 19:46 WIB",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Tanggal Event Dimulai : ${widget.kajian.date}",
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
                        "Nama : ${user?.first_name ?? 'Unknown'} ${user?.last_name ?? 'Unknown'}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Email :  ${user!.email ?? 'Unknown'}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "No. Handphone : 08123456676",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Tanggal Lahir : 2003-09-27",
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
                        "Event :  ${widget.kajian.title}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Total Pembayaran : Rp.156.450",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Metode Pembayaran : s",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 320,
                  height: 59,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .brown, // Mengganti 'primary' menjadi 'backgroundColor'
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
                            builder: (context) =>
                                DetailKajianScreen(kajian: widget.kajian!)),
                      );
                    },
                    child: Text(
                      'Bayar Tiket',
                      style: TextStyle(
                        color: Colors.white, // Warna tulisan putih
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
