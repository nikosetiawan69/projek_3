import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_samples/supabase/models/materi_model.dart';
// Komponen
import 'package:flutter_samples/ui/components/vcard.dart';
import 'package:flutter_samples/ui/components/hcard.dart';
// Model
import 'package:flutter_samples/ui/models/courses.dart';
import 'package:flutter_samples/ui/screen/detailcourse.dart';
// Tema
import 'package:flutter_samples/ui/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Supabase
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  late final Stream<List<MateriModel>> _stream;
  List<MateriModel> _recentCourses = [];

  @override
  void initState() {
    super.initState();
    _stream = Supabase.instance.client
        .from('materi')
        .stream(primaryKey: ['id'])
        .map((data) => data.map(MateriModel.fromMap).toList());

    _stream.listen((currentCourses) {
      final validIds = currentCourses.map((e) => e.id).toSet();
      final filtered =
          _recentCourses.where((c) => validIds.contains(c.id)).toList();
      if (filtered.length != _recentCourses.length) {
        setState(() {
          _recentCourses = filtered;
        });
        _saveRecent();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadRecent();
    });
  }

  Future<void> _loadRecent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getStringList('recent_courses') ?? [];

      final List<MateriModel> loadedCourses = [];

      for (var item in data) {
        try {
          final decoded = jsonDecode(item);
          if (decoded is Map<String, dynamic>) {
            final course = MateriModel.fromMap(decoded);
            if (course.id != null) loadedCourses.add(course);
          }
        } catch (e) {
          debugPrint('Error decoding course: $e');
        }
      }

      final supaClient = Supabase.instance.client;
      final idMateri = await supaClient.from('materi').select('id');
      final validId = idMateri.map((e) => e['id'] as int).toSet();

      final filteredCourses =
          loadedCourses.where((c) => validId.contains(c.id)).toList();

      setState(() {
        _recentCourses = filteredCourses;
      });

      final encoded =
          filteredCourses
              .where((c) => c.id != null)
              .map((c) => jsonEncode(c.toMap()))
              .toList();
      await prefs.setStringList('recent_courses', encoded);
    } catch (e) {
      debugPrint('Error loading recent courses: $e');
    }
  }

  Future<void> _saveRecent() async {
    try {
      final encoded =
          _recentCourses
              .where((c) => c.id != null)
              .map((c) => jsonEncode(c.toMap()))
              .toList();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recent_courses', encoded);
    } catch (e) {
      debugPrint('Error saving recent courses: $e');
    }
  }

  Future<void> _addToRecent(MateriModel course) async {
    final fresh = MateriModel.fromMap(course.toMap());
    _recentCourses.removeWhere((c) => c.id == fresh.id);

    _recentCourses.insert(0, fresh);

    if (_recentCourses.length > 5) {
      _recentCourses = _recentCourses.sublist(0, 5);
    }
    setState(() {});
    await _saveRecent();
  }

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
            top: 60,
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
                                  child: GestureDetector(
                                    onTap: () async {
                                      await _addToRecent(course);
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => CourseDetailPage(
                                                course: course,
                                              ),
                                        ),
                                      );
                                      await _loadRecent();
                                    },
                                    child: Container(
                                      child: VCard(course: course),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  );
                },
              ),

              // -------------------------------
              // Bagian Recent
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
                    _recentCourses.length,
                    (index) => Container(
                      key: ValueKey(_recentCourses[index].id),
                      width:
                          MediaQuery.of(context).size.width > 992
                              ? ((MediaQuery.of(context).size.width - 20) / 2)
                              : MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: HCard(recent: _recentCourses[index]),
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
