import 'package:finai_frontend/app/presentation/cubit/permission/permission_cubit.dart';
import 'package:finai_frontend/app/presentation/pages/auth/login_page.dart';
import 'package:finai_frontend/app/presentation/pages/permission/permissions_setup_page.dart';
import 'package:finai_frontend/core/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

/// Modern futuristic welcome screen with soft aesthetic
class ModernWelcomePage extends StatefulWidget {
  const ModernWelcomePage({super.key});

  @override
  State<ModernWelcomePage> createState() => _ModernWelcomePageState();
}

class _ModernWelcomePageState extends State<ModernWelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Smooth gradient background (bagian atas saja)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF6EAD8), // 0% - Beige atas (splash screen)
                  Color(0xFFFAF1E3), // 40% - Beige bawah
                  Color(0xFFFAF1E3), // 55% - Beige bawah
                  Color(0xFFFFFFFF), // 70% - White starts
                  Color(0xFFFFFFFF), // 100% - White (full white for text)
                ],
                stops: [0.0, 0.4, 0.55, 0.7, 1.0],
              ),
            ),
          ),

          // SVG blob decoration (top area only)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Opacity(
              opacity: 0.7,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: 2,
                    sigmaY: 2,
                  ),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      const Color(0xFF6366F1), // Biru ungu
                      BlendMode.modulate,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/circle.svg',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // Center visual with floating icons
                _buildCenterVisual(),

                const SizedBox(height: 60),

                // Headline text
                _buildHeadline(),

                const SizedBox(height: 40),

                // Primary CTA Button
                _buildPrimaryButton(),

                const SizedBox(height: 16),

                // Secondary action
                _buildSecondaryAction(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterVisual() {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Large central circle with subtle glow
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white
                          .withOpacity(0.45 + _glowController.value * 0.15),
                      Colors.white.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.35),
                      blurRadius: 35 + _glowController.value * 15,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              );
            },
          ),

          // Ethereum-style stacked logo (center)
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.95),
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const _EthereumLogo(),
          ),

          // Floating crypto/finance themed icons - each with unique position
          // Top-left area
          _buildFloatingIcon(
            size: size,
            percentX: 0.15, // 15% from left
            percentY: 0.08, // 8% from top
            icon: Icons.currency_bitcoin,
            iconColor: const Color(0xFFF7931A),
            animOffset: 0.0,
          ),

          // Top-right area
          _buildFloatingIcon(
            size: size,
            percentX: 0.82, // 82% from left (18% from right)
            percentY: 0.10, // 10% from top
            icon: Icons.local_fire_department,
            iconColor: const Color(0xFFFF6B6B),
            animOffset: 0.5,
          ),

          // Right-middle area
          _buildFloatingIcon(
            size: size,
            percentX: 0.88, // 88% from left
            percentY: 0.28, // 28% from top
            icon: Icons.swap_horiz,
            iconColor: const Color(0xFF4ECDC4),
            animOffset: 1.0,
          ),

          // Bottom-right area
          _buildFloatingIcon(
            size: size,
            percentX: 0.75, // 75% from left
            percentY: 0.40, // 40% from top
            icon: Icons.trending_up,
            iconColor: const Color(0xFF95E1D3),
            animOffset: 1.5,
          ),

          // Left-middle area
          _buildFloatingIcon(
            size: size,
            percentX: 0.08, // 8% from left
            percentY: 0.22, // 22% from top
            icon: Icons.account_balance_wallet,
            iconColor: const Color(0xFFF38181),
            animOffset: 2.0,
          ),

          // Bottom-left area
          _buildFloatingIcon(
            size: size,
            percentX: 0.18, // 18% from left
            percentY: 0.38, // 38% from top
            icon: Icons.analytics_outlined,
            iconColor: const Color(0xFFA8E6CF),
            animOffset: 2.5,
          ),

          // Far-right area
          _buildFloatingIcon(
            size: size,
            percentX: 0.92, // 92% from left
            percentY: 0.18, // 18% from top
            icon: Icons.credit_card,
            iconColor: const Color(0xFFDDA0DD),
            animOffset: 3.0,
          ),

          // Far-left area
          _buildFloatingIcon(
            size: size,
            percentX: 0.05, // 5% from left
            percentY: 0.32, // 32% from top
            icon: Icons.diamond,
            iconColor: const Color(0xFFB4C5E4),
            animOffset: 3.5,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon({
    required Size size,
    required double percentX,
    required double percentY,
    required IconData icon,
    required Color iconColor,
    required double animOffset,
  }) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        // Add subtle floating animation - unique for each icon
        final floatOffset =
            math.sin((animOffset) + _floatController.value * math.pi * 2) * 5;

        // Calculate position based on screen percentage
        final x = size.width * percentX;
        final y = size.height * percentY + floatOffset;

        return Positioned(
          left: x,
          top: y,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.92),
              border: Border.all(
                color: Colors.white.withOpacity(0.9),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeadline() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        'Ambil Alih Kendali Keuanganmu',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          height: 1.4,
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
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to permissions setup page
            NavigationService.pushReplacement(const PermissionsSetupPage());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A2E),
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: const Text(
            'Yuk, Mulai',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryAction() {
    return TextButton(
      onPressed: () {
        // Navigate to login page
        context.read<PermissionCubit>().completePermissionSetup();
        NavigationService.pushReplacement(const LoginPage());
      },
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
          children: [
            TextSpan(text: 'Sudah punya akun? '),
            TextSpan(
              text: 'Masuk',
              style: TextStyle(
                color: Color(0xFF8B5CF6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating icon widget with animation
class _FloatingIcon extends StatelessWidget {
  final Animation<double> animation;
  final double offset;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Widget child;

  const _FloatingIcon({
    required this.animation,
    required this.offset,
    required this.child,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final floatOffset =
            math.sin((animation.value + offset) * math.pi * 2) * 8;
        return Positioned(
          top: top != null ? top! + floatOffset : null,
          bottom: bottom != null ? bottom! - floatOffset : null,
          left: left,
          right: right,
          child: child ?? const SizedBox(),
        );
      },
      child: this.child,
    );
  }
}

/// Ethereum-style logo
class _EthereumLogo extends StatelessWidget {
  const _EthereumLogo();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(40, 40),
      painter: _EthereumPainter(),
    );
  }
}

class _EthereumPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6366F1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);

    // Draw diamond shape (top part)
    path.moveTo(center.dx, center.dy - 15);
    path.lineTo(center.dx + 12, center.dy);
    path.lineTo(center.dx, center.dy + 8);
    path.lineTo(center.dx - 12, center.dy);
    path.close();

    canvas.drawPath(path, paint);

    // Bottom part (lines)
    final strokePaint = Paint()
      ..color = const Color(0xFF6366F1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final bottomPath = Path();
    bottomPath.moveTo(center.dx, center.dy + 10);
    bottomPath.lineTo(center.dx, center.dy + 22);
    bottomPath.moveTo(center.dx - 12, center.dy + 12);
    bottomPath.lineTo(center.dx + 12, center.dy + 12);

    canvas.drawPath(bottomPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bitcoin icon
class _BitcoinIcon extends StatelessWidget {
  const _BitcoinIcon();

  @override
  Widget build(BuildContext context) {
    return _IconContainer(
      child: CustomPaint(
        size: const Size(24, 24),
        painter: _BitcoinPainter(),
      ),
    );
  }
}

class _BitcoinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF7931A)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Circle
    canvas.drawCircle(center, 12, paint);

    // B symbol
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '₿',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Fire icon
class _FireIcon extends StatelessWidget {
  const _FireIcon();

  @override
  Widget build(BuildContext context) {
    return _IconContainer(
      child: Icon(
        Icons.local_fire_department_rounded,
        size: 24,
        color: const Color(0xFFFF6B6B),
      ),
    );
  }
}

/// Transaction icon
class _TransactionIcon extends StatelessWidget {
  const _TransactionIcon();

  @override
  Widget build(BuildContext context) {
    return _IconContainer(
      child: Icon(
        Icons.swap_horiz_rounded,
        size: 24,
        color: const Color(0xFF4ECDC4),
      ),
    );
  }
}

/// Chart icon
class _ChartIcon extends StatelessWidget {
  const _ChartIcon();

  @override
  Widget build(BuildContext context) {
    return _IconContainer(
      child: Icon(
        Icons.show_chart_rounded,
        size: 24,
        color: const Color(0xFF95E1D3),
      ),
    );
  }
}

/// Wallet icon
class _WalletIcon extends StatelessWidget {
  const _WalletIcon();

  @override
  Widget build(BuildContext context) {
    return _IconContainer(
      child: Icon(
        Icons.account_balance_wallet_rounded,
        size: 24,
        color: const Color(0xFFF38181),
      ),
    );
  }
}

/// Icon container with styling
class _IconContainer extends StatelessWidget {
  final Widget child;

  const _IconContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.8),
        border: Border.all(
          color: Colors.white.withOpacity(0.9),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}
