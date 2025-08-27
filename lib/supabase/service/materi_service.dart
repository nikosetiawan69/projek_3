import 'package:flutter/widgets.dart';
import 'package:flutter_samples/supabase/models/materi_model.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:cross_file/cross_file.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

class MateriService {
  final _client = Supabase.instance.client;

  Future createMateri(MateriModel newMateri) async {
    await _client.from('materi').insert({
      ...newMateri.toInsertMap(),
      'created_by': _client.auth.currentUser!.id,
    });
  }

  final stream = Supabase.instance.client
      .from('materi')
      .stream(primaryKey: ['id'])
      .map((data) => data.map(((materiMap) => MateriModel.fromMap(materiMap))));

  Future<void> createMateriWithImage({
    required String title,
    required String content,
    required XFile imagePath,
    required String videoUrl,
    required String subTitle,
  }) async {
    final imageUrl = await _uploadImage(imagePath);
    final model = MateriModel(
      title: title,
      content: content,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      subTitle: subTitle,
    );
    await createMateri(model);
  }

  Future<void> updateMateri(
    MateriModel oldMateri,
    String newTitle,
    String newContent,
    String newImageUrl,
    String newVideoUrl,
    String newsubTitle,
  ) async {
    await _client
        .from('materi')
        .update({
          'title': newTitle,
          'content': newContent,
          'image_url': newImageUrl,
          'video_url': newVideoUrl,
          'subtitle': newsubTitle,
        })
        .eq('id', oldMateri.id!);
  }

  Future<void> updateMateriWithImage({
    required MateriModel current,
    required String newTitle,
    required String newContent,
    required String newVideoUrl,
    required String newSubTitle,
    XFile? newImageFile,
    String? currentImageUrl,
  }) async {
    String finalImageUrl = currentImageUrl ?? current.imageUrl;

    if (newImageFile != null) {
      // hapus gambar lama
      await deleteImageFromStorage(current.imageUrl);
      // upload gambar baru
      finalImageUrl = await _uploadImage(newImageFile);
    }

    await _client
        .from('materi')
        .update({
          'title': newTitle,
          'content': newContent,
          'image_url': finalImageUrl,
          'video_url': newVideoUrl,
          'subtitle': newSubTitle,
        })
        .eq('id', current.id!);
  }

  Future<void> deleteImageFromStorage(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl);

      final fileName = uri.path.split('/').last;

      final userId = _client.auth.currentUser!.id;

      await _client.storage
          .from('image_course')
          .remove(['$userId/$fileName'])
          .catchError((_) {
            return _client.storage.from('image_course').remove([fileName]);
          });
    } catch (e) {}
  }

  Future deleteMateri(MateriModel materi) async {
    await _client.from('materi').delete().eq('id', materi.id!);
    await deleteImageFromStorage(materi.imageUrl);
  }

  Future<String> _uploadImage(XFile file) async {
    final bytes = await file.readAsBytes();
    final userId = _client.auth.currentUser!.id;
    final fileName =
        '$userId/${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}';

    await _client.storage
        .from('image_course')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from('image_course').getPublicUrl(fileName);
  }
}
