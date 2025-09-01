import 'package:flutter/widgets.dart';
import 'package:flutter_samples/supabase/models/materi_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p; // untuk ambil nama file saja

/// Class yang menangani semua hal tentang data Materi (tambah, baca, ubah, hapus)
class MateriService {
  // Client Supabase, agar bisa berkomunikasi dengan database
  final _client = Supabase.instance.client;

  /* ----------------------------------------------------------
     Fungsi dasar: INSERT (menambah data ke tabel 'materi')
  ---------------------------------------------------------- */

  /// Menyimpan objek MateriModel ke database
  Future createMateri(MateriModel newMateri) async {
    await _client.from('materi').insert({
      // Pecah objek menjadi Map (supaya Supabase mengerti)
      ...newMateri.toInsertMap(),
      // Simpan juga siapa yang membuat materi ini (ambil ID user yg login)
      'created_by': _client.auth.currentUser!.id,
    });
  }

  /* ----------------------------------------------------------
     Fungsi dasar: READ (mendapatkan data secara realtime)
  ---------------------------------------------------------- */

  /// Stream (aliran data terus-menerus) untuk semua materi
  /// Setiap ada perubahan di tabel 'materi', stream ini bakal otomatis update
  final stream = Supabase.instance.client
      .from('materi')
      .stream(primaryKey: ['id'])
      // Konversi setiap baris menjadi objek MateriModel biar mudah dipakai di UI
      .map((data) => data.map(((materiMap) => MateriModel.fromMap(materiMap))));

  /* ----------------------------------------------------------
     Fungsi lengkap: INSERT + upload gambar
  ---------------------------------------------------------- */

  /// Membuat materi baru sekaligus upload gambarnya
  Future<void> createMateriWithImage({
    required String title,
    required String content,
    required XFile imagePath, // XFile berasal dari image_picker
    required String videoUrl,
    required String subTitle,
  }) async {
    // 1. Upload dulu gambarnya, dapatkan link-nya
    final imageUrl = await _uploadImage(imagePath);

    // 2. Buat objek MateriModel dengan link gambar yang sudah di-upload
    final model = MateriModel(
      title: title,
      content: content,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      subTitle: subTitle,
    );

    // 3. Simpan ke database
    await createMateri(model);
  }

  /* ----------------------------------------------------------
     Fungsi dasar: UPDATE (ubah data tanpa gambar)
  ---------------------------------------------------------- */

  /// Update data materi (tanpa mengubah gambar)
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
        .eq('id', oldMateri.id!); // update hanya baris dengan id ini
  }

  /* ----------------------------------------------------------
     Fungsi lengkap: UPDATE + upload gambar baru
  ---------------------------------------------------------- */

  /// Update materi + ganti gambar kalau user memilih gambar baru
  Future<void> updateMateriWithImage({
    required MateriModel current,
    String? newTitle,
    String? newSubTitle,
    String? newContent,
    String? newVideoUrl,
    XFile? newImageFile,
  }) async {
    String? finalImageUrl = current.imageUrl;

    if (newImageFile != null) {
      // 1. Upload foto baru
      final bytes = await newImageFile.readAsBytes();
      final fileExt = newImageFile.path.split('.').last.toLowerCase();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final path = 'materi_images/$fileName';

      await Supabase.instance.client.storage
          .from('your_bucket')
          .uploadBinary(path, bytes);

      // 2. Dapatkan URL publik
      finalImageUrl = Supabase.instance.client.storage
          .from('your_bucket')
          .getPublicUrl(path);

      // 3. Opsional: hapus foto lama
      if (current.imageUrl.isNotEmpty) {
        final oldPath = Uri.parse(current.imageUrl).pathSegments.last;
        await Supabase.instance.client.storage.from('your_bucket').remove([
          oldPath,
        ]);
      }
    }

    // 4. Update row di tabel
    await Supabase.instance.client
        .from('materi')
        .update({
          'title': newTitle ?? current.title,
          'subtitle': newSubTitle ?? current.subTitle,
          'content': newContent ?? current.content,
          'image_url': finalImageUrl ?? '',
          'video_url': newVideoUrl ?? current.videoUrl,
        })
        .eq('id', current.id!);
  }

  /* ----------------------------------------------------------
     Fungsi bantu: Hapus gambar di Supabase Storage
  ---------------------------------------------------------- */

  /// Menghapus file gambar dari penyimpanan Supabase
  Future<void> deleteImageFromStorage(String imageUrl) async {
    try {
      final uri = Uri.parse(imageUrl); // ambil bagian path-nya
      final fileName = uri.path.split('/').last; // nama file saja

      // Folder & nama file diikuti ID user biar rapi
      final userId = _client.auth.currentUser!.id;

      // Coba hapus di path userId/namafile
      await _client.storage.from('image_course').remove(['$userId/$fileName'])
      // Kalau gagal (misalnya file lama tanpa folder userId), coba hapus langsung namafile
      .catchError((_) {
        return _client.storage.from('image_course').remove([fileName]);
      });
    } catch (e) {
      // Jika error, biarkan saja (tidak dianggap fatal)
    }
  }

  /* ----------------------------------------------------------
     Fungsi dasar: DELETE (hapus data + hapus gambarnya)
  ---------------------------------------------------------- */

  /// Menghapus materi dari database sekaligus hapus file gambarnya
  Future deleteMateri(MateriModel materi) async {
    await _client.from('materi').delete().eq('id', materi.id!);
    await deleteImageFromStorage(materi.imageUrl);
  }

  /* ----------------------------------------------------------
     Fungsi privat: Upload gambar ke Supabase Storage
  ---------------------------------------------------------- */

  /// Upload file gambar, lalu kembalikan link publiknya
  Future<String> _uploadImage(XFile file) async {
    // Baca file menjadi bytes
    final bytes = await file.readAsBytes();

    // Nama folder = ID user, nama file = timestamp + nama_asli
    final userId = _client.auth.currentUser!.id;
    final fileName =
        '$userId/${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}';

    // Upload ke bucket 'image_course'
    await _client.storage
        .from('image_course')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(upsert: true), // timpa kalau sudah ada
        );

    // Ambil URL publik supaya bisa dipakai di aplikasi
    return _client.storage.from('image_course').getPublicUrl(fileName);
  }
}
