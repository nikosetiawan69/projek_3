import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/home.dart';
import 'package:flutter_samples/ui/theme.dart';
import 'package:flutter_samples/supabase/service/materi_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart'
    if (kIsWeb) 'package:flutter_samples/ui/empty_permission.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final _fromKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _videoController = TextEditingController();
  final _contentController = TextEditingController();
  final _subtitleController = TextEditingController();

  dynamic _imageData;
  final _imagePicker = ImagePicker();
  final _materiTable = MateriService();

  bool _isUpLoading = false;

  Future<bool> _requestPermission() async {
    if (kIsWeb) return true;
    PermissionStatus status;

    // Android 13+
    if (Platform.isAndroid &&
        (await DeviceInfoPlugin().androidInfo).version.sdkInt >= 33) {
      status = await Permission.photos.request();
    } else {
      status = await Permission.storage.request();
    }

    return status.isGranted;
  }

  Future<void> _pickImage() async {
    final granted = await _requestPermission();
    if (!granted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Izin file ditolak')));
      return;
    }
    final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    if (kIsWeb) {
      final bytes = await picked.readAsBytes();
      setState(() => _imageData = bytes);
    } else {
      setState(() => _imageData = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (!_fromKey.currentState!.validate()) return;
    if (_imageData == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: const Text('pilih gambar dulu')));
      return;
    }

    setState(() {
      _isUpLoading = true;
    });

    try {
      final imageFile =
          kIsWeb
              ? XFile.fromData(
                _imageData as Uint8List,
                name: 'picked.jpg',
                mimeType: 'image/jpeg',
              )
              : XFile((_imageData as File).path);

      await _materiTable.createMateriWithImage(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        imagePath: imageFile,
        videoUrl: _videoController.text.trim(),
        subTitle: _subtitleController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      if (mounted) setState(() => _isUpLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _videoController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Widget _imagePreview() {
    if (_imageData == null) {
      return const Center(
        child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
      );
    }

    if (kIsWeb && _imageData is Uint8List) {
      return Center(
        child: Image.memory(_imageData as Uint8List, fit: BoxFit.cover),
      );
    }

    if (!kIsWeb && _imageData is File) {
      return Center(child: Image.file(_imageData as File, fit: BoxFit.cover));
    }
    return const SizedBox();
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
  );

  Widget _input(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) => TextFormField(
    controller: controller,
    maxLines: maxLines,
    validator:
        (value) => value == null || value.trim().isEmpty ? 'Wajib diisi' : null,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(16),
      hintText: hint,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RiveAppTheme.background2,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: RiveAppTheme.background,
            borderRadius: BorderRadius.circular(30),
          ),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Add Courses',
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _fromKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color:
                                Colors
                                    .blue[100], // Latar belakang biru untuk card
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Course Title'),
                                  _input(_titleController, 'courses title...'),
                                  const SizedBox(height: 16),
                                  _label('Course Subtitle'),
                                  _input(
                                    _subtitleController,
                                    'courses subtitle...',
                                  ),
                                  const SizedBox(height: 16),
                                  _label('Image Illustration'),
                                  GestureDetector(
                                    onTap: _pickImage,
                                    child: Container(
                                      height: 160,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: _imagePreview(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _label('Video Material'),
                                  _input(_videoController, 'embed a video'),
                                  const SizedBox(height: 16),
                                  _label('Content of Material'),
                                  _input(
                                    _contentController,
                                    'Content of Material.....',
                                    maxLines: 7,
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[600],
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 25,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: _isUpLoading ? null : _submit,
                                  child:
                                      _isUpLoading
                                          ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                          : const Text(
                                            "Save & Publish",
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 25,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed:
                                      _isUpLoading
                                          ? null
                                          : () => Navigator.pop(context),
                                  child: const Text(
                                    "Cancel",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
