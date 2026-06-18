import 'package:isar/isar.dart';

part 'prediction_log.g.dart';

@collection
class PredictionLog {
  Id id = Isar.autoIncrement;

  late String predictedMood;

  late double confidence;

  late DateTime createdAt;

  String? actualMood;

  bool correctedByUser = false;
}
