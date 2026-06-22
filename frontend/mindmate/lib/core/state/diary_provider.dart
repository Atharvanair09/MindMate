import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../presentation/widgets/diary_grid/models/diary_page_data.dart';
import '../../presentation/widgets/diary_grid/models/diary_image_block.dart';
import '../../domain/repositories/journal_repository.dart';
import '../../domain/models/journal_entry.dart';
import '../../services/ml/journal_sentiment_analyzer.dart';
import '../../services/ml/feature_pipeline.dart';
import '../../services/notifications/notification_service.dart';

class DiaryProvider extends ChangeNotifier with WidgetsBindingObserver {
  List<DiaryPageData> _pages = [DiaryPageData()];
  final JournalRepository _repository;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<DiaryPageData> get pages => _pages;

  JournalEntry? _currentJournal;

  DiaryProvider({required JournalRepository repository}) : _repository = repository {
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
    if (state == AppLifecycleState.resumed) {
      _checkDayRollover();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      saveDiary();
      
      // Hackathon: schedule context-aware check-in 1 minute after app closed/paused
      if (NotificationService.pendingContextAwareCheckInMessage != null) {
        NotificationService.instance.sendContextAwareCheckIn(
          NotificationService.pendingContextAwareCheckInMessage!,
          immediate: false,
        );
        NotificationService.pendingContextAwareCheckInMessage = null;
      }
    }
  }

  void _checkDayRollover() {
    if (_currentJournal != null) {
      final now = DateTime.now();
      if (_currentJournal!.journalDate.year != now.year ||
          _currentJournal!.journalDate.month != now.month ||
          _currentJournal!.journalDate.day != now.day) {
        // Day has changed, load a fresh diary for today
        loadDiary();
      }
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

      final jsonList = _pages.map((p) => p.toJson()).toList();
      final pagesJson = jsonEncode(jsonList);
      final plainText = _generatePlainTextContent();
      final wordCount = plainText.trim().isEmpty ? 0 : plainText.trim().split(RegExp(r'\s+')).length;

      // Run sentiment analysis immediately on the plain text
      JournalAnalysisResult? analysis;
      if (plainText.trim().isNotEmpty) {
        analysis = JournalSentimentAnalyzer.instance.analyzeText(plainText);
        debugPrint('[DiaryProvider] Immediate sentiment analysis: '
            'sentiment=${analysis.sentimentScore.toStringAsFixed(3)}, '
            'stress=${analysis.stressScore.toStringAsFixed(3)}, '
            'energy=${analysis.energyScore.toStringAsFixed(3)}, '
            'keywords=${analysis.emotionalKeywords}');
      }

      if (_currentJournal == null) {
        _currentJournal = JournalEntry()
          ..content = plainText
          ..createdAt = now
          ..updatedAt = now
          ..journalDate = now
          ..pagesJson = pagesJson
          ..wordCount = wordCount;
        
        // Apply sentiment scores immediately
        if (analysis != null) {
          _currentJournal!.sentimentScore = analysis.sentimentScore;
          _currentJournal!.stressScore = analysis.stressScore;
          _currentJournal!.energyScore = analysis.energyScore;
          _currentJournal!.emotionalKeywords = analysis.emotionalKeywords.join(',');
        }

        final id = await _repository.create(_currentJournal!);
        // After Isar insertion, the ID is assigned
      } else {
        _currentJournal!.content = plainText;
        _currentJournal!.updatedAt = now;
        _currentJournal!.pagesJson = pagesJson;
        _currentJournal!.wordCount = wordCount;

        // Apply sentiment scores immediately
        if (analysis != null) {
          _currentJournal!.sentimentScore = analysis.sentimentScore;
          _currentJournal!.stressScore = analysis.stressScore;
          _currentJournal!.energyScore = analysis.energyScore;
          _currentJournal!.emotionalKeywords = analysis.emotionalKeywords.join(',');
        }

        await _repository.update(_currentJournal!);
      }

      // Trigger feature pipeline to recalculate burnout with new sentiment data
      try {
        await FeaturePipeline.instance.triggerPipeline();
      } catch (e) {
        debugPrint('[DiaryProvider] Feature pipeline error: $e');
      }
    } catch (e) {
      debugPrint("Error saving diary: $e");
    }
  }

  Future<void> loadDiary() async {
    try {
      final now = DateTime.now();
      
      // We need to fetch today's journal if it exists
      final allJournals = await _repository.getAll();
      final todayJournals = allJournals.where((entry) => 
          entry.journalDate.year == now.year &&
          entry.journalDate.month == now.month &&
          entry.journalDate.day == now.day).toList();
      
      JournalEntry? journal = todayJournals.isNotEmpty ? todayJournals.first : null;
      
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
