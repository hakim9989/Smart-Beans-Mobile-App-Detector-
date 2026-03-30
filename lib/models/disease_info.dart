/// Disease information model for education section
class DiseaseInfo {
  final String name;
  final String description;
  final List<String> symptoms;
  final List<String> causes;
  final List<String> prevention;
  final List<String> treatment;
  final String iconEmoji;

  DiseaseInfo({
    required this.name,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.prevention,
    required this.treatment,
    required this.iconEmoji,
  });

  static List<DiseaseInfo> getAllDiseases() {
    return [
      DiseaseInfo(
        name: 'Angular Leaf Spot',
        iconEmoji: '🍂',
        description: 'Angular Leaf Spot is a bacterial disease caused by Pseudomonas syringae pv. phaseolicola. It affects bean plants, causing angular lesions on leaves.',
        symptoms: [
          'Small, angular, water-soaked spots on leaves',
          'Spots turn brown or reddish-brown with yellow halos',
          'Lesions follow leaf veins creating angular patterns',
          'Leaves may become distorted and drop prematurely',
          'Pods may develop dark, sunken lesions',
        ],
        causes: [
          'Bacterial infection (Pseudomonas syringae)',
          'Spread through infected seeds',
          'Transmitted by rain splash and wind',
          'Thrives in cool, wet conditions',
          'Can survive in crop debris',
        ],
        prevention: [
          'Use certified disease-free seeds',
          'Practice crop rotation (2-3 years)',
          'Avoid overhead irrigation',
          'Remove and destroy infected plant debris',
          'Maintain proper plant spacing for air circulation',
          'Apply copper-based bactericides preventively',
        ],
        treatment: [
          'Remove and destroy infected plants',
          'Apply copper-based bactericides',
          'Improve air circulation around plants',
          'Avoid working with plants when wet',
          'Use resistant bean varieties when available',
        ],
      ),
      DiseaseInfo(
        name: 'Bean Rust',
        iconEmoji: '🦠',
        description: 'Bean Rust is a fungal disease caused by Uromyces appendiculatus. It produces rust-colored pustules on leaves and can significantly reduce yield.',
        symptoms: [
          'Small, circular, white spots on leaves',
          'Spots develop into rust-colored pustules',
          'Pustules appear on both leaf surfaces',
          'Severe infections cause leaf yellowing',
          'Premature leaf drop in advanced stages',
          'Reduced pod formation and quality',
        ],
        causes: [
          'Fungal infection (Uromyces appendiculatus)',
          'Spreads through airborne spores',
          'Favored by warm, humid conditions',
          'Thrives in temperatures 17-27°C',
          'High humidity and leaf wetness promote infection',
        ],
        prevention: [
          'Plant rust-resistant bean varieties',
          'Ensure adequate plant spacing',
          'Avoid overhead watering',
          'Remove volunteer bean plants',
          'Practice crop rotation',
          'Apply fungicides preventively in high-risk areas',
        ],
        treatment: [
          'Apply sulfur-based fungicides',
          'Use systemic fungicides for severe infections',
          'Remove heavily infected leaves',
          'Improve air circulation',
          'Water early in the day to allow foliage to dry',
          'Consider resistant varieties for future plantings',
        ],
      ),
      DiseaseInfo(
        name: 'Healthy Bean Plant',
        iconEmoji: '✅',
        description: 'A healthy bean plant shows vigorous growth, vibrant green leaves, and no signs of disease or pest damage. Proper care ensures optimal yield.',
        symptoms: [
          'Vibrant, uniform green leaves',
          'Strong, upright stems',
          'No spots, lesions, or discoloration',
          'Active growth and new leaf development',
          'Healthy root system',
          'Normal pod development',
        ],
        causes: [
          'Optimal growing conditions',
          'Proper soil nutrition',
          'Adequate water supply',
          'Good air circulation',
          'Disease-free seeds',
          'Proper pest management',
        ],
        prevention: [
          'Maintain soil pH between 6.0-7.0',
          'Provide consistent moisture',
          'Apply balanced fertilizer',
          'Ensure 6-8 hours of sunlight daily',
          'Practice good garden hygiene',
          'Monitor regularly for early problem detection',
        ],
        treatment: [
          'Continue regular watering schedule',
          'Maintain proper fertilization',
          'Monitor for any changes',
          'Harvest at appropriate maturity',
          'Save seeds from healthy plants',
          'Document successful practices',
        ],
      ),
      DiseaseInfo(
        name: 'Non Plants',
        iconEmoji: '🚫',
        description: 'The scanned image does not appear to be a bean plant. This classifier is specifically trained to identify bean plant diseases and may not work correctly with other objects.',
        symptoms: [
          'Image does not contain bean plant leaves',
          'May be a different plant species',
          'Could be an inanimate object',
          'Might be a blurry or unclear image',
          'Background or non-plant material detected',
        ],
        causes: [
          'Wrong plant species scanned',
          'Non-plant object in the image',
          'Poor image quality or focus',
          'Incorrect camera angle',
          'Background interference',
        ],
        prevention: [
          'Ensure you are scanning bean plant leaves',
          'Focus the camera on the leaf surface',
          'Use good lighting conditions',
          'Get close to the plant for clear images',
          'Avoid capturing too much background',
          'Make sure the leaf fills most of the frame',
        ],
        treatment: [
          'Retake the image with a bean plant leaf',
          'Ensure proper focus and lighting',
          'Capture only the leaf area',
          'Try different angles if needed',
          'Clean the camera lens if blurry',
          'Use the app only for bean plant diagnosis',
        ],
      ),
    ];
  }
}
