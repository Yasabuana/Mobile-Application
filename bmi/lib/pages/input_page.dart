import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'result_page.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  double _height = 170.0;
  int _weight = 65;
  int _age = 20;
  String _gender = 'Laki-laki';

  Timer? _timer;

  final Color bgDark = const Color(0xFF0A0E21);
  final Color accentNeon = const Color(0xFFDEFF9A);
  final Color glassColor = Colors.white.withOpacity(0.05);

  void _startHolding(VoidCallback onUpdate) {
    onUpdate();
    _timer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      onUpdate();
    });
  }

  void _stopHolding() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Hitung BMI"),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentNeon.withOpacity(0.1),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildGenderCard('Laki-laki', Icons.male_rounded)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildGenderCard('Perempuan', Icons.female_rounded)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildGlassContainer(
                    child: Column(
                      children: [
                        Text("TINGGI BADAN", style: TextStyle(color: Colors.white.withOpacity(0.6), letterSpacing: 1.5)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text("${_height.toInt()}", style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)),
                            const Text("cm", style: TextStyle(color: Colors.white60)),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: accentNeon,
                            inactiveTrackColor: Colors.white24,
                            thumbColor: accentNeon,
                            overlayColor: accentNeon.withOpacity(0.2),
                          ),
                          child: Slider(
                            value: _height,
                            min: 100,
                            max: 220,
                            onChanged: (val) => setState(() => _height = val),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildCounterCard("BERAT (KG)", _weight, (v) => setState(() {
                        if (_weight + v > 0) _weight += v;
                      }))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildCounterCard("UMUR", _age, (v) => setState(() {
                        if (_age + v > 0) _age += v;
                      }))),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildCalculateButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: glassColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildGenderCard(String label, IconData icon) {
    bool isSelected = _gender == label;
    return GestureDetector(
      onTap: () => setState(() => _gender = label),
      child: _buildGlassContainer(
        child: Column(
          children: [
            Icon(icon, size: 50, color: isSelected ? accentNeon : Colors.white38),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white38, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterCard(String label, int value, Function(int) onUpdate) {
    return _buildGlassContainer(
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12, letterSpacing: 1)),
          Text("$value", style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _roundButton(Icons.remove, () => onUpdate(-1)),
              const SizedBox(width: 16),
              _roundButton(Icons.add, () => onUpdate(1)),
            ],
          )
        ],
      ),
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTapDown: (_) => _startHolding(onTap),
      onTapUp: (_) => _stopHolding(),
      onTapCancel: () => _stopHolding(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          final double finalHeight = _height / 100;
          final double bmiResult = _weight / (finalHeight * finalHeight);
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(
                bmi: bmiResult,
                gender: _gender,
                age: _age,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: accentNeon,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
        ),
        child: const Text("HITUNG BMI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.5)),
      ),
    );
  }
}