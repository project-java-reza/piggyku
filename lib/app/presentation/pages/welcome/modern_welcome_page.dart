import 'package:finai_frontend/app/presentation/cubit/permission/permission_cubit.dart';
import 'package:finai_frontend/app/presentation/pages/auth/login_page.dart';
import 'package:finai_frontend/app/presentation/pages/permission/permissions_setup_page.dart';
import 'package:finai_frontend/core/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class ModernWelcomePage extends StatefulWidget {
  const ModernWelcomePage({super.key});

  @override
  State<ModernWelcomePage> createState() => _ModernWelcomePageState();
}

class _ModernWelcomePageState extends State<ModernWelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _glowController;
  late AnimationController _pigController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pigController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    _pigController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF6EAD8),
                  Color(0xFFFAF1E3),
                  Color(0xFFFFFFFF),
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
          ),

          // Dekorasi Lingkaran SVG - Diperbaiki agar tidak terpotong
          Positioned(
            top: 60, // Sedikit keluar layar atas untuk estetika
            left: 0,
            right: 0,
            // Tinggi ditingkatkan agar lingkaran utuh terlihat
            height: MediaQuery.of(context).size.height * 0.6,
            child: Opacity(
              opacity: 0.6,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFF6366F1),
                  BlendMode.modulate,
                ),
                child: SvgPicture.asset(
                  'assets/icons/circle.svg',
                  fit: BoxFit.contain, // Menggunakan contain agar gambar utuh
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),

          // Konten Utama
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10), // Kurangi jarak atas
                _buildCenterVisual(),

                const Spacer(
                    flex:
                        1), // Flex kecil agar teks headline tidak terdorong keluar layar

                _buildHeadline(),
                const SizedBox(height: 30),
                _buildPrimaryButton(),
                const SizedBox(height: 16),
                _buildSecondaryAction(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterVisual() {
    const double visualAreaHeight =
        450.0; // Tinggi ditingkatkan agar ruang gerak ke bawah lebih luas

    return SizedBox(
      height: visualAreaHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // --- KARAKTER BABI (PIG) DITURUNKAN ---
          Positioned(
            top:
                160, // Mengatur Pig agar lebih turun (sebelumnya di tengah/atas)
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildGlowEffect(),
                  _buildPigCharacter(),
                ],
              ),
            ),
          ),

          // --- IKON-IKON ---

          // Dollar (Kanan - Sangat Bawah)
          _buildFloatingIcon(
            containerHeight: visualAreaHeight,
            percentX: 0.78,
            percentY: 0.70, // Nilai besar agar sangat bawah
            icon: Icons.attach_money_rounded,
            iconColor: const Color(0xFFF7931A),
            animOffset: 1.5,
          ),

          // Payments (Kanan - Tengah)
          _buildFloatingIcon(
            containerHeight: visualAreaHeight,
            percentX: 0.82,
            percentY: 0.25,
            icon: Icons.payments_rounded,
            iconColor: const Color(0xFF4CAF50),
            animOffset: 4.5,
          ),

          // Pie Chart (Tengah - Paling Bawah, di bawah Pig)
          _buildFloatingIcon(
            containerHeight: visualAreaHeight,
            percentX: 0.5,
            percentY: 0.85, // Hampir di dasar area visual
            icon: Icons.pie_chart_rounded,
            iconColor: const Color(0xFF6366F1),
            animOffset: 2.2,
          ),

          // Wallet (Kiri - Tengah)
          _buildFloatingIcon(
            containerHeight: visualAreaHeight,
            percentX: 0.18,
            percentY: 0.25,
            icon: Icons.account_balance_wallet_rounded,
            iconColor: const Color(0xFFF38181),
            animOffset: 0.0,
          ),

          // Coin (Kiri - Bawah)
          _buildFloatingIcon(
            containerHeight: visualAreaHeight,
            percentX: 0.20,
            percentY: 0.80,
            icon: Icons.monetization_on_rounded,
            iconColor: const Color(0xFFFFD700),
            animOffset: 3.0,
          ),
        ],
      ),
    );
  }

  Widget _buildGlowEffect() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(0.5 + _glowController.value * 0.2),
                Colors.transparent,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPigCharacter() {
    return Container(
      width: 135,
      height: 135,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomPaint(
          painter: PigCoolPainter(progress: _pigController.value),
        ),
      ),
    );
  }

  Widget _buildFloatingIcon({
    required double containerHeight,
    required double percentX,
    required double percentY,
    required IconData icon,
    required Color iconColor,
    required double animOffset,
  }) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final floatEffect =
            math.sin((animOffset) + _floatController.value * math.pi * 2) * 12;

        return Positioned(
          left: MediaQuery.of(context).size.width * percentX - 26,
          top: containerHeight * percentY + floatEffect,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
        );
      },
    );
  }

  Widget _buildHeadline() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        'Ambil Alih Kendali Keuanganmu',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          height: 1.2,
          color: Color(0xFF1A1A2E),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () =>
              NavigationService.pushReplacement(const PermissionsSetupPage()),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A2E),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
          child: const Text('Yuk, Mulai',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildSecondaryAction() {
    return TextButton(
      onPressed: () {
        context.read<PermissionCubit>().completePermissionSetup();
        NavigationService.pushReplacement(const LoginPage());
      },
      child: RichText(
        text: const TextSpan(
          style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
          children: [
            TextSpan(text: 'Sudah punya akun? '),
            TextSpan(
                text: 'Masuk',
                style: TextStyle(
                    color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class PigCoolPainter extends CustomPainter {
  final double progress;
  PigCoolPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const pinkBase = Color(0xFFFFB6C1);
    const pinkBorder = Color(0xFF8B2E4E);
    const pinkSnout = Color(0xFFF080A0);
    const glassColor = Color(0xFF1A1A2E);

    final borderPaint = Paint()
      ..color = pinkBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final fillPaint = Paint()
      ..color = pinkBase
      ..style = PaintingStyle.fill;

    // Telinga
    Path leftEar = Path()
      ..moveTo(center.dx - radius * 0.4, center.dy - radius * 0.5)
      ..quadraticBezierTo(center.dx - radius * 0.7, center.dy - radius * 0.9,
          center.dx - radius * 0.1, center.dy - radius * 0.7);
    canvas.drawPath(leftEar, fillPaint);
    canvas.drawPath(leftEar, borderPaint);

    Path rightEar = Path()
      ..moveTo(center.dx + radius * 0.4, center.dy - radius * 0.5)
      ..quadraticBezierTo(center.dx + radius * 0.7, center.dy - radius * 0.9,
          center.dx + radius * 0.1, center.dy - radius * 0.7);
    canvas.drawPath(rightEar, fillPaint);
    canvas.drawPath(rightEar, borderPaint);

    // Wajah
    canvas.drawCircle(center, radius * 0.8, fillPaint);
    canvas.drawCircle(center, radius * 0.8, borderPaint);

    // Kacamata
    final glassPaint = Paint()..color = glassColor;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center:
                    Offset(center.dx - radius * 0.35, center.dy - radius * 0.1),
                width: radius * 0.5,
                height: radius * 0.3),
            const Radius.circular(6)),
        glassPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center:
                    Offset(center.dx + radius * 0.35, center.dy - radius * 0.1),
                width: radius * 0.5,
                height: radius * 0.3),
            const Radius.circular(6)),
        glassPaint);
    canvas.drawLine(
        Offset(center.dx - 5, center.dy - radius * 0.1),
        Offset(center.dx + 5, center.dy - radius * 0.1),
        Paint()
          ..color = glassColor
          ..strokeWidth = 3);

    // Hidung
    final snoutRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.25),
        width: radius * 0.45,
        height: radius * 0.3);
    canvas.drawOval(snoutRect, Paint()..color = pinkSnout);
    canvas.drawOval(snoutRect, borderPaint..strokeWidth = 1.5);
    canvas.drawCircle(
        Offset(center.dx - 6, center.dy + radius * 0.25), 2.5, borderPaint);
    canvas.drawCircle(
        Offset(center.dx + 6, center.dy + radius * 0.25), 2.5, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
