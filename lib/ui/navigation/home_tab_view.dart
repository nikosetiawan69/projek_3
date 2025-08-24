import 'package:flutter/material.dart';
import 'package:flutter_samples/supabase/models/materi_model.dart';
// Komponen
import 'package:flutter_samples/ui/components/vcard.dart';
import 'package:flutter_samples/ui/components/hcard.dart';
// Model
import 'package:flutter_samples/ui/models/courses.dart';
// Tema
import 'package:flutter_samples/ui/theme.dart';
// Supabase
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  late final Stream<List<MateriModel>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = Supabase.instance.client
        .from('materi')
        .stream(primaryKey: ['id'])
        .map((data) => data.map(MateriModel.fromMap).toList());
  }

  // Daftar untuk "Recent" → statis
  final List<CourseModel> _courseSections = CourseModel.courseSections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: RiveAppTheme.background,
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 60,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------
              // Bagian Courses (Dinamis)
              // -------------------------------
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Courses",
                  style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                ),
              ),

              StreamBuilder<List<MateriModel>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('Belum ada materi'),
                      ),
                    );
                  }

                  final courses = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          courses
                              .map(
                                (course) => Padding(
                                  key: ValueKey(course.id),
                                  padding: const EdgeInsets.all(10),
                                  child: VCard(course: course),
                                ),
                              )
                              .toList(),
                    ),
                  );
                },
              ),

              // -------------------------------
              // Bagian Recent (Statis)
              // -------------------------------
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Text(
                  "Recent",
                  style: TextStyle(fontSize: 20, fontFamily: "Poppins"),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Wrap(
                  children: List.generate(
                    _courseSections.length,
                    (index) => Container(
                      key: _courseSections[index].id,
                      width:
                          MediaQuery.of(context).size.width > 992
                              ? ((MediaQuery.of(context).size.width - 20) / 2)
                              : MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: HCard(section: _courseSections[index]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
