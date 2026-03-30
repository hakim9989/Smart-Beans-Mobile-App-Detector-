/// Model for scan history
class ScanHistory {
  final String id;
  final String imagePath;
  final String diagnosis;
  final double confidence;
  final DateTime timestamp;

  ScanHistory({
    required this.id,
    required this.imagePath,
    required this.diagnosis,
    required this.confidence,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'diagnosis': diagnosis,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ScanHistory.fromJson(Map<String, dynamic> json) {
    return ScanHistory(
      id: json['id'],
      imagePath: json['imagePath'],
      diagnosis: json['diagnosis'],
      confidence: json['confidence'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String get confidencePercentage {
    return '${(confidence * 100).toStringAsFixed(1)}%';
  }
}
