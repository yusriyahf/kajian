import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kajian/constant.dart';
import 'package:kajian/models/pembayaran.dart';
import 'package:kajian/models/api_response.dart';
import 'package:kajian/screens/onboard.dart';
import 'package:kajian/services/pembayaran_service.dart';
import 'package:kajian/services/user_service.dart';
// void main() {
//   runApp(DetailPembayaranUser());
// }

class DetailPembayaranUser extends StatefulWidget {
  final Pembayaran? pembayaran;

  DetailPembayaranUser({this.pembayaran});

  @override
  State<DetailPembayaranUser> createState() => _DetailPembayaranUserState();
}

class _DetailPembayaranUserState extends State<DetailPembayaranUser> {
  bool _loading = true;
  void _accPembayaran(int pembayaranId, int kajianId, int userId) async {
    setState(() => _loading = true);

    ApiResponse response = await accPembayaran(pembayaranId, kajianId, userId);

    if (response.error == null) {
      Navigator.of(context).pop(true);
    } else if (response.error == unauthorized) {
      logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => false));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
    setState(() => _loading = false);
  }

  void _tolakPembayaran(int pembayaranId) async {
    // if (!_formKey.currentState!.validate()) return; // Validasi form
    setState(() => _loading = true);

    ApiResponse response = await tolakPembayaran(pembayaranId);

    if (response.error == null) {
      Navigator.of(context).pop(true);
    } else if (response.error == unauthorized) {
      logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => false));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
    setState(() => _loading = false);
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return "Tanggal tidak tersedia";
    }

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

  String formatCurrency(int price) {
    final formatter = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    print("Building widget with data: ${widget.pembayaran?.kajian?.image}");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(
                  context); // Fungsi untuk kembali ke halaman sebelumnya
            },
          ),
          title: Text("Detail Pembayaran"),
          centerTitle: true,
          backgroundColor: Color(0xFF724820),
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
                      SizedBox(height: 16),
                      Text(
                        "${widget.pembayaran?.kajian?.title}",
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
                            "Rp. ${widget.pembayaran?.kajian?.price}",
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
                        "Tanggal Booking : ${widget.pembayaran!.created_at}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),

                      SizedBox(height: 16),
                      Text(
                        "Tanggal Event Dimulai : ${widget.pembayaran?.kajian?.date}",
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
                        "Nama Depan : ${widget.pembayaran?.user?.first_name} ",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Nama Belakang : ${widget.pembayaran?.user?.last_name} ",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Email : ${widget.pembayaran?.user?.email}",
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
                        "Judul Kajian : ${widget.pembayaran?.kajian?.title}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Total Pembayaran : Rp. ${widget.pembayaran?.kajian?.price}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Metode Pembayaran : DANA",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Status Pembayaran : ${widget.pembayaran?.status}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Bukti Pembayaran",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8), // Beri jarak antara teks dan gambar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.pembayaran?.bukti_pembayaran ??
                              '', // Use an empty string or fallback URL if null
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),

                      SizedBox(height: 30),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text:
                                "Pembayaran ini telah ", // Teks sebelum status
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors
                                  .grey[600], // Warna default untuk teks biasa
                            ),
                            children: [
                              TextSpan(
                                text: "${widget.pembayaran?.status}", // Status
                                style: TextStyle(
                                  color: widget.pembayaran?.status == 'ditolak'
                                      ? Colors.red // Merah jika ditolak
                                      : widget.pembayaran?.status == 'diacc'
                                          ? Colors.green // Hijau jika diacc
                                          : Colors.grey[
                                              600], // Warna default jika status lain
                                ),
                              ),
                              TextSpan(
                                text: ".", // Teks setelah status
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

void showConfirmationDialog(BuildContext context, String title, String message,
    VoidCallback onConfirm) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64),
                        side: BorderSide(color: Colors.brown),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Tidak',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(64),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Iya',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}