import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../models/prediction_result.dart';

/// Service for handling TensorFlow Lite model operations
class ModelService {
  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  // Model configuration
  static const String modelPath = 'assets/models/bean_model.tflite';
  static const int inputSize = 224;
  static const double confidenceThreshold = 0.7;
  
  // Class labels (alphabetically sorted as per training)
  static const List<String> labels = [
    'Angular Leaf Spot',
    'Bean Rust',
    'Healthy',
    'Non Plants',
  ];

  bool get isModelLoaded => _isModelLoaded;

  /// Load the TFLite model
  Future<void> loadModel() async {
    try {
      print('Loading TFLite model from $modelPath...');
      
      _interpreter = await Interpreter.fromAsset(modelPath);
      _isModelLoaded = true;
      
      print('Model loaded successfully');
      print('Input shape: ${_interpreter!.getInputTensors()}');
      print('Output shape: ${_interpreter!.getOutputTensors()}');
    } catch (e) {
      print('Error loading model: $e');
      _isModelLoaded = false;
      rethrow;
    }
  }

  /// Preprocess image for model input
  List<List<List<List<double>>>> _preprocessImage(File imageFile) {
    // Read and decode image
    final imageBytes = imageFile.readAsBytesSync();
    img.Image? image = img.decodeImage(imageBytes);
    
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Resize to 224x224
    img.Image resizedImage = img.copyResize(
      image,
      width: inputSize,
      height: inputSize,
    );

    // Convert to normalized float array [0, 1]
    // Format: NHWC (batch, height, width, channels)
    List<List<List<List<double>>>> input = List.generate(
      1, // batch size
      (b) => List.generate(
        inputSize, // height
        (y) => List.generate(
          inputSize, // width
          (x) {
            final pixel = resizedImage.getPixel(x, y);
            return [
              pixel.r / 255.0, // Red channel normalized
              pixel.g / 255.0, // Green channel normalized
              pixel.b / 255.0, // Blue channel normalized
            ];
          },
        ),
      ),
    );

    return input;
  }

  /// Run inference on the image
  Future<PredictionResult> predict(File imageFile) async {
    if (!_isModelLoaded || _interpreter == null) {
      throw Exception('Model not loaded. Call loadModel() first.');
    }

    try {
      print('Preprocessing image...');
      final input = _preprocessImage(imageFile);
      
      // Prepare output buffer
      final output = List.filled(1, List.filled(labels.length, 0.0)).map((e) => List<double>.from(e)).toList();
      
      print('Running inference...');
      _interpreter!.run(input, output);
      
      // Get predictions
      final predictions = output[0];
      print('Raw predictions: $predictions');
      
      // Find the class with highest confidence
      double maxConfidence = 0.0;
      int maxIndex = 0;
      
      for (int i = 0; i < predictions.length; i++) {
        if (predictions[i] > maxConfidence) {
          maxConfidence = predictions[i];
          maxIndex = i;
        }
      }
      
      final predictedLabel = labels[maxIndex];
      final isUncertain = maxConfidence < confidenceThreshold;
      
      print('Predicted: $predictedLabel with confidence: ${(maxConfidence * 100).toStringAsFixed(2)}%');
      
      return PredictionResult(
        label: isUncertain ? 'Uncertain / Low Confidence' : predictedLabel,
        confidence: maxConfidence,
        isUncertain: isUncertain,
      );
    } catch (e) {
      print('Error during prediction: $e');
      rethrow;
    }
  }

  /// Clean up resources
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isModelLoaded = false;
    print('Model resources disposed');
  }
}
