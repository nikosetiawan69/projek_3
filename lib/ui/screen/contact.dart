import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        backgroundColor: Colors.lightBlue.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We'd love to hear from you!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "If you have any questions, feedback, or suggestions, feel free to reach out to us.",
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text("Email"),
              subtitle: const Text("support@example.com"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Opening email app...")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: const Text("Phone"),
              subtitle: const Text("+62 812-3456-7890"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Calling support...")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.blue),
              title: const Text("Address"),
              subtitle: const Text("Jl. Sudirman No. 123, Jakarta, Indonesia"),
            ),
          ],
        ),
      ),
    );
  }
}
