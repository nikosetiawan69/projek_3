import 'package:flutter/material.dart';

class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna latar belakang lembut
      backgroundColor: const Color(0xFFF5FAFF),

      // AppBar dengan warna biru
      appBar: AppBar(
        title: const Text(
          "About This App",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
      ),

      // Isi halaman
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Judul aplikasi + ikon
          Column(
            children: const [
              Icon(Icons.menu_book_rounded,
                  color: Color(0xFF4A90E2), size: 70),
              SizedBox(height: 10),
              Text(
                "Course Learning App",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Deskripsi aplikasi
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Aplikasi ini membantu pelajar belajar kursus "
                "dengan mudah, praktis, dan interaktif. "
                "Belajar jadi lebih menyenangkan dengan fitur modern.",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Judul fitur
          const Text(
            "Key Features",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // Daftar fitur aplikasi
          _buildFeatureTile(
            icon: Icons.school,
            title: "Materi Kursus Lengkap",
            subtitle: "Konten belajar terstruktur dari berbagai topik.",
          ),
          _buildFeatureTile(
            icon: Icons.play_circle_fill,
            title: "Video Pembelajaran",
            subtitle: "Nikmati pembelajaran interaktif melalui video.",
          ),
          const SizedBox(height: 20),

          // Info versi aplikasi
          const Center(
            child: Text(
              "Version 1.0.0",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk item fitur (tile)
  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF4A90E2),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
