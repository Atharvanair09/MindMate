import 'dart:math';

import '../../domain/models/mood_feature_vector.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/mood_log.dart';
import '../../domain/models/session_log.dart';
import '../../domain/models/intervention_log.dart';
import '../../domain/models/daily_mood_check_in.dart';
import 'feature_extractor.dart';

class FeatureBuilder {
  final FeatureExtractor extractor;
  
  FeatureBuilder(this.extractor);

  Future<MoodFeatureVector> buildFeatureVector(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    
    // Fetch all raw data
    final journals = await extractor.getJournalsForDate(date);
    final chats = await extractor.getChatsForDate(date);
    final moods = await extractor.getMoodsForDate(date);
    final session = await extractor.getSessionLogForDate(date);
    final interventions = await extractor.getInterventionsForDate(date);
    final previousMood = await extractor.getPreviousMood(date);
    final rollingMoods = await extractor.getMoodsForLast7Days(date);
    final todayMood = await extractor.getDailyMoodCheckInForDate(date);

    // Initialize the vector
    final vector = MoodFeatureVector()
      ..date = startOfDay
      ..createdAt = DateTime.now()
      ..featureVersion = '1.0.0'
      ..hourOfDay = DateTime.now().hour
      ..dayOfWeek = startOfDay.weekday
      ..timeSpentMinutes = session?.timeSpentMinutes ?? 0
      ..sessionCount = session?.appOpenCount ?? 0
      ..interventionCount = interventions.length;

    // Process Journals
    vector.journalCount = journals.length;
    double journalSentimentSum = 0;
    int journalSentimentCount = 0;
    double journalStressSum = 0;
    int journalStressCount = 0;
    double journalEnergySum = 0;
    int journalEnergyCount = 0;
    List<double>? journalAvgEmbedding;
    
    for (var journal in journals) {
      if (journal.sentimentScore != null) {
        journalSentimentSum += journal.sentimentScore!;
        journalSentimentCount++;
      }
      if (journal.stressScore != null) {
        journalStressSum += journal.stressScore!;
        journalStressCount++;
      }
      if (journal.energyScore != null) {
        journalEnergySum += journal.energyScore!;
        journalEnergyCount++;
      }
      if (journal.embeddingId != null) {
        final emb = await extractor.getEmbedding('journal', journal.id);
        if (emb != null && emb.vector.isNotEmpty) {
          journalAvgEmbedding = _addVectors(journalAvgEmbedding, emb.vector);
        }
      }
    }
    
    if (journalSentimentCount > 0) {
      vector.journalSentiment = journalSentimentSum / journalSentimentCount;
    }
    if (journalStressCount > 0) {
      vector.journalStressScore = journalStressSum / journalStressCount;
    }
    if (journalEnergyCount > 0) {
      vector.journalEnergyScore = journalEnergySum / journalEnergyCount;
    }
    if (journalAvgEmbedding != null && vector.journalCount > 0) {
      vector.journalEmbedding = _divideVector(journalAvgEmbedding, vector.journalCount);
    }

    // Process Chats
    vector.chatCount = chats.length;
    double chatSentimentSum = 0;
    int chatSentimentCount = 0;
    List<double>? chatAvgEmbedding;

    for (var chat in chats) {
      if (chat.sentimentScore != null) {
        chatSentimentSum += chat.sentimentScore!;
        chatSentimentCount++;
      }
      if (chat.embeddingId != null) {
        final emb = await extractor.getEmbedding('chat', chat.id);
        if (emb != null && emb.vector.isNotEmpty) {
          chatAvgEmbedding = _addVectors(chatAvgEmbedding, emb.vector);
        }
      }
    }

    if (chatSentimentCount > 0) {
      vector.chatSentiment = chatSentimentSum / chatSentimentCount;
    }
    if (chatAvgEmbedding != null && vector.chatCount > 0) {
      vector.chatEmbeddingAverage = _divideVector(chatAvgEmbedding, vector.chatCount);
    }

    // Process Moods
    vector.previousMood = previousMood?.score;
    
    final manualMoods = moods.where((m) => m.isManual).toList();
    if (manualMoods.isNotEmpty) {
      vector.manualMoodExists = true;
      // Sort to get the latest manual mood of the day
      manualMoods.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      vector.actualMood = manualMoods.last.score;
    }

    if (todayMood != null) {
      vector.currentMood = todayMood.moodLevel;
      vector.currentMoodSource = todayMood.source;
      
      switch (todayMood.moodLevel) {
        case 'GREAT':
          vector.currentMoodValue = 5.0;
          break;
        case 'GOOD':
          vector.currentMoodValue = 4.0;
          break;
        case 'OKAY':
          vector.currentMoodValue = 3.0;
          break;
        case 'LOW':
          vector.currentMoodValue = 2.0;
          break;
        case 'STRUGGLING':
          vector.currentMoodValue = 1.0;
          break;
        default:
          vector.currentMoodValue = 3.0;
      }
      vector.manualMoodExists = true;
      vector.actualMood = vector.currentMoodValue?.round();
    }

    // Rolling 7 days calculation
    final rollingManualMoods = rollingMoods.where((m) => m.isManual).toList();
    if (rollingManualMoods.isNotEmpty) {
      double sum = 0;
      for (var m in rollingManualMoods) {
        sum += m.score;
      }
      final mean = sum / rollingManualMoods.length;
      vector.rollingMoodAverage7Days = mean;

      if (rollingManualMoods.length > 1) {
        double sqDiffSum = 0;
        for (var m in rollingManualMoods) {
          sqDiffSum += pow(m.score - mean, 2);
        }
        vector.rollingMoodStd7Days = sqrt(sqDiffSum / (rollingManualMoods.length - 1));
      } else {
        vector.rollingMoodStd7Days = 0.0;
      }
    }

    return vector;
  }

  List<double> _addVectors(List<double>? v1, List<double> v2) {
    if (v1 == null) return List.from(v2);
    if (v1.length != v2.length) return v1;
    final result = List<double>.filled(v1.length, 0.0);
    for (int i = 0; i < v1.length; i++) {
      result[i] = v1[i] + v2[i];
    }
    return result;
  }

  List<double> _divideVector(List<double> v, int divisor) {
    if (divisor == 0) return v;
    final result = List<double>.filled(v.length, 0.0);
    for (int i = 0; i < v.length; i++) {
      result[i] = v[i] / divisor;
    }
    return result;
  }
}
