import 'dart:developer';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:encrypt/encrypt.dart';
import 'package:finai_frontend/app/domain/entities/constant.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';

class Security {
  static String? encryptAes(String data, {String? masterKey}) {
    final paddedPassword =
        _getPaddedPassword(masterKey ?? Constant.masterKey, 128);
    final key = KeyParameter(paddedPassword);
    final iv = IV.fromLength(16);
    final cipher =
        PaddedBlockCipherImpl(PKCS7Padding(), CBCBlockCipher(AESEngine()));
    final params =
        PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
      ParametersWithIV<CipherParameters>(key, iv.bytes),
      null,
    );
    cipher.init(true, params);

    try {
      final encrypted = cipher.process(Uint8List.fromList(data.codeUnits));
      return hex.encode(encrypted);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static String? decryptAes(String? encryptedData, {String? masterKey}) {
    try {
      final paddedPassword =
          _getPaddedPassword(masterKey ?? Constant.masterKey, 128);
      final key = KeyParameter(paddedPassword);
      final iv = IV.fromLength(16);
      final cipher =
          PaddedBlockCipherImpl(PKCS7Padding(), CBCBlockCipher(AESEngine()));
      final params =
          PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
        ParametersWithIV<CipherParameters>(key, iv.bytes),
        null,
      );
      cipher.init(false, params);

      final encrypted = hex.decode(encryptedData ?? '');
      final decrypted = cipher.process(Uint8List.fromList(encrypted));
      return String.fromCharCodes(decrypted);
    } catch (e, s) {
      log('error decrypt : $e');
      log('decrypt stacks : $s');
      return null;
    }
  }

  static Uint8List _getPaddedPassword(String password, int bits) {
    final paddedLength = bits ~/ 8 - password.length;
    if (paddedLength < 0) {
      return Uint8List.fromList(password.substring(0, bits ~/ 8).codeUnits);
    } else {
      password = password.padRight(bits ~/ 8, 'f');
      return Uint8List.fromList(password.codeUnits);
    }
  }
}
