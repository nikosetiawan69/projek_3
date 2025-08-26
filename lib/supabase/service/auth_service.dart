import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Future<AuthResponse> signUpWithEmailPassword(
  //   String email,
  //   String password,
  // ) async {
  //   return await _supabase.auth.signUp(email: email, password: password);
  // }

  Future<String> signUpWithEmailPasswordGetId(
    String email,
    String password,
  ) async {
    final authRes = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    final userId = authRes.user?.id;

    if (userId == null) {
      throw Exception('Sign-up failed: user ID is null');
    }

    return userId;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  Future<String> getEmailByUsername(String username) async {
    final res =
        await _supabase
            .from('profiles')
            .select('email')
            .eq('username', username)
            .single();
    return res['email'] as String;
  }
}
