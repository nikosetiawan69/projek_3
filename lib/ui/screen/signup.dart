// Mengimpor package material dari Flutter untuk widget Material Design
import 'package:flutter/material.dart';

import '../../supabase/service/auth_service.dart';
// Mengimpor widget RiveAppHome dari file home.dart

// Widget utama untuk halaman awal aplikasi (Get Started)
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

// State untuk SignUpPage, mengelola UI halaman awal
class _SignUpPageState extends State<SignUpPage> {
  final authService = AuthService();

  bool obscurePassword = true;
  bool confirmobscurePassword = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  void signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmpasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password don't match")));
      return;
    }

    try {
      await authService.signUpWithEmailPassword(email, password);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body utama menggunakan Container sebagai wrapper
      body: Container(
        // Mengatur lebar container agar memenuhi layar
        width: double.infinity,
        // Menambahkan gambar latar belakang
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/samples/images/bgawal.png',
            ), // Gambar latar belakang
            fit: BoxFit.cover, // Gambar menyesuaikan lebar layar
          ),
        ),
        // Menempatkan konten di tengah secara vertikal dan horizontal
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment
                    .center, // Menyusun anak secara vertikal di tengah
            children: [
              // Logo aplikasi
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset(
                  'assets/samples/images/topi.png',
                ), // Gambar logo topi
              ),
              // Teks judul aplikasi
              const Text(
                'SkillUp!',
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: "Poppins", // Font kustom
                  fontWeight: FontWeight.bold, // Tebal
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20), // Jarak antar elemen
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFD3D3D3),
                        hintText: 'Username',
                        hintStyle: const TextStyle(color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 23, // Tinggi lebih besar di sini
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Email tidak boleh kosong'
                                  : !RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)
                                  ? 'Format email tidak valid'
                                  : null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFD3D3D3),
                        hintText: 'Gmail',
                        hintStyle: const TextStyle(color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 23,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            behavior:
                                HitTestBehavior
                                    .translucent, // area klik sesuai padding
                            onTap: () {
                              setState(
                                () => obscurePassword = !obscurePassword,
                              );
                            },
                            child: Icon(
                              obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.black,
                              size: 22, // ukuran ikon
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFD3D3D3),
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 23,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _confirmpasswordController,
                      obscureText: confirmobscurePassword,
                      decoration: InputDecoration(
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: GestureDetector(
                            behavior:
                                HitTestBehavior
                                    .translucent, // area klik sesuai padding
                            onTap: () {
                              setState(
                                () =>
                                    confirmobscurePassword =
                                        !confirmobscurePassword,
                              );
                            },
                            child: Icon(
                              confirmobscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.black,
                              size: 22, // ukuran ikon
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFD3D3D3),
                        hintText: 'Confirm Password',
                        hintStyle: const TextStyle(color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 23,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Tombol untuk memulai aplikasi
              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  // Dekorasi tombol dengan gradien
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF4B5EAA),
                        Color(0xFF8A4AF3),
                      ], // Warna gradien biru ke ungu
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(30), // Sudut membulat
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ), // Padding tombol
                  child: const Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Inter", // Font kustom untuk tombol
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
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
