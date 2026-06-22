import 'package:isar/isar.dart';

part 'mood_feature_vector.g.dart';

@collection
class MoodFeatureVector {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date;

  List<double>? journalEmbedding;
  
  List<double>? chatEmbeddingAverage;

  double? journalSentiment;

  double? journalStressScore;

  double? journalEnergyScore;
  
  double? chatSentiment;

  int? previousMood;

  double? rollingMoodAverage7Days;
  
  double? rollingMoodStd7Days;

  int journalCount = 0;
  
  int chatCount = 0;

  int timeSpentMinutes = 0;
  
  int sessionCount = 0;
  
  int interventionCount = 0;

  late int hourOfDay;
  
  late int dayOfWeek;

  bool manualMoodExists = false;

  int? actualMood; // The target variable (ground truth)

  String? currentMood;

  double? currentMoodValue;

  String? currentMoodSource;

  late String featureVersion;

  late DateTime createdAt;
}
