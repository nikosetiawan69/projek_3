// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
import 'package:flutter_samples/supabase/models/materi_model.dart';
// Mengimpor model data untuk kursus
import 'package:flutter_samples/ui/models/courses.dart';
import 'package:flutter_samples/ui/screen/detailcourse.dart';
import 'package:flutter_samples/ui/assets.dart' as app_assets;

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
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail kursus dengan mengirimkan data kursus
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: widget.course),
          ),
        );
      },
      child: SizedBox(
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
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Konten rata kiri
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
                  Text(
                    "Hello world",
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: "Inter", // Font kustom
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(), // Mengisi ruang kosong di bawah
                ],
              ),
              // Gambar kursus di posisi kanan atas
              Positioned(
                right: -10,
                top: -10,
                child: Image.asset(
                  app_assets.topic_2,
                ), // Gambar dari CourseModel
              ),
            ],
          ),
        ),
      ),
    );
  }
}
