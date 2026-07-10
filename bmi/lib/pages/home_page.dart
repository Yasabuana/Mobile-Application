import 'package:flutter/material.dart';
import 'input_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color bgDark = const Color(0xFF0A0E21);
  final Color accentNeon = const Color(0xFFDEFF9A);

  // 1. Variabel penampung nama pengguna (default-nya kosong)
  String _userName = ""; 

  // 2. Fungsi untuk memunculkan kotak Edit Nama
  void _editNameDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: _userName);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1D2236),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Pengaturan Akun", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            textCapitalization: TextCapitalization.words, // Otomatis huruf besar di awal kata
            decoration: InputDecoration(
              hintText: "Masukkan namamu...",
              hintStyle: const TextStyle(color: Colors.white38),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: accentNeon.withOpacity(0.5))),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: accentNeon)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentNeon,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Mengubah state _userName dan merender ulang layar
                setState(() {
                  _userName = nameController.text.trim();
                });
                Navigator.pop(context); // Menutup dialog
                Navigator.pop(context); // Menutup bottom sheet profil
              },
              child: const Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // 3. Fungsi Bottom Sheet Profil
  // 3. Fungsi Bottom Sheet Profil (Sudah Anti-Overflow)
  void _showProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // PERBAIKAN 1: Izinkan pop-up menyesuaikan tinggi
      backgroundColor: Colors.transparent, 
      builder: (context) {
        // PERBAIKAN 2: Bungkus dengan SingleChildScrollView
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24, // Mencegah tertutup keyboard
              top: 24, left: 24, right: 24
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1D2236),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Tinggi Column menyesuaikan isinya
              children: [
                Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 30),
                const CircleAvatar(radius: 40, backgroundColor: Colors.white12, child: Icon(Icons.person, size: 40, color: Colors.white)),
                const SizedBox(height: 16),
                
                Text(
                  _userName.isEmpty ? "Pengguna" : _userName, 
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
                ),
                Text("Member Premium", style: TextStyle(color: accentNeon, fontSize: 14)),
                const SizedBox(height: 30),
                
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white70),
                  title: const Text("Pengaturan Akun", style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.edit, color: Colors.white38, size: 16),
                  onTap: () => _editNameDialog(context),
                ),
                ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text("Keluar", style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  // 1. Reset nama kembali jadi kosong
                  setState(() {
                    _userName = "";
                  });
                  
                  // 2. Tutup pop-up
                  Navigator.pop(context);
                  
                  // 3. Munculkan notifikasi palsu
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Berhasil keluar dari akun.'),
                      backgroundColor: Colors.redAccent.withOpacity(0.8),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => _showProfileSheet(context),
              child: const CircleAvatar(
                backgroundColor: Colors.white12,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 4. Logika pengecekan nama di layar utama (Ternary Operator)
            Text(
              _userName.isEmpty ? "Halo, Pengguna! 👋" : "Halo, $_userName! 👋",
              style: TextStyle(color: accentNeon, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "Siap memantau\nkesehatanmu hari ini?",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, height: 1.2, color: Colors.white),
            ),
            const SizedBox(height: 40),
            _buildMenuCard(
              context: context,
              title: "Kalkulator BMI",
              subtitle: "Hitung Indeks Massa Tubuh dasar",
              icon: Icons.accessibility_new_rounded,
              isActive: true,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const InputPage()));
              },
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context: context,
              title: "Kalkulator BMR",
              subtitle: "Metabolisme & Kalori Harian (Segera Hadir)",
              icon: Icons.local_fire_department,
              isActive: false,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Fitur BMR sedang dalam pengembangan!'),
                    backgroundColor: accentNeon.withOpacity(0.2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? accentNeon.withOpacity(0.5) : Colors.transparent),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive ? accentNeon.withOpacity(0.2) : Colors.white12,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isActive ? accentNeon : Colors.grey, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.grey)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: isActive ? accentNeon : Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}