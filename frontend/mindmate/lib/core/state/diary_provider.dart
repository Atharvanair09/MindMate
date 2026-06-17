import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../presentation/widgets/diary_grid/models/diary_page_data.dart';
import '../../presentation/widgets/diary_grid/models/diary_image_block.dart';
import '../../data/repositories/archive_repository.dart';
import '../../domain/models/archive_models.dart';

class DiaryProvider extends ChangeNotifier with WidgetsBindingObserver {
  List<DiaryPageData> _pages = [DiaryPageData()];
  final ArchiveRepository _repository;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<DiaryPageData> get pages => _pages;

  JournalEntry? _currentJournal;

  DiaryProvider({required ArchiveRepository repository}) : _repository = repository {
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      saveDiary();
    }
  }

  Future<void> _init() async {
    await loadDiary();
    _isInitialized = true;
    notifyListeners();
  }

  String _generatePlainTextContent() {
    return _pages.map((p) => p.text).where((t) => t.trim().isNotEmpty).join('\n\n');
  }

  Future<void> saveDiary() async {
    if (!_isInitialized) return;
    
    try {
      final now = DateTime.now();
      
      if (_currentJournal != null) {
        if (_currentJournal!.journalDate.year != now.year ||
            _currentJournal!.journalDate.month != now.month ||
            _currentJournal!.journalDate.day != now.day) {
          _currentJournal = null;
        }
      }

      final jsonList = _pages.map((p) => p.toJson()).toList();
      final pagesJson = jsonEncode(jsonList);
      final plainText = _generatePlainTextContent();

      if (_currentJournal == null) {
        _currentJournal = JournalEntry(
          id: const Uuid().v4(),
          content: plainText,
          createdAt: now,
          updatedAt: now,
          journalDate: now,
          pagesJson: pagesJson,
        );
      } else {
        _currentJournal!.content = plainText;
        _currentJournal!.updatedAt = now;
        _currentJournal!.pagesJson = pagesJson;
      }

      await _repository.saveJournal(_currentJournal!);
    } catch (e) {
      debugPrint("Error saving diary: $e");
    }
  }

  Future<void> loadDiary() async {
    try {
      final now = DateTime.now();
      final journal = await _repository.getJournalForDate(now);
      
      if (journal != null) {
        _currentJournal = journal;
        if (journal.pagesJson != null) {
          final List<dynamic> jsonList = jsonDecode(journal.pagesJson!);
          _pages = jsonList.map((json) => DiaryPageData.fromJson(json)).toList();
        } else {
          final page = DiaryPageData();
          page.text = journal.content;
          _pages = [page];
        }
      } else {
        _currentJournal = null;
        _pages = [DiaryPageData()];
      }
    } catch (e) {
      debugPrint("Error loading diary: $e");
      _currentJournal = null;
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
    _currentJournal = null;
    notifyListeners();
    saveDiary();
  }
}
