import 'package:flutter/material.dart';
import 'package:kajian/models/pembayaran.dart';

// void main() {
//   runApp(AdminKonfirmPageDetail());
// }

class AdminKonfirmPageDetail extends StatefulWidget {
  final Pembayaran? pembayaran;

  AdminKonfirmPageDetail({this.pembayaran});

  @override
  State<AdminKonfirmPageDetail> createState() => _AdminKonfirmPageDetailState();
}

class _AdminKonfirmPageDetailState extends State<AdminKonfirmPageDetail> {
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

  @override
  Widget build(BuildContext context) {
    print("Building widget with data: ${widget.pembayaran?.kajian?.image}");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Detail Pembayaran")),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: widget.pembayaran?.kajian?.image != null &&
                                widget.pembayaran!.kajian!.image!.isNotEmpty
                            ? Image.network(
                                widget.pembayaran!.kajian!.image!,
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
                        "Booking #T2351817303268K9JXU",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 16),
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
                        "Nama : ${widget.pembayaran?.user?.first_name} ${widget.pembayaran?.user?.last_name}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Email : ${widget.pembayaran?.user?.email}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "No. Handphone : 08123456676",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "No. Identitas : 35345735483659454",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Tanggal Lahir : 2003-09-27",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Catatan : -",
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
                        "Event : ${widget.pembayaran?.kajian?.title}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Total Pembayaran : Rp. ${widget.pembayaran?.kajian?.price}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Metode Pembayaran : BCAVA",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Status Pembayaran : Dibayar",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Action for Accept button
                              // You can show a dialog or handle your logic here
                              print('Tiket Ditolak');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red, // Green color for accept
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Tolak',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Action for Reject button
                              // You can show a dialog or handle your logic here
                              print('Tiket Diterima');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.green, // Red color for reject
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Acc',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
