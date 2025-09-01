import 'package:flutter/material.dart';
import 'package:flutter_samples/supabase/service/materi_service.dart';
import 'package:flutter_samples/supabase/models/materi_model.dart';
import 'package:flutter_samples/ui/screen/edit_course_page.dart';
import 'package:flutter_samples/ui/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage({super.key, required this.course});

  final MateriModel course;

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  Future<void> _launchVideo(BuildContext context) async {
    if (widget.course.videoUrl.isEmpty) return; // kalau kosong, abaikan
    final url = Uri.parse(widget.course.videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      ); // buka pakai browser/app eksternal
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch video'),
          ), // notif error
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Container(
      color: RiveAppTheme.background2,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: RiveAppTheme.background,
            borderRadius: BorderRadius.circular(30),
          ),
          clipBehavior: Clip.hardEdge,
          child: Scaffold(
            backgroundColor: RiveAppTheme.background,
            appBar: AppBar(
              title: Text(
                widget.course.title,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: RiveAppTheme.background,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Card gambar
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 10,
                      child: Image.network(
                        widget.course.imageUrl,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (widget.course.videoUrl.isNotEmpty)
                      InkWell(
                        onTap: () => _launchVideo(context),
                        child: Text(
                          widget.course.videoUrl,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    Text(
                      widget.course.subTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        color: Colors.black54,
                      ),
                    ),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: Supabase.instance.client
                          .from('profiles')
                          .stream(primaryKey: ['id'])
                          .eq('id', user!.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading...");
                        }
                        if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          // Fallback ke email jika display_name tidak ada
                          return Text(
                            "By ${user.userMetadata?['full_name'] ?? user.email ?? "No Name"}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                            ),
                          );
                        }

                        final data = snapshot.data!.first;
                        return Text(
                          "By ${data['display_name'] ?? user.email ?? "None"}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontFamily: "Inter",
                          ),
                        );
                      },
                    ),

                    /// Card deskripsi
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.blue,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.course.content,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                    ),

                    /// Tombol aksi
                    const SizedBox(height: 90),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final updated = await Navigator.push<MateriModel>(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          EditCoursePage(course: widget.course),
                                ),
                              );
                              if (updated != null && context.mounted) {
                                Navigator.pop(
                                  context,
                                  updated,
                                ); // balik ke HomeTabView
                              }
                            },
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[500],
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text("Hapus Materi"),
                                      content: const Text(
                                        "Apakah kamu yakin ingin menghapus materi ini?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                              if (confirm != true) return;

                              try {
                                await MateriService().deleteMateri(
                                  widget.course,
                                );

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Materi berhasil di hapus'),
                                  ),
                                );

                                Navigator.pop(context);
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Materi gagal di hapus: $e'),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
