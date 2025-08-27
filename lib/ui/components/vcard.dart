// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
import 'package:flutter_samples/supabase/models/materi_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Widget untuk kartu kursus vertikal
class VCard extends StatefulWidget {
  const VCard({super.key, required this.course});

  // Data kursus yang ditampilkan pada kartu
  final MateriModel course;

  @override
  State<VCard> createState() => _VCardState();
}

// State untuk VCard, mengelola tampilan kartu
class _VCardState extends State<VCard> {
  // Daftar avatar (tidak digunakan dalam build saat ini)
  final avatars = [4, 5, 6];

  @override
  void initState() {
    // Mengacak daftar avatar saat inisialisasi
    avatars.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return SizedBox(
      width: 260,
      height: 310,
      child: Container(
        padding: const EdgeInsets.all(30), // Padding dalam kartu
        decoration: BoxDecoration(
          // Gradien warna berdasarkan properti course.color
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blue.withOpacity(0.5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // Efek bayangan untuk tampilan 3D
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(30), // Sudut membulat
        ),
        child: Stack(
          clipBehavior:
              Clip.none, // Memungkinkan elemen keluar dari batas kartu
          children: [
            // Konten utama kartu
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Konten rata kiri
              children: [
                // Judul kursus
                Container(
                  constraints: const BoxConstraints(maxWidth: 170),
                  child: Text(
                    widget.course.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: "Poppins", // Font kustom
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Jarak antar elemen
                // Subjudul kursus dengan pembatasan teks
                Text(
                  widget.course.subTitle, // Subjudul (force unwrap)
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: false,
                  style: TextStyle(
                    color: Colors.white.withOpacity(
                      0.7,
                    ), // Teks dengan opasitas
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8), // Jarak antar elemen
                // Keterangan kursus (uppercase)
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream:
                      Supabase.instance.client
                          .from('profiles')
                          .stream(primaryKey: ['id'])
                          .eq('id', user!.id) // user.id dari Supabase auth
                          .execute(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        "Loading...",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text(
                        "None",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      );
                    }

                    final data = snapshot.data!.first;
                    final username = data['display_name'] ?? "huhuhu";

                    return Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: "Inter",
                      ),
                    );
                  },
                ),

                const Spacer(), // Mengisi ruang kosong di bawah
              ],
            ),
          ],
        ),
      ),
    );
  }
}
