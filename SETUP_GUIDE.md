# Bean Crop Doctor - Setup Guide

## Quick Start

Your Flutter bean disease classifier app is ready to run! Follow these steps:

### 1. Verify Installation

Check that all dependencies are installed:
```bash
flutter pub get
```

### 2. Check Model File

Verify the TensorFlow Lite model is in place:
```bash
dir assets\models\bean_model.tflite
```

You should see a file of approximately 28MB.

### 3. Connect Device or Start Emulator

**For Physical Device:**
- Enable Developer Options on your Android device
- Enable USB Debugging
- Connect via USB cable

**For Emulator:**
```bash
flutter emulators
flutter emulators --launch <emulator_id>
```

### 4. Run the App

```bash
flutter run
```

The app will:
1. Load the TensorFlow Lite model (takes a few seconds)
2. Display the main screen with Camera and Gallery buttons
3. Be ready to classify bean diseases!

## Testing the App

### Test with Camera
1. Tap the "Camera" button
2. Grant camera permissions if prompted
3. Take a photo of a bean leaf
4. Wait for the AI to analyze (1-2 seconds)
5. View the diagnosis and confidence score

### Test with Gallery
1. Tap the "Gallery" button
2. Grant storage permissions if prompted
3. Select an image from your device
4. View the prediction results

## Expected Behavior

### Successful Prediction
- Disease name displayed (Angular Leaf Spot, Bean Rust, Healthy, or Non Plants)
- Confidence percentage shown
- Color-coded status:
  - Green = Healthy
  - Red/Orange = Disease detected
  - Grey = Uncertain (confidence < 70%)

### Low Confidence
If confidence is below 70%, the app shows:
- "Uncertain / Low Confidence" message
- Suggestion to try a clearer image

## Troubleshooting

### Model Loading Issues

**Problem**: "Failed to load model" error

**Solutions**:
1. Verify model file exists:
   ```bash
   dir assets\models\bean_model.tflite
   ```

2. Clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. Check pubspec.yaml has:
   ```yaml
   flutter:
     assets:
       - assets/models/
   ```

### Permission Issues

**Problem**: Camera or gallery not working

**Solutions**:
1. Check AndroidManifest.xml has permissions (already configured)
2. Manually grant permissions in device Settings > Apps > Bean Crop Doctor > Permissions
3. Restart the app after granting permissions

### Build Errors

**Problem**: Gradle build fails

**Solutions**:
1. Check Android SDK is installed
2. Verify minSdk is 21 or higher in build.gradle.kts
3. Run:
   ```bash
   cd android
   gradlew clean
   cd ..
   flutter clean
   flutter pub get
   ```

### Image Processing Issues

**Problem**: Prediction takes too long or fails

**Solutions**:
1. Ensure image is not too large (app handles resizing)
2. Check device has sufficient memory
3. Try with a smaller image from gallery
4. Restart the app

## Performance Tips

### For Best Results
- Use well-lit images
- Focus clearly on bean leaves
- Avoid blurry or distant shots
- Capture the affected area closely
- Try multiple angles if uncertain

### Model Performance
- First prediction may take 2-3 seconds (model initialization)
- Subsequent predictions are faster (< 1 second)
- Model runs entirely on-device (no internet required)

## Building for Release

### Create Release APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Create App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Install Release APK

```bash
flutter install --release
```

## Project Structure Overview

```
lib/
├── main.dart                    # App entry, Material theme
├── models/
│   └── prediction_result.dart   # Result data model
├── services/
│   └── model_service.dart       # TFLite inference logic
├── screens/
│   └── home_screen.dart         # Main UI screen
└── widgets/
    ├── image_picker_button.dart # Custom button widget
    └── result_card.dart         # Result display widget
```

## Key Features Implemented

✅ TensorFlow Lite model integration  
✅ Camera capture functionality  
✅ Gallery image selection  
✅ Image preprocessing (224x224, normalized)  
✅ Real-time prediction with confidence scores  
✅ Beautiful Material 3 UI  
✅ Error handling and loading states  
✅ Confidence threshold (70%)  
✅ Color-coded results  
✅ New scan functionality  

## Next Steps

### Enhancements You Can Add
1. **History**: Save past predictions with timestamps
2. **Export**: Share results as images or PDFs
3. **Batch Processing**: Analyze multiple images at once
4. **Treatment Suggestions**: Add disease treatment recommendations
5. **Offline Database**: Store disease information locally
6. **Multi-language**: Add internationalization support

### Model Improvements
1. Retrain with more diverse dataset
2. Add more disease classes
3. Implement model quantization for smaller size
4. Add data augmentation for better generalization

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Flutter documentation: https://flutter.dev/docs
3. Check TFLite Flutter plugin: https://pub.dev/packages/tflite_flutter

## Version Info

- Flutter SDK: 3.9.2+
- Dart SDK: 3.9.2+
- Android minSdk: 21
- Android targetSdk: 34
- Model Size: 28MB
- Input Size: 224x224 RGB

---

**Ready to go! Run `flutter run` to start the app.** 🚀
