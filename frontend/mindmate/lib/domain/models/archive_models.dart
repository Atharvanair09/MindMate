class LocalMessage {
  final String role;
  final String text;
  final DateTime timestamp;

  LocalMessage({
    required this.role,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'role': role,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
      };

  factory LocalMessage.fromJson(Map<String, dynamic> json) {
    return LocalMessage(
      role: json['role'] as String,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class LocalChat {
  final String id;
  String title;
  List<LocalMessage> messages;
  final DateTime createdAt;
  DateTime updatedAt;

  LocalChat({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'messages': messages.map((m) => m.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory LocalChat.fromJson(Map<String, dynamic> json) {
    return LocalChat(
      id: json['id'] as String,
      title: json['title'] as String,
      messages: (json['messages'] as List)
          .map((m) => LocalMessage.fromJson(m as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class JournalEntry {
  final String id;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;
  DateTime journalDate;
  String? pagesJson;

  JournalEntry({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.journalDate,
    this.pagesJson,
  });

  String get preview {
    if (content.isEmpty) return 'Empty journal';
    final lines = content.split('\n');
    return lines.first.length > 50 ? '${lines.first.substring(0, 47)}...' : lines.first;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'journalDate': journalDate.toIso8601String(),
        if (pagesJson != null) 'pagesJson': pagesJson,
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      journalDate: json['journalDate'] != null 
          ? DateTime.parse(json['journalDate'] as String) 
          : DateTime.parse(json['createdAt'] as String),
      pagesJson: json['pagesJson'] as String?,
    );
  }
}
