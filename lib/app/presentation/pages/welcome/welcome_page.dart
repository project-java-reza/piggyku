import 'package:finai_frontend/app/presentation/cubit/permission/permission_cubit.dart';
import 'package:finai_frontend/app/presentation/pages/auth/login_page.dart';
import 'package:finai_frontend/app/presentation/pages/permission/permissions_setup_page.dart';
import 'package:finai_frontend/design/design.dart';
import 'package:finai_frontend/core/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Welcome page shown on first app launch
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.allXL,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon with animation
                  _buildAppIcon(),

                  const VGap(AppSpacing.xxl),

                  // Welcome Text
                  _buildWelcomeText(),

                  const VGap(AppSpacing.xxxl),

                  // Action Buttons
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppIcon() {
    return Hero(
        tag: 'app_icon',
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            size: 80,
            color: AppColors.primary,
          ),
        ));
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        // Main Title
        const Text(
          'Selamat datang.',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const VGap.lg(),

        // Subtitle 1
        Text(
          'Mulai perjalananmu di sini.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withOpacity(0.95),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const VGap.md(),

        // Subtitle 2
        Text(
          'Halo, siap memulai?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const VGap.md(),

        // Subtitle 3
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppRadius.xxl),
          ),
          child: Text(
            'Tempat semua dimulai.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Get Started Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to permissions setup page
              NavigationService.pushReplacement(const PermissionsSetupPage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 0,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rocket_launch, size: 22),
                HGap.md(),
                Text(
                  'Memulai',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        const VGap(AppSpacing.lg + AppSpacing.sm),

        // Divider with text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.white.withOpacity(0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'ATAU',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.white.withOpacity(0.3),
                thickness: 1,
              ),
            ),
          ],
        ),

        const VGap(AppSpacing.lg + AppSpacing.sm),

        // Login Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              // Navigate to login page and mark first launch as completed
              context.read<PermissionCubit>().completePermissionSetup();
              NavigationService.pushReplacement(const LoginPage());
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(
                color: Colors.white.withOpacity(0.7),
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login, size: 22),
                HGap.md(),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        const VGap.xl(),

        // Skip text
        GestureDetector(
          onTap: () {
            // Mark first launch as completed and go to login
            context.read<PermissionCubit>().completePermissionSetup();
            NavigationService.pushReplacement(const LoginPage());
          },
          child: Text(
            'Lewati untuk sekarang',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
