// Mengimpor package material dari Flutter untuk menggunakan widget Material Design
import 'package:flutter/material.dart';
import 'package:flutter_samples/supabase/service/auth_gate.dart';
// Mengimpor file getstart.dart yang berisi widget GetStart
import 'package:supabase_flutter/supabase_flutter.dart';

// Fungsi main adalah titik masuk aplikasi Flutter
void main() async {
  await Supabase.initialize(
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3cWFsYnRmY3BudGJwdWxsdWtwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUxNjg2OTgsImV4cCI6MjA3MDc0NDY5OH0.Pg1SYw-2MJTFAXpPu8UNqDHnw47LwaDHmutZCvFwEAU",
    url: "https://ewqalbtfcpntbpullukp.supabase.co",
  );
  // Menjalankan aplikasi dengan widget MyApp sebagai root
  runApp(const MyApp());
}

// MyApp adalah widget Stateless yang menjadi root aplikasi
class MyApp extends StatelessWidget {
  // Konstruktor dengan parameter key opsional
  const MyApp({super.key});

  // Method build mendefinisikan UI aplikasi
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menonaktifkan banner debug di pojok kanan atas
      debugShowCheckedModeBanner: false,
      // Judul aplikasi yang digunakan oleh sistem operasi
      title: 'Flutter Project 2',
      // Mendefinisikan tema aplikasi dengan warna utama biru
      theme: ThemeData(primarySwatch: Colors.blue),
      // Menetapkan GetStart sebagai halaman awal aplikasi
      home: AuthGate(),
    );
  }
}
