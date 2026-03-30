/// Notice model for admin announcements
class Notice {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String adminName;
  final bool isActive;

  Notice({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.adminName,
    this.isActive = true,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      adminName: json['adminName'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'adminName': adminName,
      'isActive': isActive,
    };
  }
}
