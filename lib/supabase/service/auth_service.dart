import 'package:supabase_flutter/supabase_flutter.dart';

/// Class yang menangani semua urusan login, daftar, dan keluar
class AuthService {
  // Membuat objek SupabaseClient agar bisa berkomunikasi dengan database Supabase
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fungsi untuk login dengan email & kata sandi
  /// Mengembalikan data AuthResponse (berisi user, session, dll)
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    // Langsung meneruskan email & password ke Supabase
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Fungsi untuk mendaftar baru
  /// Tidak mengubah cara kerja, hanya mengambil ID user-nya saja
  Future<String> signUpWithEmailPasswordGetId(
    String email,
    String password,
  ) async {
    // 1. Lakukan proses sign-up ke Supabase
    final authRes = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    // 2. Ambil ID user yang baru saja terdaftar
    final userId = authRes.user?.id;

    // 3. Jika ID-nya kosong/null, berarti gagal
    if (userId == null) {
      throw Exception('Sign-up gagal: ID user kosong');
    }

    // 4. Kembalikan ID user-nya supaya bisa dipakai di tempat lain
    return userId;
  }

  /// Fungsi untuk keluar / logout
  Future<void> signOut() async {
    // Tinggal panggil signOut() bawaan Supabase
    await _supabase.auth.signOut();
  }

  /// Fungsi untuk mendapatkan email user yang sedang login
  /// Jika belum login, akan mengembalikan null
  String? getCurrentUserEmail() {
    // Ambil session terkini
    final session = _supabase.auth.currentSession;
    // Dari session, ambil data user-nya
    final user = session?.user;
    // Kembalikan alamat email-nya (bisa null)
    return user?.email;
  }

  /// Fungsi untuk mencari email milik username tertentu
  /// Cocok untuk fitur "lupa email" atau "login pakai username"
  Future<String> getEmailByUsername(String username) async {
    // Query ke tabel 'profiles' untuk mencari baris dengan username yang diminta
    final res =
        await _supabase
            .from('profiles')
            .select('email')
            .eq('username', username) // .eq() = where username == ...
            .maybeSingle(); // Ambil 1 baris saja (bisa null)

    // Jika hasilnya kosong, berarti username tidak ditemukan
    if (res == null) {
      throw Exception('Username tidak ditemukan');
    }

    // Kembalikan email-nya dalam bentuk teks
    return res['email'] as String;
  }
}
