// lib/models/journal_entry.dart

class JournalEntry {
  final String id;
  final String title;
  final String description;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.latitude,
    this.longitude,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      latitude: json['latitude'] == null
          ? null
          : (json['latitude'] as num).toDouble(),
      longitude: json['longitude'] == null
          ? null
          : (json['longitude'] as num).toDouble(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// UWAGA: nie wysyłamy pól z wartością null – MockAPI często się o to potyka.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };

    if (latitude != null) {
      map['latitude'] = latitude;
    }
    if (longitude != null) {
      map['longitude'] = longitude;
    }

    return map;
  }

  String get locationLabel {
    if (latitude == null || longitude == null) {
      return 'Brak lokalizacji';
    }
    return 'Lat: ${latitude!.toStringAsFixed(4)}, Lng: ${longitude!.toStringAsFixed(4)}';
  }
}
