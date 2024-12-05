import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: EditProfile(),
  ));
}

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Edit Profile')),
        backgroundColor: Color(0xFF724820),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage('assets/images/profile.png'),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Colors.white), // Pencil icon for editing
                            onPressed: () {
                              // Add the logic to edit the image
                            },
                            padding:
                                EdgeInsets.all(8), // Adjust padding if needed
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildTextField('First Name', 'Maulita'),
                      _buildTextField('Last Name', 'Yasmin'),
                      _buildTextField('Email', 'maulita@gmail.com'),
                      _buildTextField('No. Handphone', '081234567890'),
                      _buildTextField('Tanggal Lahir', '29/04/2004'),
                      SizedBox(height: 16),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 100), // Adjust padding as needed
                          decoration: BoxDecoration(
                            color: Color(
                                0xFF724820), // Background color of the container
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .transparent, // Make the button background transparent
                              elevation: 0, // Remove button elevation
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      16), // Add vertical padding inside the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Keep rounded corners for the button
                              ),
                            ),
                            child: const Text(
                              'Simpan',
                              style: TextStyle(color: Colors.white),
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
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder,
      {bool verified = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (verified)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    '✔ VERIFIED',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4),
          TextField(
            decoration: InputDecoration(
              hintText: placeholder,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
