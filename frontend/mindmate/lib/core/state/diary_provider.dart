import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:uuid/uuid.dart';
import '../../presentation/widgets/diary_grid/models/diary_page_data.dart';
import '../../presentation/widgets/diary_grid/models/diary_image_block.dart';

class DiaryProvider extends ChangeNotifier {
  List<DiaryPageData> _pages = [DiaryPageData()];
  final _storage = const FlutterSecureStorage();
  static const _keyAlias = 'diary_encryption_key';

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<DiaryPageData> get pages => _pages;

  DiaryProvider() {
    _init();
  }

  Future<void> _init() async {
    await loadDiary();
    _isInitialized = true;
    notifyListeners();
  }

  Future<encrypt.Key> _getEncryptionKey() async {
    String? keyBase64 = await _storage.read(key: _keyAlias);
    if (keyBase64 == null) {
      final key = encrypt.Key.fromSecureRandom(32);
      await _storage.write(key: _keyAlias, value: key.base64);
      return key;
    } else {
      return encrypt.Key.fromBase64(keyBase64);
    }
  }

  Future<void> saveDiary() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/diary_state.json');

      final jsonList = _pages.map((p) => p.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      final key = await _getEncryptionKey();
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final encrypted = encrypter.encrypt(jsonString, iv: iv);

      final payload = jsonEncode({
        'iv': iv.base64,
        'data': encrypted.base64,
      });

      await file.writeAsString(payload);
    } catch (e) {
      debugPrint("Error saving diary: $e");
    }
  }

  Future<void> loadDiary() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/diary_state.json');

      if (await file.exists()) {
        final payload = await file.readAsString();
        final map = jsonDecode(payload);

        final iv = encrypt.IV.fromBase64(map['iv']);
        final encrypted = encrypt.Encrypted.fromBase64(map['data']);

        final key = await _getEncryptionKey();
        final encrypter = encrypt.Encrypter(encrypt.AES(key));

        final decryptedString = encrypter.decrypt(encrypted, iv: iv);
        final List<dynamic> jsonList = jsonDecode(decryptedString);

        _pages = jsonList.map((json) => DiaryPageData.fromJson(json)).toList();
      } else {
        _pages = [DiaryPageData()];
      }
    } catch (e) {
      debugPrint("Error loading diary: $e");
      _pages = [DiaryPageData()];
    }
  }

  Future<DiaryImageBlock?> addImageToPage(int pageIndex, String originalImagePath) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final ext = originalImagePath.split('.').last;
      final newFileName = '${const Uuid().v4()}.$ext';
      final newPath = '${dir.path}/$newFileName';

      final savedImage = await File(originalImagePath).copy(newPath);

      final newImage = DiaryImageBlock(
        imagePath: savedImage.path,
        x: 2,
        y: 2,
        width: 6,
        height: 6,
      );

      _pages[pageIndex].images.add(newImage);
      notifyListeners();
      saveDiary();
      return newImage;
    } catch (e) {
      debugPrint("Error adding image: $e");
      return null;
    }
  }

  void addPage() {
    _pages.add(DiaryPageData());
    notifyListeners();
    saveDiary();
  }

  void updatePage(int index, DiaryPageData pageData) {
    if (index >= 0 && index < _pages.length) {
      _pages[index] = pageData;
      notifyListeners();
      saveDiary();
    }
  }

  void notifyPageChanged() {
    notifyListeners();
    saveDiary();
  }

  void reset() {
    _pages = [DiaryPageData()];
    notifyListeners();
    saveDiary();
  }
}
