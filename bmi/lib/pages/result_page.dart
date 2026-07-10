import 'dart:ui';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final double bmi;
  final String gender;
  final int age;

  const ResultPage({super.key, required this.bmi, required this.gender, required this.age});

  // Warna Tema (Samakan dengan Input Page)
  final Color bgDark = const Color(0xFF0A0E21);
  final Color accentNeon = const Color(0xFFDEFF9A);

  // Logika Kategori
  String getResultCategory() {
    if (bmi >= 25) return 'OVERWEIGHT';
    if (bmi > 18.5) return 'NORMAL';
    return 'UNDERWEIGHT';
  }

  Color getCategoryColor() {
    if (bmi >= 25) return Colors.redAccent;
    if (bmi > 18.5) return accentNeon;
    return Colors.orangeAccent;
  }

  // Konten Edukasi Dinamis berdasarkan Kategori BMI
  List<Map<String, dynamic>> getEducationData() {
    if (bmi >= 25) {
      return [
        {'icon': Icons.local_fire_department, 'title': 'Defisit Kalori', 'desc': 'Kurangi porsi makan dan hindari camilan manis.'},
        {'icon': Icons.directions_run, 'title': 'Kardio', 'desc': 'Lari, sepeda, atau renang 3-5x seminggu.'},
        {'icon': Icons.water_drop, 'title': 'Hidrasi', 'desc': 'Ganti minuman manis dengan air putih.'},
      ];
    } else if (bmi > 18.5) {
      return [
        {'icon': Icons.restaurant_menu, 'title': 'Pola Makan', 'desc': 'Pertahankan nutrisi seimbang setiap hari.'},
        {'icon': Icons.fitness_center, 'title': 'Olahraga', 'desc': 'Tetap aktif bergerak minimal 30 menit sehari.'},
        {'icon': Icons.nights_stay, 'title': 'Tidur Cukup', 'desc': 'Pastikan tidur 7-8 jam untuk pemulihan.'},
      ];
    } else {
      return [
        {'icon': Icons.set_meal, 'title': 'Surplus Kalori', 'desc': 'Makan lebih sering dengan porsi padat nutrisi.'},
        {'icon': Icons.fitness_center, 'title': 'Angkat Beban', 'desc': 'Fokus bangun massa otot, bukan lemak.'},
        {'icon': Icons.egg_alt, 'title': 'Tinggi Protein', 'desc': 'Perbanyak telur, daging, dan susu.'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final educationData = getEducationData();

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Hasil Analisis", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      // PERBAIKAN OVERFLOW: Menggunakan SingleChildScrollView
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // Efek scroll memantul ala iOS
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- BAGIAN 1: KARTU HASIL UTAMA ---
            _buildGlassContainer(
              child: Column(
                children: [
                  const Text(
                    "SKOR BMI KAMU",
                    style: TextStyle(color: Colors.white54, letterSpacing: 2, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    bmi.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1),
                  ),
                  Text(
                    getResultCategory(),
                    style: TextStyle(color: getCategoryColor(), fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMiniInfo("Gender", gender),
                      _buildMiniInfo("Umur", "$age thn"),
                      _buildMiniInfo("Normal", "18.5 - 24.9"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // --- BAGIAN 2: EDUKASI KESEHATAN ---
            const Text(
              "Langkah Selanjutnya",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            
            // Membuat List Kartu Edukasi secara dinamis
            ListView.builder(
              shrinkWrap: true, // Penting agar ListView bisa jalan di dalam ScrollView
              physics: const NeverScrollableScrollPhysics(), // Scroll mengikuti SingleChildScrollView induk
              itemCount: educationData.length,
              itemBuilder: (context, index) {
                final item = educationData[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildEducationCard(item['icon'], item['title'], item['desc']),
                );
              },
            ),

            const SizedBox(height: 30),

            // --- BAGIAN 3: TOMBOL KEMBALI ---
            SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text("HITUNG ULANG", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BANTUAN ---

  Widget _buildGlassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildMiniInfo(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildEducationCard(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentNeon.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentNeon, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}