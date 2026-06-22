import 'package:flutter_test/flutter_test.dart';
import 'package:mindmate/domain/models/mood_feature_vector.dart';
import 'package:mindmate/domain/models/reflection_result.dart';
import 'package:mindmate/services/ml/reflection_engine.dart';

void main() {
  group('ReflectionEngine Burnout Score Tests', () {
    final engine = ReflectionEngine.instance;

    // Helper to create a base vector with neutral defaults
    MoodFeatureVector createNeutralVector() {
      return MoodFeatureVector()
        ..journalCount = 0
        ..chatCount = 0
        ..timeSpentMinutes = 0
        ..sessionCount = 0
        ..interventionCount = 0
        ..manualMoodExists = false;
    }

    test('Baseline Neutral Vector calculation', () async {
      final vector = createNeutralVector();
      final result = await engine.getReflectionForVector(vector);

      // Verify exact calculated score for neutral baseline
      // Journal: 50.0 (40%) -> 20.0
      // Trend: 50.0 (10%) -> 5.0
      // Chat: 50.0 (15%) -> 7.5
      // Activity: 100.0 (5%) -> 5.0 (since sessions/time/interventions = 0)
      // Total: (20.0 + 5.0 + 7.5 + 5.0) / 0.70 = 53.57 -> rounded to 54.
      expect(result.burnoutScore, equals(54));
      expect(result.rawJournalImpact, closeTo(50.0, 0.01));
      expect(result.rawTrendImpact, closeTo(50.0, 0.01));
      expect(result.rawChatImpact, closeTo(50.0, 0.01));
      expect(result.rawActivityImpact, closeTo(100.0, 0.01));
    });

    test('Positive Journal decreases Burnout Score', () async {
      // Base neutral vector
      final neutralVector = createNeutralVector();
      final neutralResult = await engine.getReflectionForVector(neutralVector);

      // Positive journal vector (high sentiment, low stress, high energy)
      final positiveVector = createNeutralVector()
        ..journalCount = 1
        ..journalSentiment = 0.8
        ..journalStressScore = 0.1
        ..journalEnergyScore = 0.9;

      final positiveResult = await engine.getReflectionForVector(positiveVector);

      // Burnout score and journal impact must decrease
      expect(positiveResult.rawJournalImpact, lessThan(neutralResult.rawJournalImpact));
      expect(positiveResult.burnoutScore, lessThan(neutralResult.burnoutScore));
    });

    test('Negative Journal increases Burnout Score', () async {
      // Base neutral vector
      final neutralVector = createNeutralVector();
      final neutralResult = await engine.getReflectionForVector(neutralVector);

      // Negative journal vector (low sentiment, high stress, low energy)
      final negativeVector = createNeutralVector()
        ..journalCount = 1
        ..journalSentiment = -0.8
        ..journalStressScore = 0.9
        ..journalEnergyScore = 0.1;

      final negativeResult = await engine.getReflectionForVector(negativeVector);

      // Burnout score and journal impact must increase
      expect(negativeResult.rawJournalImpact, greaterThan(neutralResult.rawJournalImpact));
      expect(negativeResult.burnoutScore, greaterThan(neutralResult.burnoutScore));
    });

    test('Mood Improvement Trend decreases Burnout Score', () async {
      // Base neutral vector (mood = 3, rollingAvg = 3)
      final neutralVector = createNeutralVector();
      final neutralResult = await engine.getReflectionForVector(neutralVector);

      // Improved mood & trend (mood = 5, rollingAvg = 4.8)
      final improvedVector = createNeutralVector()
        ..manualMoodExists = true
        ..actualMood = 5
        ..rollingMoodAverage7Days = 4.8;

      final improvedResult = await engine.getReflectionForVector(improvedVector);

      // Burnout score and trend impact must decrease
      expect(improvedResult.rawTrendImpact, lessThan(neutralResult.rawTrendImpact));
      expect(improvedResult.burnoutScore, lessThan(neutralResult.burnoutScore));
    });

    test('Mood Decline Trend increases Burnout Score', () async {
      // Base neutral vector (mood = 3, rollingAvg = 3)
      final neutralVector = createNeutralVector();
      final neutralResult = await engine.getReflectionForVector(neutralVector);

      // Declined mood & trend (mood = 1, rollingAvg = 1.5)
      final declinedVector = createNeutralVector()
        ..manualMoodExists = true
        ..actualMood = 1
        ..rollingMoodAverage7Days = 1.5;

      final declinedResult = await engine.getReflectionForVector(declinedVector);

      // Burnout score and trend impact must increase
      expect(declinedResult.rawTrendImpact, greaterThan(neutralResult.rawTrendImpact));
      expect(declinedResult.burnoutScore, greaterThan(neutralResult.burnoutScore));
    });

    test('Chat sentiment influences Burnout Score dynamically', () async {
      // Positive chat
      final positiveChatVector = createNeutralVector()
        ..chatCount = 1
        ..chatSentiment = 0.8;
      final positiveChatResult = await engine.getReflectionForVector(positiveChatVector);

      // Negative chat
      final negativeChatVector = createNeutralVector()
        ..chatCount = 1
        ..chatSentiment = -0.8;
      final negativeChatResult = await engine.getReflectionForVector(negativeChatVector);

      expect(positiveChatResult.rawChatImpact, lessThan(negativeChatResult.rawChatImpact));
      expect(positiveChatResult.burnoutScore, lessThan(negativeChatResult.burnoutScore));
    });

    test('Activity pattern influences Burnout Score dynamically', () async {
      // Low activity baseline
      final lowActivityVector = createNeutralVector();
      final lowActivityResult = await engine.getReflectionForVector(lowActivityVector);

      // High activity
      final highActivityVector = createNeutralVector()
        ..sessionCount = 4
        ..timeSpentMinutes = 20
        ..interventionCount = 3;
      final highActivityResult = await engine.getReflectionForVector(highActivityVector);

      expect(highActivityResult.rawActivityImpact, lessThan(lowActivityResult.rawActivityImpact));
      expect(highActivityResult.burnoutScore, lessThan(lowActivityResult.burnoutScore));
    });

    test('Manual Mood changes influence Burnout Score dynamically (GREAT vs STRUGGLING)', () async {
      // Base vector with neutral/same journal
      final baseVector = createNeutralVector()
        ..journalCount = 1
        ..journalSentiment = 0.0
        ..journalStressScore = 0.5
        ..journalEnergyScore = 0.5;

      // 1. GREAT mood
      final greatMoodVector = MoodFeatureVector()
        ..journalCount = baseVector.journalCount
        ..journalSentiment = baseVector.journalSentiment
        ..journalStressScore = baseVector.journalStressScore
        ..journalEnergyScore = baseVector.journalEnergyScore
        ..chatCount = baseVector.chatCount
        ..timeSpentMinutes = baseVector.timeSpentMinutes
        ..sessionCount = baseVector.sessionCount
        ..interventionCount = baseVector.interventionCount
        ..manualMoodExists = true
        ..currentMood = 'GREAT'
        ..currentMoodValue = 5.0
        ..currentMoodSource = 'manual'
        ..rollingMoodAverage7Days = 3.0;

      final greatResult = await engine.getReflectionForVector(greatMoodVector);

      // 2. STRUGGLING mood
      final strugglingMoodVector = MoodFeatureVector()
        ..journalCount = baseVector.journalCount
        ..journalSentiment = baseVector.journalSentiment
        ..journalStressScore = baseVector.journalStressScore
        ..journalEnergyScore = baseVector.journalEnergyScore
        ..chatCount = baseVector.chatCount
        ..timeSpentMinutes = baseVector.timeSpentMinutes
        ..sessionCount = baseVector.sessionCount
        ..interventionCount = baseVector.interventionCount
        ..manualMoodExists = true
        ..currentMood = 'STRUGGLING'
        ..currentMoodValue = 1.0
        ..currentMoodSource = 'manual'
        ..rollingMoodAverage7Days = 3.0;

      final strugglingResult = await engine.getReflectionForVector(strugglingMoodVector);

      // GREAT mood should decrease the score, STRUGGLING mood should increase it.
      expect(greatResult.burnoutScore, lessThan(strugglingResult.burnoutScore));
      
      // There must be a visible difference of 35 points (GREAT has -15, STRUGGLING has +20)
      final difference = strugglingResult.burnoutScore - greatResult.burnoutScore;
      expect(difference, equals(35));
    });
  });
}
