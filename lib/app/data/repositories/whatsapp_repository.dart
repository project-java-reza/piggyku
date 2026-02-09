import '../services/whatsapp_service.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';

class WhatsAppRepository {
  final WhatsAppService _whatsAppService;

  WhatsAppRepository({
    required WhatsAppService whatsAppService,
  }) : _whatsAppService = whatsAppService;

  /// Verify webhook dari WhatsApp
  Future<bool> verifyWebhook({
    required String mode,
    required String token,
    required String challenge,
  }) async {
    try {
      return await _whatsAppService.verifyWebhook(
        mode: mode,
        token: token,
        challenge: challenge,
      );
    } catch (e) {
      throw WhatsAppFailure(message: 'Failed to verify webhook: $e');
    }
  }

  /// Process incoming WhatsApp message
  Future<Map<String, dynamic>> processIncomingMessage({
    required Map<String, dynamic> webhookData,
  }) async {
    try {
      final result = await _whatsAppService.processIncomingMessage(
        webhookData: webhookData,
      );
      return result;
    } on WhatsAppException catch (e) {
      throw WhatsAppFailure(message: e.message);
    } catch (e) {
      throw WhatsAppFailure(message: 'Failed to process WhatsApp message: $e');
    }
  }

  /// Send help message to user
  Future<void> sendHelpMessage(String phoneNumber) async {
    try {
      await _whatsAppService.sendHelpMessage(phoneNumber);
    } on WhatsAppException catch (e) {
      throw WhatsAppFailure(message: e.message);
    } catch (e) {
      throw WhatsAppFailure(message: 'Failed to send help message: $e');
    }
  }

  /// Send daily summary to user
  Future<void> sendDailySummary(String phoneNumber) async {
    try {
      await _whatsAppService.sendDailySummary(phoneNumber);
    } on WhatsAppException catch (e) {
      throw WhatsAppFailure(message: e.message);
    } catch (e) {
      throw WhatsAppFailure(message: 'Failed to send daily summary: $e');
    }
  }

  /// Test WhatsApp connection
  Future<bool> testConnection() async {
    try {
      // Kirim test message ke nomor tertentu
      await _whatsAppService.sendWhatsAppMessage(
        phoneNumber: 'TEST_NUMBER', // Nomor test
        message: '✅ WhatsApp Bot is running and connected successfully!',
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}