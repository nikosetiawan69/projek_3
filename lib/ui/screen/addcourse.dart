import 'package:flutter/material.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final titleController = TextEditingController();
  final videoController = TextEditingController();
  final contentController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    videoController.dispose();
    contentController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Palet warna
    const Color primaryBlue = Color(0xFF5A9BD8);
    const Color backgroundBlue = Color(0xFFF5FBFF);

    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        title: const Text(
          'Add Course',
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create New Course 🎓",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Fill in the details below to add a new course for your students.",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Input Fields dalam Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildTextField(
                      controller: titleController,
                      label: "Course Title",
                      icon: Icons.book,
                    ),
                    const SizedBox(height: 12),
                    buildTextField(
                      controller: imageController,
                      label: "Image URL",
                      icon: Icons.image,
                    ),
                    const SizedBox(height: 12),
                    buildTextField(
                      controller: videoController,
                      label: "Video URL",
                      icon: Icons.video_library,
                    ),
                    const SizedBox(height: 12),
                    buildTextField(
                      controller: contentController,
                      label: "Course Content",
                      maxLines: 4,
                      icon: Icons.description,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Save & Cancel
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Course saved & published 🎉",
                            style: TextStyle(fontFamily: "Poppins"),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: const Text(
                      "Save",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: primaryBlue, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.close, color: primaryBlue),
                    label: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: primaryBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Footer
            Center(
              child: Text(
                "© 2025 EduCourse. All rights reserved.",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom TextField Builder biar konsisten
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: "Poppins",
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: "Poppins",
          color: Colors.black54,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF5A9BD8)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
