import 'package:flutter_test/flutter_test.dart';
import '../app/data/models/whatsapp_transaction_model.dart';

void main() {
  group('WhatsApp Message Parsing Tests', () {
    test('Parse simple expense message: "beli ketoprak 5000"', () {
      final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
        phoneNumber: '6281234567890',
        message: 'beli ketoprak 5000',
      );

      expect(transaction.transactionType, equals('expense'));
      expect(transaction.description, equals('ketoprak'));
      expect(transaction.amount, equals(5000.0));
      expect(transaction.category, equals('makanan'));
      expect(transaction.isValid, isTrue);
    });

    test('Parse expense with "ribu": "beli kopi 15ribu"', () {
      final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
        phoneNumber: '6281234567890',
        message: 'beli kopi 15ribu',
      );

      expect(transaction.transactionType, equals('expense'));
      expect(transaction.description, equals('kopi'));
      expect(transaction.amount, equals(15000.0));
      expect(transaction.category, equals('makanan'));
      expect(transaction.isValid, isTrue);
    });

    test('Parse expense with "juta": "beli laptop 5juta"', () {
      final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
        phoneNumber: '6281234567890',
        message: 'beli laptop 5juta',
      );

      expect(transaction.transactionType, equals('expense'));
      expect(transaction.description, equals('laptop'));
      expect(transaction.amount, equals(5000000.0));
      expect(transaction.category, equals('lainnya'));
      expect(transaction.isValid, isTrue);
    });

    test('Parse income message: "jual kue 25000"', () {
      final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
        phoneNumber: '6281234567890',
        message: 'jual kue 25000',
      );

      expect(transaction.transactionType, equals('income'));
      expect(transaction.description, equals('kue'));
      expect(transaction.amount, equals(25000.0));
      expect(transaction.category, equals('lainnya'));
      expect(transaction.isValid, isTrue);
    });

    test('Parse formal expense format: "pengeluaran 20000 belanja kebutuhan"', () {
      final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
        phoneNumber: '6281234567890',
        message: 'pengeluaran 20000 belanja kebutuhan',
      );

      expect(transaction.transactionType, equals('expense'));
      expect(transaction.description, equals('belanja kebutuhan'));
      expect(transaction.amount, equals(20000.0));
      expect(transaction.category, equals('belanja'));
      expect(transaction.isValid, isTrue);
    });

    test('Parse formal income format: "pemasukan 5000000 gaji bulanan"', () {
      final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
        phoneNumber: '6281234567890',
        message: 'pemasukan 5000000 gaji bulanan',
      );

      expect(transaction.transactionType, equals('income'));
      expect(transaction.description, equals('gaji bulanan'));
      expect(transaction.amount, equals(5000000.0));
      expect(transaction.category, equals('pendapatan'));
      expect(transaction.isValid, isTrue);
    });

    test('Parse transportasi category: "gojek 15000"', () {
      final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
        phoneNumber: '6281234567890',
        message: 'gojek 15000',
      );

      expect(transaction.transactionType, equals('expense'));
      expect(transaction.description, equals('gojek'));
      expect(transaction.amount, equals(15000.0));
      expect(transaction.category, equals('transportasi'));
    });

    test('Invalid message should return false isValid', () {
      final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
        phoneNumber: '6281234567890',
        message: 'hello world',
      );

      expect(transaction.isValid, isFalse);
      expect(transaction.amount, equals(0.0));
    });

    test('Generate correct confirmation message', () {
      final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
        phoneNumber: '6281234567890',
        message: 'beli ketoprak 5000',
      );

      expect(transaction.confirmationMessage, contains('✅ *Transaksi Tercatat*'));
      expect(transaction.confirmationMessage, contains('💰 Pengeluaran'));
      expect(transaction.confirmationMessage, contains('Rp 5rb'));
      expect(transaction.confirmationMessage, contains('ketoprak'));
    });

    test('Convert to transaction request format', () {
      final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
        phoneNumber: '6281234567890',
        message: 'beli ketoprak 5000',
      );

      final transactionRequest = transaction.toTransactionRequest(
        userId: 1,
        accountId: 1,
        categoryId: 1,
      );

      expect(transactionRequest['user_id'], equals(1));
      expect(transactionRequest['account_id'], equals(1));
      expect(transactionRequest['category_id'], equals(1));
      expect(transactionRequest['type'], equals('expense'));
      expect(transactionRequest['amount'], equals('5000.0'));
      expect(transactionRequest['note'], contains('Dari WhatsApp'));
      expect(transactionRequest['counterparty'], equals('6281234567890'));
    });
  });

  group('Category Detection Tests', () {
    test('Makanan category detection', () {
      final testCases = [
        'beli nasi 15000',
        'makan bakso 20000',
        'beli sate 25000',
        'minum kopi 10000',
      ];

      for (final testCase in testCases) {
        final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
          phoneNumber: '6281234567890',
          message: testCase,
        );
        expect(transaction.category, equals('makanan'), reason: 'Failed for: $testCase');
      }
    });

    test('Transportasi category detection', () {
      final testCases = [
        'gojek 15000',
        'grab 20000',
        'bensin 50000',
        'parkir 5000',
      ];

      for (final testCase in testCases) {
        final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
          phoneNumber: '6281234567890',
          message: testCase,
        );
        expect(transaction.category, equals('transportasi'), reason: 'Failed for: $testCase');
      }
    });

    test('Belanja category detection', () {
      final testCases = [
        'belanja 100000',
        'jajan 15000',
        'minuman 20000',
      ];

      for (final testCase in testCases) {
        final transaction = WhatsAppTransactionModel.fromWhatsAppMessage(
          phoneNumber: '6281234567890',
          message: testCase,
        );
        expect(transaction.category, equals('belanja'), reason: 'Failed for: $testCase');
      }
    });
  });
}