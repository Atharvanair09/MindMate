import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getLocalFile(String directoryName, String filename) async {
    final path = await _localPath;
    final dir = Directory('$path/$directoryName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return File('${dir.path}/$filename');
  }

  Future<void> saveFile(String directoryName, String filename, String data) async {
    final file = await _getLocalFile(directoryName, filename);
    await file.writeAsString(data);
  }

  Future<String?> readFile(String directoryName, String filename) async {
    try {
      final file = await _getLocalFile(directoryName, filename);
      if (!await file.exists()) return null;
      return await file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteFile(String directoryName, String filename) async {
    try {
      final file = await _getLocalFile(directoryName, filename);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignore deletion errors
    }
  }

  Future<List<File>> listFiles(String directoryName) async {
    try {
      final path = await _localPath;
      final dir = Directory('$path/$directoryName');
      if (!await dir.exists()) return [];
      
      final List<FileSystemEntity> entities = await dir.list().toList();
      return entities.whereType<File>().toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearDirectory(String directoryName) async {
    try {
      final path = await _localPath;
      final dir = Directory('$path/$directoryName');
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      // Ignore errors
    }
  }
}
