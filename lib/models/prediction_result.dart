/// Data model for prediction results
class PredictionResult {
  final String label;
  final double confidence;
  final bool isUncertain;

  PredictionResult({
    required this.label,
    required this.confidence,
    required this.isUncertain,
  });

  /// Get color based on disease type
  String get statusColor {
    if (isUncertain) return 'grey';
    if (label.toLowerCase().contains('healthy')) return 'green';
    return 'red';
  }

  /// Get icon based on disease type
  String get statusIcon {
    if (isUncertain) return 'help';
    if (label.toLowerCase().contains('healthy')) return 'check_circle';
    return 'warning';
  }

  /// Format confidence as percentage
  String get confidencePercentage {
    return '${(confidence * 100).toStringAsFixed(1)}%';
  }
}
