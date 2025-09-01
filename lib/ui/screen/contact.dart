import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactItems = [
      {
        "icon": Icons.email_outlined, // ikon email
        "title": "Email",
        "subtitle": "support@example.com",
        "message": "Opening email app..."
      },
      {
        "icon": Icons.phone_in_talk_outlined, // ikon telepon
        "title": "Phone",
        "subtitle": "+62 812-3456-7890",
        "message": "Calling support..."
      },
      {
        "icon": Icons.location_on_outlined, // ikon lokasi
        "title": "Address",
        "subtitle": "Jl. Sudirman No. 123, Jakarta, Indonesia",
        "message": ""
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Us",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: "Poppins",
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We'd love to hear from you! 👋",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "If you have any questions, feedback, or suggestions, feel free to reach out to us anytime.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: "Poppins",
              ),
            ),
            const SizedBox(height: 30),

            // Contact Info Cards
            ...contactItems.map((item) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.lightBlue.shade100,
                    child: Icon(item["icon"] as IconData, color: Colors.blue),
                  ),
                  title: Text(
                    item["title"] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: "Poppins",
                    ),
                  ),
                  subtitle: Text(
                    item["subtitle"] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                    ),
                  ),
                  onTap: () {
                    if ((item["message"] as String).isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(item["message"] as String)),
                      );
                    }
                  },
                ),
              );
            }).toList(),

            const SizedBox(height: 30),

            // Footer
            Center(
              child: Text(
                "© 2025 Your Company. All rights reserved.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontFamily: "Poppins",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
