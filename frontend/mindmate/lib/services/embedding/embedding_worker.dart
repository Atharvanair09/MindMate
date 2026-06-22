import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/embedding_record.dart';
import '../ml/journal_sentiment_analyzer.dart';
import 'embedding_model.dart';
import 'embedding_queue.dart';

class EmbeddingWorker {
  Timer? _timer;
  final EmbeddingModel _model;
  final Battery _battery = Battery();
  bool _isProcessing = false;
  final JournalSentimentAnalyzer _sentimentAnalyzer =
      JournalSentimentAnalyzer.instance;

  EmbeddingWorker(this._model);

  void start() {
    // Poll every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      processQueue();
    });
  }

  void stop() {
    _timer?.cancel();
  }

  Future<void> processQueue() async {
    if (_isProcessing) return;

    try {
      // Check battery saver state
      final batteryState = await _battery.batteryState;
      if (batteryState == BatteryState.unknown) {
        // Assume ok if unknown
      } else {
        final batteryLevel = await _battery.batteryLevel;
        if (batteryLevel < 15 && batteryState != BatteryState.charging) {
          // Battery too low, skip processing
          return;
        }
      }

      _isProcessing = true;
      final tasks = await EmbeddingQueue.getPendingTasks(limit: 5);
      if (tasks.isEmpty) {
        _isProcessing = false;
        return;
      }

      final isar = IsarDatabase.instance;

      for (var task in tasks) {
        await EmbeddingQueue.markProcessing(task.id);

        try {
          String textToEmbed = '';
          if (task.sourceType == 'journal') {
            final entry = await isar.collection<JournalEntry>().get(task.sourceId);
            if (entry == null) {
              await EmbeddingQueue.markFailed(task.id, 'JournalEntry not found');
              continue;
            }
            textToEmbed = '${entry.title}. ${entry.content}';
          } else if (task.sourceType == 'chat') {
            final msg = await isar.collection<ChatMessage>().get(task.sourceId);
            if (msg == null) {
              await EmbeddingQueue.markFailed(task.id, 'ChatMessage not found');
              continue;
            }
            textToEmbed = msg.message;
          }

          if (textToEmbed.trim().isEmpty) {
            await EmbeddingQueue.markFailed(task.id, 'Text is empty');
            continue;
          }

          // Generate embedding asynchronously, no UI blocking
          final vector = await _model.generateAsync(textToEmbed);

          // Save embedding and update source model
          await isar.writeTxn(() async {
            final record = EmbeddingRecord()
              ..sourceType = task.sourceType
              ..sourceId = task.sourceId
              ..modelVersion = 'all-MiniLM-L6-v2'
              ..vectorDimension = 384
              ..createdAt = DateTime.now()
              ..storedLocally = true
              ..vector = vector;

            final recordId = await isar.collection<EmbeddingRecord>().put(record);

            if (task.sourceType == 'journal') {
              final entry = await isar.collection<JournalEntry>().get(task.sourceId);
              if (entry != null) {
                entry.embeddingGenerated = true;
                entry.embeddingId = recordId;

                // Run sentiment analysis and persist scores
                final analysis = _sentimentAnalyzer.analyzeText(textToEmbed);
                entry.sentimentScore = analysis.sentimentScore;
                entry.stressScore = analysis.stressScore;
                entry.energyScore = analysis.energyScore;
                entry.emotionalKeywords = analysis.emotionalKeywords.join(',');

                debugPrint('[SentimentAnalysis] Journal #${entry.id}: '
                    'sentiment=${analysis.sentimentScore.toStringAsFixed(3)}, '
                    'stress=${analysis.stressScore.toStringAsFixed(3)}, '
                    'energy=${analysis.energyScore.toStringAsFixed(3)}, '
                    'keywords=${analysis.emotionalKeywords}');

                await isar.collection<JournalEntry>().put(entry);
              }
            } else if (task.sourceType == 'chat') {
              final msg = await isar.collection<ChatMessage>().get(task.sourceId);
              if (msg != null) {
                msg.embeddingGenerated = true;
                msg.embeddingId = recordId;

                // Run sentiment analysis for chat messages too
                final analysis = _sentimentAnalyzer.analyzeText(textToEmbed);
                msg.sentimentScore = analysis.sentimentScore;

                await isar.collection<ChatMessage>().put(msg);
              }
            }
          });

          await EmbeddingQueue.markCompleted(task.id);
        } catch (e) {
          await EmbeddingQueue.markFailed(task.id, e.toString());
        }
      }
    } catch (e) {
      // General worker error
    } finally {
      _isProcessing = false;
    }
  }
}
