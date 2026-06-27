import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/burnout_forecast.dart';
import '../../domain/models/mood_feature_vector.dart';
import '../ml/reflection_engine.dart';

class BurnoutForecastEngine {
  static final BurnoutForecastEngine instance = BurnoutForecastEngine._internal();
  BurnoutForecastEngine._internal();

  Isar get isar => IsarDatabase.instance;

  Future<BurnoutForecast> getDailyForecast() async {
    final today = DateTime.now();
    final todayMidnight = DateTime.utc(today.year, today.month, today.day);

    // Try to get cached forecast for today
    final cached = await isar.burnoutForecasts.where().dateEqualTo(todayMidnight).findFirst();
    if (cached != null) {
      return cached;
    }

    // Compute new forecast
    final end = DateTime(today.year, today.month, today.day, 23, 59, 59);
    final start = end.subtract(const Duration(days: 14)); // Look back up to 14 days

    final vectors = await isar.moodFeatureVectors
        .filter()
        .dateBetween(start, end)
        .sortByDate()
        .findAll();

    final historicalScores = <double>[];
    for (final vector in vectors) {
      try {
        final result = await ReflectionEngine.instance.getReflectionForVector(vector);
        historicalScores.add(result.burnoutScore.toDouble());
      } catch (e) {
        // Skip
      }
    }

    // Default current burnout
    double currentBurnout = 50.0;
    try {
        final currentResult = await ReflectionEngine.instance.getLatestReflection();
        currentBurnout = currentResult.burnoutScore.toDouble();
    } catch (_) {}

    if (historicalScores.isEmpty) {
        historicalScores.add(currentBurnout);
    }

    // Compute simple linear regression trend on historical scores
    double slope = 0.0;
    if (historicalScores.length > 1) {
      int n = historicalScores.length;
      double sumX = 0;
      double sumY = 0;
      double sumXY = 0;
      double sumX2 = 0;
      for (int i = 0; i < n; i++) {
        sumX += i;
        sumY += historicalScores[i];
        sumXY += i * historicalScores[i];
        sumX2 += i * i;
      }
      double denominator = (n * sumX2 - sumX * sumX);
      if (denominator != 0) {
        slope = (n * sumXY - sumX * sumY) / denominator;
      }
    }

    // Calculate forecast values
    // Ensure scores are clamped between 0 and 100
    double f1 = (currentBurnout + slope * 1).clamp(0.0, 100.0);
    double f3 = (currentBurnout + slope * 3).clamp(0.0, 100.0);
    double f7 = (currentBurnout + slope * 7).clamp(0.0, 100.0);

    // Trend string based on 7-day difference
    double delta7 = f7 - currentBurnout;
    String trend = 'Stable';
    if (delta7 > 5) {
      trend = 'Increasing'; // Burnout is going UP (bad)
    } else if (delta7 < -5) {
      trend = 'Decreasing'; // Burnout is going DOWN (good)
    }

    // Confidence based on amount of data (max 95)
    double confidence = (historicalScores.length / 14 * 100).clamp(20.0, 95.0);

    // Contributing Signals
    List<String> signals = [];
    if (historicalScores.length < 3) {
      signals.add('Insufficient historical data, using baseline estimates.');
    } else {
      if (slope > 1.5) {
        signals.add('Strong upward momentum in recent burnout risk scores.');
      } else if (slope < -1.5) {
        signals.add('Consistent recovery pattern observed over the last week.');
      } else {
        signals.add('Burnout scores have remained relatively stable.');
      }

      // Check last few days for acute stress
      if (historicalScores.length >= 3) {
         final last3 = historicalScores.sublist(historicalScores.length - 3);
         double avg3 = last3.reduce((a, b) => a + b) / 3;
         if (avg3 > 75) {
            signals.add('Sustained acute stress indicators detected recently.');
         } else if (avg3 < 30) {
            signals.add('Low stress indicators suggest healthy equilibrium.');
         }
      }
    }

    final forecast = BurnoutForecast()
      ..date = todayMidnight
      ..currentBurnout = currentBurnout
      ..forecastTomorrow = f1
      ..forecast3Days = f3
      ..forecast7Days = f7
      ..trend = trend
      ..confidence = confidence
      ..contributingSignals = signals
      ..historicalScores = historicalScores
      ..generatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.burnoutForecasts.put(forecast);
    });

    return forecast;
  }
}
