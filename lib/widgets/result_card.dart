import 'package:flutter/material.dart';
import '../models/prediction_result.dart';

/// Widget to display prediction results in a beautiful card
class ResultCard extends StatelessWidget {
  final PredictionResult result;

  const ResultCard({
    super.key,
    required this.result,
  });

  Color _getStatusColor() {
    switch (result.statusColor) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red.shade700;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon() {
    switch (result.statusIcon) {
      case 'check_circle':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'help':
        return Icons.help_outline;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              statusColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            // Status icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                size: 48,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 16),
            
            // Diagnosis label
            Text(
              'Diagnosis',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            
            // Disease name
            Text(
              result.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 16),
            
            // Confidence percentage
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.analytics,
                    size: 20,
                    color: statusColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Confidence: ${result.confidencePercentage}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            
            // Additional info for uncertain predictions
            if (result.isUncertain) ...[
              const SizedBox(height: 16),
              Text(
                'The model is not confident about this prediction.\nPlease try a clearer image.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
