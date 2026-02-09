import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Debug page untuk reset first launch flag
/// Hapus file ini setelah testing selesai
class DebugResetFirstLaunch extends StatelessWidget {
  const DebugResetFirstLaunch({super.key});

  static const String _firstLaunchKey = 'isFirstLaunch';

  Future<void> _resetFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, true);
    debugPrint('✅ First launch flag has been reset!');
    debugPrint('🔄 Please restart the app to see Welcome Page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug - Reset First Launch'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.refresh,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            const Text(
              'Reset First Launch Flag',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'This will reset the first launch flag so you can see the Welcome Page again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _resetFirstLaunch,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset First Launch'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'After resetting, close the app and reopen it.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
