import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_samples/supabase/models/materi_model.dart';
import 'package:flutter_samples/supabase/service/materi_service.dart';
import 'package:flutter_samples/ui/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart'
    if (kIsWeb) 'package:flutter_samples/ui/empty_permission.dart';
import 'package:device_info_plus/device_info_plus.dart';

class EditCoursePage extends StatefulWidget {
  const EditCoursePage({super.key, required this.course});
  final MateriModel course;

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _subCtrl;
  late final TextEditingController _contentCtrl;
  late final TextEditingController _imageCtrl;
  late final TextEditingController _videoCtrl;

  dynamic _imageData; // File (mobile) atau Uint8List (web)
  final _imagePicker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.course.title);
    _subCtrl = TextEditingController(text: widget.course.subTitle);
    _contentCtrl = TextEditingController(text: widget.course.content);
    _imageCtrl = TextEditingController(text: widget.course.imageUrl);
    _videoCtrl = TextEditingController(text: widget.course.videoUrl);
  }

  Future<bool> _requestPermission() async {
    PermissionStatus status;
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (Platform.isAndroid && androidInfo.version.sdkInt >= 33) {
      status = await Permission.photos.request();
    } else {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final granted = await _requestPermission();
      if (!granted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Izin file ditolak')));
        return;
      }
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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    try {
      final imageFile =
          _imageData == null
              ? null
              : kIsWeb
              ? XFile.fromData(
                _imageData as Uint8List,
                name: 'picked.jpg',
                mimeType: 'image/jpeg',
              )
              : XFile((_imageData as File).path);

      final updated = MateriModel(
        id: widget.course.id,
        title: _titleCtrl.text.trim(),
        subTitle: _subCtrl.text.trim(),
        content: _contentCtrl.text.trim(),
        imageUrl: _imageCtrl.text.trim(),
        videoUrl: _videoCtrl.text.trim(),
      );

      await MateriService().updateMateriWithImage(
        current: widget.course,
        newTitle: _titleCtrl.text.trim(),
        newContent: _contentCtrl.text.trim(),
        newVideoUrl: _videoCtrl.text.trim(),
        newSubTitle: _subCtrl.text.trim(),
        newImageFile:
            _imageData != null
                ? (_imageData is File
                    ? XFile((_imageData as File).path)
                    : XFile.fromData(
                      _imageData as Uint8List,
                      name: 'picked.jpg',
                    ))
                : null,
      );

      if (!mounted) return;
      Navigator.pop(context, updated);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal update: $e')));
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  // ---------- Widget helper (copy-paste langsung) ----------
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

  Widget _input(TextEditingController c, String hint, {int maxLines = 1}) =>
      TextFormField(
        controller: c,
        maxLines: maxLines,
        validator: (v) => v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
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

  Widget _imagePreview() {
    if (_imageData != null) {
      return kIsWeb && _imageData is Uint8List
          ? Image.memory(_imageData as Uint8List, fit: BoxFit.cover)
          : !kIsWeb && _imageData is File
          ? Image.file(_imageData as File, fit: BoxFit.cover)
          : const SizedBox();
    }
    return Center(
      child: Image.network(
        _imageCtrl.text,
        height: 160,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) => const Center(
              child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
            ),
      ),
    );
  }

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
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Edit Materi'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              color: Colors.blue[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label('Course Title'),
                                    _input(_titleCtrl, 'judul...'),
                                    const SizedBox(height: 16),
                                    _label('Course Subtitle'),
                                    _input(_subCtrl, 'sub-judul...'),
                                    const SizedBox(height: 16),
                                    _label('Image Illustration'),
                                    GestureDetector(
                                      onTap: _pickImage,
                                      child: Container(
                                        height: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: _imagePreview(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _label('Video Material'),
                                    _input(_videoCtrl, 'embed link'),
                                    const SizedBox(height: 16),
                                    _label('Content'),
                                    _input(
                                      _contentCtrl,
                                      'isi materi...',
                                      maxLines: 7,
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isUploading ? null : _submit,
                          child:
                              _isUploading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text(
                                    'Simpan Perubahan',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
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
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              fontFamily: 'Poppins',
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
    );
  }
}
