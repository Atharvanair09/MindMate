import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/early_warning.dart';
import '../../domain/models/burnout_forecast.dart';
import '../../domain/models/pattern_insight.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../ml/situation_detection_engine.dart';
import 'burnout_forecast_engine.dart';
import '../weekly_reflection/weekly_reflection_service.dart';

class EarlyWarningEngine {
  static final EarlyWarningEngine instance = EarlyWarningEngine._internal();
  EarlyWarningEngine._internal();

  Isar get isar => IsarDatabase.instance;

  Future<EarlyWarningAlert> evaluateWarningStatus() async {
    final now = DateTime.now();

    String level = "Green";
    List<String> reasons = [];

    try {
      // 1. Get Burnout Forecast
      final forecast = await BurnoutForecastEngine.instance.getDailyForecast();
      
      // 2. Get Weekly Reflection (Mood Trend & Burnout Trend)
      final weeklyReflection = await WeeklyReflectionService.instance.getLatestReflection();
      final moodTrend = weeklyReflection?.moodTrend ?? 'Stable';
      
      // 3. Get Situations (for Sleep Issues)
      final situations = await SituationDetectionEngine.instance.detectSituations();
      final hasSleepIssues = situations.any((s) => s.situationName == 'Sleep Issues' && s.confidence >= 50.0);

      // 4. Get Patterns
      final recentPatterns = await isar.patternInsights
          .filter()
          .associationTypeEqualTo("Lower Mood")
          .or()
          .associationTypeEqualTo("Higher Burnout")
          .sortByGeneratedAtDesc()
          .limit(3)
          .findAll();

      // Determine Alert Level
      bool isHighRisk = forecast.currentBurnout > 80 || forecast.forecast7Days > 85;
      
      bool isElevatedRisk = !isHighRisk && (
        forecast.currentBurnout > 65 || 
        forecast.forecast7Days > 75 || 
        (forecast.trend == 'Increasing' && moodTrend == 'Decreasing')
      );

      bool isEarlyWarning = !isHighRisk && !isElevatedRisk && (
        forecast.trend == 'Increasing' || 
        hasSleepIssues || 
        recentPatterns.isNotEmpty
      );

      if (isHighRisk) {
        level = "Red";
        reasons.add("Burnout risk is currently critically high or projected to reach critical levels soon.");
      } else if (isElevatedRisk) {
        level = "Orange";
        reasons.add("Elevated burnout levels detected with concerning trends.");
      } else if (isEarlyWarning) {
        level = "Yellow";
        if (forecast.trend == 'Increasing') {
          reasons.add("Burnout forecast shows an increasing trend.");
        }
        if (hasSleepIssues) {
          reasons.add("Sleep quality has declined.");
        }
        if (recentPatterns.isNotEmpty) {
          reasons.add("Negative behavior patterns have been detected.");
        }
      } else {
        level = "Green";
        reasons.add("All wellness indicators are stable.");
      }

      final alert = EarlyWarningAlert()
        ..level = level
        ..reasons = reasons
        ..generatedAt = now;

      await isar.writeTxn(() async {
        await isar.earlyWarningAlerts.put(alert);
      });

      return alert;

    } catch (e) {
      debugPrint("Error evaluating early warning status: $e");
      final defaultAlert = EarlyWarningAlert()
        ..level = "Green"
        ..reasons = ["Unable to compute status. Stable assumed."]
        ..generatedAt = now;
      return defaultAlert;
    }
  }

  Future<EarlyWarningAlert?> getLatestAlert() async {
    return await isar.earlyWarningAlerts
        .where()
        .sortByGeneratedAtDesc()
        .findFirst();
  }
}
