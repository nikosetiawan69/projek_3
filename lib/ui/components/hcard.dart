// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';
import 'package:flutter_samples/supabase/models/materi_model.dart';
// Mengimpor model data untuk kursus
import 'package:flutter_samples/ui/screen/detailcourse.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final user = Supabase.instance.client.auth.currentUser;

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
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          maxLines: 1, // <= batasi baris
                          overflow: TextOverflow.ellipsis,
                          widget.recent.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: "Poppins", // Font kustom
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8), // Jarak antar teks
                    // Keterangan seksi kursus
                    Text(
                      maxLines: 1, // <= batasi baris
                      overflow: TextOverflow.ellipsis,
                      widget.recent.subTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontFamily: "Inter", // Font kustom
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream:
                          Supabase.instance.client
                              .from('profiles')
                              .stream(primaryKey: ['id'])
                              .eq('id', user!.id) // user.id dari Supabase auth
                              .execute(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                        final username = data['display_name'] ?? "None";

                        return Text(
                          maxLines: 2, // <= batasi baris
                          overflow: TextOverflow.ellipsis,
                          "By $username",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: "Inter",
                          ),
                        );
                      },
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
