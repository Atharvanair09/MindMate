import 'package:isar/isar.dart';

part 'burnout_forecast.g.dart';

@collection
class BurnoutForecast {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date; // Store as UTC midnight to represent the calendar day

  late double currentBurnout;
  
  late double forecastTomorrow;
  
  late double forecast3Days;
  
  late double forecast7Days;
  
  late String trend; // "Increasing", "Stable", "Decreasing"
  
  late double confidence; // 0.0 - 100.0
  
  late List<String> contributingSignals;
  
  late List<double> historicalScores; // Past N days of scores

  late DateTime generatedAt;

  bool isDemoData = false;
}
