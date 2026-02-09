import 'dart:math' as math;

import 'package:finai_frontend/app/presentation/cubit/auth/auth_cubit.dart';
import 'package:finai_frontend/app/presentation/cubit/auth/auth_state.dart';
import 'package:finai_frontend/app/presentation/cubit/permission/permission_cubit.dart';
import 'package:finai_frontend/app/presentation/cubit/permission/permission_state.dart';
import 'package:finai_frontend/app/presentation/pages/auth/login_page.dart';
import 'package:finai_frontend/app/presentation/pages/home/dashboard_page.dart';
import 'package:finai_frontend/design/design.dart';
import 'package:finai_frontend/core/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Permissions setup page shown on first app launch
class PermissionsSetupPage extends StatefulWidget {
  const PermissionsSetupPage({super.key});

  @override
  State<PermissionsSetupPage> createState() => _PermissionsSetupPageState();
}

class _PermissionsSetupPageState extends State<PermissionsSetupPage> {
  @override
  void initState() {
    super.initState();
    // Check current permission status when page loads
    context.read<PermissionCubit>().checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF0DF),
      body: BlocConsumer<PermissionCubit, PermissionState>(
        listener: (context, state) {
          // Handle errors
          if (state is PermissionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PermissionLoading) {
            return const _LoadingView();
          }

          final notificationGranted =
              state is PermissionsLoaded && state.notificationPermissionGranted;
          final alarmGranted =
              state is PermissionsLoaded && state.alarmPermissionGranted;

          return Column(
            children: [
              // Header Section
              Expanded(
                flex: 0,
                child: SafeArea(
                  bottom: false,
                  child: _HeaderSection(
                    notificationGranted: notificationGranted,
                    alarmGranted: alarmGranted,
                  ),
                ),
              ),

              // Permissions List
              Expanded(
                child: _PermissionsList(
                  notificationGranted: notificationGranted,
                  alarmGranted: alarmGranted,
                ),
              ),

              // Bottom Actions
              _BottomActions(
                allGranted: notificationGranted && alarmGranted,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Loading view
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}

/// Header section with icon and title
class _HeaderSection extends StatelessWidget {
  final bool notificationGranted;
  final bool alarmGranted;

  const _HeaderSection({
    required this.notificationGranted,
    required this.alarmGranted,
  });

  @override
  Widget build(BuildContext context) {
    return P(
      v: AppSpacing.lg,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                notificationGranted && alarmGranted
                    ? Icons.check_circle
                    : Icons.security,
                size: 50,
                color: notificationGranted && alarmGranted
                    ? Colors.green
                    : AppColors.primary,
              ),
            ),
            const Gap.lg(),

            // Title
            const Text(
              'Setup Permissions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const Gap.md(),

            // Description
            P(
              h: AppSpacing.xl,
              child: Text(
                'We need some permissions to provide you the best experience',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A5568),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Permissions list
class _PermissionsList extends StatelessWidget {
  final bool notificationGranted;
  final bool alarmGranted;

  const _PermissionsList({
    required this.notificationGranted,
    required this.alarmGranted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xxxl),
          topRight: Radius.circular(AppRadius.xxxl),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.all(AppSpacing.lg),
        children: [
          // Notification Permission Item
          _PermissionItem(
            icon: Icons.notifications_active,
            title: 'Notifications',
            description: 'Get notified about important updates and reminders',
            isGranted: notificationGranted,
            onRequest: () {
              context.read<PermissionCubit>().requestNotificationPermission();
            },
          ),
          const Gap.md(),

          // Alarm Permission Item
          _PermissionItem(
            icon: Icons.alarm,
            title: 'Alarm & Reminder',
            description: 'Set alarms and reminders for your transactions',
            isGranted: alarmGranted,
            onRequest: () {
              context.read<PermissionCubit>().requestAlarmPermission();
            },
          ),
          const Gap.lg(),

          // Info text
          P(
            all: AppSpacing.md,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const HGap.md(),
                  Expanded(
                    child: Text(
                      'You can change these permissions later in app settings',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual permission item
class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isGranted;
  final VoidCallback onRequest;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.isGranted,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return P(
      all: AppSpacing.md,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isGranted ? Colors.green : Colors.grey[300]!,
            width: isGranted ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                icon,
                size: 28,
                color: isGranted ? Colors.green : AppColors.primary,
              ),
            ),
            const HGap.md(),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(AppSpacing.xs),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Status / Button
            isGranted
                ? P(
                    h: AppSpacing.md,
                    v: AppSpacing.sm,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(AppRadius.xxl),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 16),
                          Gap(AppSpacing.xs),
                          Text(
                            'Granted',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : _BrushStrokeButton(
                    onPressed: onRequest,
                    text: 'Allow',
                  ),
          ],
        ),
      ),
    );
  }
}

/// Bottom action buttons
class _BottomActions extends StatelessWidget {
  final bool allGranted;

  const _BottomActions({required this.allGranted});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Continue button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: _BrushStrokeButton(
              onPressed: allGranted
                  ? () {
                      // Mark first launch as completed
                      context
                          .read<PermissionCubit>()
                          .completePermissionSetup();

                      // Navigate based on auth status
                      final authCubit = context.read<AuthCubit>();
                      if (authCubit.state is LoginSuccess) {
                        NavigationService.pushReplacement(const DashboardPage());
                      } else {
                        NavigationService.pushReplacement(const LoginPage());
                      }
                    }
                  : null,
              text: allGranted ? 'Continue' : 'Grant All Permissions',
              isEnabled: allGranted,
            ),
          ),

          // Skip button (optional - shown when not all granted)
          if (!allGranted)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.md),
              child: TextButton(
                onPressed: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Skip Permissions?'),
                      content: const Text(
                        'Some features may not work properly without these permissions. You can enable them later in app settings.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context
                                .read<PermissionCubit>()
                                .completePermissionSetup();

                            final authCubit = context.read<AuthCubit>();
                            if (authCubit.state is LoginSuccess) {
                              NavigationService.pushReplacement(const DashboardPage());
                            } else {
                              NavigationService.pushReplacement(const LoginPage());
                            }
                          },
                          child: const Text('Skip Anyway'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Skip for now',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Brush stroke button with paint effect
class _BrushStrokeButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isEnabled;

  const _BrushStrokeButton({
    required this.onPressed,
    required this.text,
    this.isEnabled = true,
  });

  @override
  State<_BrushStrokeButton> createState() => _BrushStrokeButtonState();
}

class _BrushStrokeButtonState extends State<_BrushStrokeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;

    return GestureDetector(
      onTapDown: isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = true);
            },
      onTapUp: isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            },
      onTapCancel: isDisabled
          ? null
          : () {
              setState(() => _isPressed = false);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        child: CustomPaint(
          painter: _BrushStrokePainter(
            isPressed: _isPressed,
            isDisabled: isDisabled,
          ),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDisabled ? Colors.grey[400] : const Color(0xFF1A1A2E),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for brush stroke effect
class _BrushStrokePainter extends CustomPainter {
  final bool isPressed;
  final bool isDisabled;

  _BrushStrokePainter({
    required this.isPressed,
    required this.isDisabled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(AppRadius.xxl + 2));

    // Base background color
    final bgPaint = Paint()
      ..color = isDisabled
          ? const Color(0xFFE0E0E0)
          : (isPressed ? const Color(0xFFE8DCC8) : const Color(0xFFF7E9D3))
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rrect, bgPaint);

    // Draw multiple highlighter-style strokes to create button outline
    _drawHighlighterStrokes(canvas, size);
  }

  void _drawHighlighterStrokes(Canvas canvas, Size size) {
    final strokeColor = isDisabled
        ? const Color(0xFFBDBDBD)
        : const Color(0xFF1A1A2E);

    final w = size.width;
    final h = size.height;

    // Draw multiple irregular strokes like highlighter marks
    final random = math.Random(42);

    // Create 3-4 overlapping strokes for each edge
    for (int stroke = 0; stroke < 3; stroke++) {
      final strokeWidth = 2.0 + random.nextDouble() * 1.5;
      final offset = (stroke - 1) * 1.5;

      final paint = Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.square
        ..strokeJoin = StrokeJoin.miter;

      final path = Path();

      // Top edge - slightly wavy like hand-drawn
      final topY = 2 + offset + random.nextDouble() * 1.5;
      path.moveTo(8 + offset, topY);
      path.quadraticBezierTo(
        w / 2 + random.nextDouble() * 3 - 1.5,
        topY + random.nextDouble() * 2 - 1,
        w - 8 - offset,
        topY,
      );

      // Right edge
      final rightX = w - 2 - offset;
      path.lineTo(rightX, h - 8 - offset);

      // Bottom edge
      final bottomY = h - 2 - offset;
      path.lineTo(8 + offset, bottomY);

      // Left edge
      final leftX = 2 + offset;
      path.lineTo(leftX, 8 + offset);

      // Close to top
      path.lineTo(8 + offset, topY);

      canvas.drawPath(path, paint);
    }

    // Add additional sketchy corner strokes
    final cornerPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Top-left corner arc
    final cornerPath1 = Path();
    cornerPath1.moveTo(2, 20);
    cornerPath1.quadraticBezierTo(2, 2, 20, 2);
    canvas.drawPath(cornerPath1, cornerPaint);

    // Top-right corner arc
    final cornerPath2 = Path();
    cornerPath2.moveTo(w - 20, 2);
    cornerPath2.quadraticBezierTo(w - 2, 2, w - 2, 20);
    canvas.drawPath(cornerPath2, cornerPaint);

    // Bottom-right corner arc
    final cornerPath3 = Path();
    cornerPath3.moveTo(w - 2, h - 20);
    cornerPath3.quadraticBezierTo(w - 2, h - 2, w - 20, h - 2);
    canvas.drawPath(cornerPath3, cornerPaint);

    // Bottom-left corner arc
    final cornerPath4 = Path();
    cornerPath4.moveTo(20, h - 2);
    cornerPath4.quadraticBezierTo(2, h - 2, 2, h - 20);
    canvas.drawPath(cornerPath4, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is! _BrushStrokePainter ||
      oldDelegate.isPressed != isPressed ||
      oldDelegate.isDisabled != isDisabled;
}
