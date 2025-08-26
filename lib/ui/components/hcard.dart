// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
import 'package:flutter_samples/supabase/models/materi_model.dart';
// Mengimpor model data untuk kursus
import 'package:flutter_samples/ui/models/courses.dart';
import 'package:flutter_samples/ui/screen/detailcourse.dart';

// Widget untuk kartu kursus horizontal
class HCard extends StatefulWidget {
  const HCard({Key? key, required this.recent}) : super(key: key);

  // Data seksi kursus yang ditampilkan pada kartu
  final MateriModel recent;

  @override
  State<HCard> createState() => _HCardState();
}

class _HCardState extends State<HCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(course: widget.recent),
          ),
        );
      },
      child: SizedBox(
        height: 110,
        child: Container(
          // Padding dalam kartu
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          // Dekorasi kartu dengan warna dari section dan sudut membulat
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blue.withOpacity(0.5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ), // Warna latar belakang dari CourseModel
            borderRadius: BorderRadius.circular(30), // Sudut membulat
          ),
          child: Row(
            children: [
              // Kolom teks yang mengisi ruang tersedia
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Kolom menyesuaikan konten
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Teks rata kiri
                  children: [
                    // Judul seksi kursus
                    Text(
                      widget.recent.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontFamily: "Poppins", // Font kustom
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8), // Jarak antar teks
                    // Keterangan seksi kursus
                    Text(
                      widget.recent.subTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontFamily: "Inter", // Font kustom
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Garis pemisah vertikal
              const Padding(
                padding: EdgeInsets.all(20),
                child: VerticalDivider(thickness: 0.8, width: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
