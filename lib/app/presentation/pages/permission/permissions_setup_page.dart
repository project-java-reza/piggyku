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
import 'package:permission_handler/permission_handler.dart';

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
              'Pengaturan Izin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const Gap.md(),

            // Description
            const P(
              h: AppSpacing.xl,
              child: Text(
                'Kami memerlukan beberapa izin untuk memberikan Anda pengalaman terbaik.',
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xxxl),
          topRight: Radius.circular(AppRadius.xxxl),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Notification Permission Item
          _PermissionItem(
            icon: Icons.notifications_active,
            title: 'Pemberitahuan',
            description:
                'Dapatkan notifikasi tentang pembaruan dan pengingat penting.',
            isGranted: notificationGranted,
            onRequest: () async {
              // Request permission
              await context.read<PermissionCubit>().requestNotificationPermission();

              // Check permission status after request
              if (!context.mounted) return;
              await context.read<PermissionCubit>().checkPermissions();

              // If still denied, open app settings
              if (!context.mounted) return;
              final state = context.read<PermissionCubit>().state;
              if (state is PermissionsLoaded && !state.notificationPermissionGranted) {
                await openAppSettings();
              }
            },
          ),
          const Gap.md(),

          // Alarm Permission Item
          _PermissionItem(
            icon: Icons.alarm,
            title: 'Alarm & Pengingat',
            description: 'Atur alarm dan pengingat untuk transaksi Anda.',
            isGranted: alarmGranted,
            onRequest: () async {
              // Request permission
              await context.read<PermissionCubit>().requestAlarmPermission();

              // Check permission status after request
              if (!context.mounted) return;
              await context.read<PermissionCubit>().checkPermissions();

              // If still denied, open app settings
              if (!context.mounted) return;
              final state = context.read<PermissionCubit>().state;
              if (state is PermissionsLoaded && !state.alarmPermissionGranted) {
                await openAppSettings();
              }
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
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primaryDark,
                    size: 20,
                  ),
                  const HGap.md(),
                  Expanded(
                    child: Text(
                      'Anda dapat mengubah izin ini nanti di pengaturan aplikasi.',
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
            // Bagian Icon (tetap sama, pastikan warna putih)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isGranted ? Colors.green : AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const HGap.md(),

            // Bagian Teks (Expanded agar mendorong tombol ke kanan)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(description,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),

            // Tombol di ujung kanan
            if (!isGranted)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _BrushStrokeButton(
                  onPressed: onRequest,
                  text: 'Izinkan',
                ),
              )
            else
              // Status Granted tetap di kanan
              const Icon(Icons.check_circle, color: Colors.green, size: 30),
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
          // Tombol Utama (Desain Standar/Biasa)
          SizedBox(
            width: double.infinity,
            height: 55, // Sedikit lebih tinggi agar nyaman ditekan
            child: ElevatedButton(
              onPressed: allGranted
                  ? () {
                      context.read<PermissionCubit>().completePermissionSetup();
                      final authCubit = context.read<AuthCubit>();
                      if (authCubit.state is LoginSuccess) {
                        NavigationService.pushReplacement(
                            const DashboardPage());
                      } else {
                        NavigationService.pushReplacement(const LoginPage());
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A2E), // Warna gelap standar
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                disabledForegroundColor: Colors.grey[500],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Melengkung biasa
                ),
                elevation: 0, // Tanpa shadow berlebih agar terlihat clean
              ),
              child: Text(
                allGranted ? 'Lanjutkan' : 'Berikan Semua Izin',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          if (!allGranted)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: TextButton(
                onPressed: () {
                  _showSkipDialog(context);
                },
                child: Text(
                  'Lewati untuk saat ini',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSkipDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lewati Izin?'),
        content: const Text(
            'Beberapa fitur mungkin tidak berfungsi dengan benar tanpa izin ini.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PermissionCubit>().completePermissionSetup();
              NavigationService.pushReplacement(const LoginPage());
            },
            child: const Text('Lewati Saja'),
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
            constraints:
                const BoxConstraints(minWidth: 80), // Memastikan lebar minimal
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic, // Sedikit miring agar artistik
                color: isDisabled ? Colors.grey : const Color(0xFF1A1A2E),
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
    final paint = Paint()
      ..color = isDisabled
          ? Colors.grey.shade300
          : (isPressed ? const Color(0xFFF0D5A8) : const Color(0xFFF7E9D3))
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final path = Path();

    // Bentuk Dasar Kuas Tembok (Lebih kotak tapi ujungnya kasar/berjumbai)
    path.moveTo(0, h * 0.2); // Start kiri atas

    // Sisi atas sedikit bergelombang
    path.lineTo(w * 0.3, h * 0.15);
    path.lineTo(w * 0.7, h * 0.25);
    path.lineTo(w, h * 0.2); // Ujung kanan atas

    // Ujung kanan dibuat "pecah" (serabut kuas)
    path.lineTo(w + 4, h * 0.4);
    path.lineTo(w - 2, h * 0.5);
    path.lineTo(w + 6, h * 0.7);
    path.lineTo(w, h * 0.85); // Ujung kanan bawah

    // Sisi bawah
    path.lineTo(w * 0.5, h * 0.95);
    path.lineTo(0, h * 0.8); // Kembali ke kiri bawah

    // Ujung kiri juga dibuat tidak rata
    path.lineTo(-3, h * 0.5);
    path.close();

    canvas.drawPath(path, paint);

    // EFEK TEKSTUR KUAS (Bristle Marks)
    // Garis-garis halus searah sapuan kuas
    final linePaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double i = 0.3; i < 0.8; i += 0.2) {
      canvas.drawLine(
        Offset(w * 0.1, h * i),
        Offset(w * 0.9, h * (i + 0.05)),
        linePaint,
      );
    }

    // Border "Sketsa" kasar
    final borderPaint = Paint()
      ..color = isDisabled ? Colors.grey : const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
