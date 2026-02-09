import 'dart:math' as math;

import 'package:finai_frontend/app/presentation/cubit/auth/auth_state.dart';
import 'package:finai_frontend/app/presentation/pages/home/dashboard_page.dart';
import 'package:finai_frontend/app/presentation/pages/auth/login_page.dart';
import 'package:finai_frontend/app/presentation/pages/welcome/modern_welcome_page.dart';
import 'package:finai_frontend/app/presentation/cubit/permission/permission_cubit.dart';
import 'package:finai_frontend/app/presentation/cubit/permission/permission_state.dart';
import 'package:finai_frontend/core/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auth/auth_cubit.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    // Setup rotation animation for loading indicator
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Check first launch and authentication status when splash screen loads
    _checkAppStatus();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _checkAppStatus() async {
    // Add small delay for better UX
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      context.read<PermissionCubit>().checkFirstLaunch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermissionCubit, PermissionState>(
      listener: (context, permissionState) {
        print('🔍 PermissionState: $permissionState');

        if (permissionState is FirstLaunchCheck) {
          print('✅ FirstLaunchCheck: ${permissionState.isFirstLaunch}');

          // First launch checked, now navigate accordingly
          if (permissionState.isFirstLaunch) {
            // Show welcome page for first time users
            print('🚀 Navigating to WelcomePage');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              NavigationService.pushReplacement(const ModernWelcomePage());
            });
          } else {
            // Not first launch, check auth status
            print('🔐 Not first launch, checking auth status');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<AuthCubit>().checkAuthStatus();
            });
          }
        }
      },
      builder: (context, permissionState) {
        return BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            print('🔐 AuthState: $state');

            if (state is LoginSuccess) {
              // User is logged in, navigate to dashboard
              print('🏠 Navigating to DashboardPage');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                NavigationService.pushReplacement(const DashboardPage());
              });
            } else if (state is AuthInitial) {
              // User is not logged in, navigate to login
              print('🔑 Navigating to LoginPage');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                NavigationService.pushReplacement(const LoginPage());
              });
            }
          },
          child: Scaffold(
            body: Stack(
              children: [
                // Background gradient vertikal - 80% atas, 20% bawah
                _buildBackground(),

                // Content layer dengan positioning dinamis
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final screenHeight = constraints.maxHeight;

                      return Stack(
                        children: [
                          // Loading indicator - atas-tengah (25% dari tinggi)
                          Positioned(
                            top: screenHeight * 0.25 - 30, // Center vertical
                            left: 0,
                            right: 0,
                            child: Center(
                              child: _buildLoadingIndicator(),
                            ),
                          ),

                          // Avatar babi di tengah transisi (80% dari tinggi layar)
                          Positioned(
                            top: screenHeight * 0.80 - 30,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: _buildPigAvatarInline(),
                            ),
                          ),

                          // Loading text - di bawah babi (87% dari tinggi)
                          Positioned(
                            top: screenHeight * 0.87,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: _buildLoadingText(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackground() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;

        return Stack(
          children: [
            // 80% atas - #FCF0DF
            Container(
              height: screenHeight * 0.8,
              width: double.infinity,
              color: const Color(0xFFFCF0DF),
            ),

            // 20% bawah - #F7E9D3 dengan overlap untuk transisi halus
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height:
                  screenHeight * 0.22, // Sedikit overlap untuk transisi halus
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFCF0DF), // Warna atas untuk transisi
                      Color(0xFFF7E9D3), // Warna bawah
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPigAvatarInline() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          'assets/icons/piggy.png',
          width: 55,
          height: 55,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback jika gambar tidak ada, gunakan emoji babi
            return const Text(
              '🐷',
              style: TextStyle(fontSize: 45),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 60,
      height: 60,
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationController.value * 2 * math.pi,
            child: CustomPaint(
              size: const Size(60, 60),
              painter: _CircularStrokePainter(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingText() {
    return const Text(
      'LOADING…',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 3.0,
        color: Color(0xFF4A5568), // Abu gelap kebiruan
      ),
    );
  }
}

// Custom painter untuk circular stroke minimalis
class _CircularStrokePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final strokePaint = Paint()
      ..color = const Color(0xFF4A5568) // Abu gelap kebiruan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Draw circular stroke dengan gap (270 derajat)
    const startAngle = -math.pi / 4; // Mulai dari atas
    const sweepAngle = 3 * math.pi / 2; // 270 derajat

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
