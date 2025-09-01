import 'package:flutter/material.dart';
import 'package:flutter_samples/supabase/models/materi_model.dart';
import 'package:flutter_samples/ui/components/hcard.dart';
import 'package:flutter_samples/ui/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<MateriModel> allCourses = [];

  String query = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCourse();
  }

  Future<void> _fetchCourse() async {
    final res = await Supabase.instance.client.from('materi').select();
    final data = res.map((e) => MateriModel.fromMap(e)).toList();
    if (mounted) setState(() => allCourses = data);
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        allCourses
            .where(
              (c) =>
                  c.title.toLowerCase().contains(query.toLowerCase()) ||
                  c.subTitle.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    return Scaffold(
      backgroundColor: RiveAppTheme.background2,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: RiveAppTheme.background,
            borderRadius: BorderRadius.circular(30),
          ),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // TextField pencarian
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search, color: Colors.grey),
                      hintText: "Search materials...",
                      hintStyle: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Daftar materi hasil pencarian
                Expanded(
                  child:
                      filtered.isEmpty
                          ? const Center(
                            child: Text(
                              "Tidak ada materi yang sesuai",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                          : ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: filtered.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 16),
                            itemBuilder: (_, index) {
                              return HCard(recent: filtered[index]);
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi tile materi
  Widget _buildBabTile(
    String bab,
    String desc,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Row(
          children: [
            Text(
              bab,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 14),
            Container(width: 2, height: 50, color: Colors.white54),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                desc,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
