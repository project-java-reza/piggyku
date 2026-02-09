import 'package:flutter/material.dart';
import 'dart:math' as math;

class PigCoolLoading extends StatefulWidget {
  final double size;

  const PigCoolLoading({super.key, this.size = 250.0});

  @override
  State<PigCoolLoading> createState() => _PigCoolLoadingState();
}

class _PigCoolLoadingState extends State<PigCoolLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Durasi satu siklus makan koin
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gambar babi dengan animasi
            Transform.translate(
              offset: Offset(0, math.sin(_controller.value * 2 * math.pi) * 10),
              child: Opacity(
                opacity: 0.8 + 0.2 * math.sin(_controller.value * 2 * math.pi),
                child: Image.asset(
                  'assets/images/pig-loading.png',
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "MENGUMPULKAN CUAN...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF8B4D60),
                letterSpacing: 2,
              ),
            ),
          ],
        );
      },
    );
  }
}
