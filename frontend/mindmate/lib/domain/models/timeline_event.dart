class TimelineEvent {
  final String id;
  final String eventType;
  final String title;
  final String description;
  final DateTime eventDate;
  final String importance; // 'HIGH', 'MEDIUM', 'LOW'
  final String sourceId;
  final DateTime generatedAt;
  final bool? isPositive;

  TimelineEvent({
    required this.id,
    required this.eventType,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.importance,
    required this.sourceId,
    required this.generatedAt,
    this.isPositive,
  });
}
