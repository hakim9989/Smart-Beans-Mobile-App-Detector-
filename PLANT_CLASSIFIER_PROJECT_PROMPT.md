# Plant Detection & Classification App - Complete Project Prompt

## 🎯 Project Overview

I need you to build a complete Flutter mobile application for **Plant Detection and Classification** for a final year agricultural project. This app uses **TWO TensorFlow Lite models**:

1. **Plant Detection Model** - Detects if the image contains a plant or not
2. **Plant Classification Model** - Classifies the type of plant (species/variety)

The app should have a similar UI/UX design and functionality to a previously built bean disease classifier app, but adapted for plant identification.

---

## 📱 Core Functionality

### Two-Stage AI Processing:
1. **Stage 1 (Detection):** User captures/selects image → First model checks if it's a plant
2. **Stage 2 (Classification):** If plant detected → Second model identifies the plant type
3. **Results Display:** Show detection confidence + plant classification with details

### Key Features Required:
- ✅ Camera & Gallery image selection
- ✅ Two-stage ML model processing (detection → classification)
- ✅ Real-time plant identification
- ✅ Scan history (store 50 scans locally)
- ✅ Firebase Authentication (email/password)
- ✅ Admin notice system (Firebase Realtime Database)
- ✅ Educational content about plants
- ✅ Beautiful farmer-friendly UI with plant imagery
- ✅ Dark mode support with 6 theme colors
- ✅ Offline-first architecture (works without internet after login)

---

## 🤖 AI Model Integration

### Model 1: Plant Detection Model
**Purpose:** Detect if image contains a plant

**Input Specifications:**
- Image size: [WILL BE PROVIDED]
- Format: [WILL BE PROVIDED]
- Normalization: [WILL BE PROVIDED]

**Output:**
- Binary classification: "Plant" or "Not Plant"
- Confidence score (0-1)
- Threshold: 0.7 (70%)

**File Location:** `assets/models/plant_detection.tflite`

### Model 2: Plant Classification Model
**Purpose:** Classify the type/species of plant

**Input Specifications:**
- Image size: [WILL BE PROVIDED]
- Format: [WILL BE PROVIDED]
- Normalization: [WILL BE PROVIDED]

**Output:**
- Plant species/type label
- Confidence score (0-1)
- Threshold: 0.7 (70%)
- Classes: [WILL BE PROVIDED - e.g., Tomato, Maize, Rice, Cassava, etc.]

**File Location:** `assets/models/plant_classification.tflite`

### Processing Flow:
```
User selects image
    ↓
Run Detection Model
    ↓
Is Plant? (confidence > 70%)
    ↓ YES                    ↓ NO
Run Classification Model    Show "Not a plant" message
    ↓
Display plant type + confidence
```

---

## 🎨 UI/UX Design Requirements

### Design Philosophy:
- **Farmer-friendly:** Clear, simple, intuitive
- **Agricultural theme:** Plant imagery, green colors, nature emojis (🌱🌿🍃🪴)
- **Professional:** Modern glass-morphism design
- **Animated:** Smooth transitions, floating effects, hover animations
- **Accessible:** Large buttons, clear text, high contrast

### Color Scheme:
- Primary: Green (agricultural theme)
- Secondary: Light green / Lime
- Accent: Orange (for notices/alerts)
- 6 theme options with dark mode support

### Key UI Elements:
1. **Animated plant image** - Floating/hovering effect on home screen
2. **Interactive stat cards** - Hover effects, clickable
3. **Gradient borders** - Rotating sweep gradient on tips section
4. **Loading animations** - Circular progress with AI brain icon
5. **Hero animations** - Smooth transitions between screens
6. **Bottom sheet** - Modern camera/gallery picker
7. **Notice banner** - Orange gradient banner for admin notices
8. **Confidence meter** - Progress bar showing AI confidence

---

## 📂 Project Structure

```
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   ├── prediction_result.dart
│   ├── detection_result.dart
│   ├── classification_result.dart
│   ├── scan_history.dart
│   ├── plant_info.dart
│   ├── notice.dart
│   ├── user.dart
│   └── team_member.dart
├── services/
│   ├── detection_model_service.dart      # Plant detection model
│   ├── classification_model_service.dart # Plant classification model
│   ├── model_pipeline_service.dart       # Orchestrates both models
│   ├── history_service.dart
│   ├── firebase_auth_service.dart
│   └── notice_service.dart
├── providers/
│   └── auth_provider.dart
├── screens/
│   ├── splash_screen.dart
│   ├── welcome_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── main_navigation.dart
│   ├── home_screen.dart                  # Main scanning interface
│   ├── education_screen.dart             # Plant information library
│   ├── plant_detail_screen.dart          # Detailed plant info
│   ├── history_screen.dart
│   ├── settings_screen.dart
│   ├── about_screen.dart
│   └── admin_panel_screen.dart
├── widgets/
│   ├── image_picker_button.dart
│   ├── result_card.dart
│   └── notice_popup.dart
└── utils/
    ├── app_theme.dart
    └── theme_provider.dart

assets/
├── models/
│   ├── plant_detection.tflite           # Detection model
│   └── plant_classification.tflite      # Classification model
└── images/
    └── plant_background.jpg              # Plant/farm background image

android/
└── app/
    ├── build.gradle.kts
    ├── google-services.json
    └── proguard-rules.pro
```

---

## 🔥 Firebase Configuration

### Firebase Services Required:
1. **Firebase Authentication** - Email/password only (NO Firestore to avoid costs)
2. **Firebase Realtime Database** - For admin notices (FREE tier)

### Firebase Setup:
- Project name: `plant-classifier` (or similar)
- Database URL: [TO BE CREATED]
- Admin email: [TO BE PROVIDED]
- User name stored in: Firebase Auth `displayName` field

### Firebase Rules (Realtime Database):
```json
{
  "rules": {
    ".read": true,
    ".write": true,
    "notices": {
      ".indexOn": ["timestamp"]
    }
  }
}
```

---

## 📱 Screen Details

### 1. Splash Screen
- Animated plant image with glow effect
- App logo and name
- Loading animation
- Auto-navigate to Welcome or Home (if logged in)

### 2. Welcome Screen
- Full-screen plant/farm background image
- Gradient overlay for readability
- "Welcome to Plant Classifier" title
- Two buttons: "Login" and "Sign Up"
- Glass-morphism design

### 3. Login Screen
- Plant background with gradient overlay
- Email and password fields with validation
- "Forgot Password?" link
- "Login" button
- "Don't have an account? Sign Up" link

### 4. Signup Screen
- Plant background with gradient overlay
- Fields: Name, Email, Password, Confirm Password
- Validation for all fields
- "Sign Up" button
- "Already have an account? Login" link

### 5. Home Screen (Main Interface)
**Top Section:**
- Custom SliverAppBar with user greeting: "Hello, [Name]! 👋"
- Subtitle: "🌿 Plant Identification"

**Notice Banner (if unread notice):**
- Orange gradient banner
- Shows latest admin notice
- Tappable to view full notice

**Stats Cards:**
- Total Scans (clickable → navigates to History)
- Accuracy (95%)
- Interactive hover effects

**Quick Tips Section:**
- Animated gradient border (rotating)
- Tips for best scanning results:
  - 📸 Use good lighting
  - 🎯 Focus on the plant
  - 📏 Get close to capture details
  - ✨ Avoid blurry images

**Scanning Section:**
- Large tappable plant image (floating animation)
- Shows loading spinner during processing
- Two-stage loading:
  - "Detecting plant..." (Stage 1)
  - "Classifying plant type..." (Stage 2)
- Alternative: Camera and Gallery buttons below

**Results Section (after scan):**
- Hero animation for image display
- Detection result: "Plant Detected ✓" or "Not a Plant ✗"
- Classification result (if plant): Plant type/species
- Confidence meters for both models
- Action buttons: "New Scan", "Save", "Learn More"

### 6. Education Screen
- Library of plant information
- Grid/list of plant cards
- Search functionality
- Categories: Crops, Flowers, Trees, Herbs, etc.
- Tap card → Plant Detail Screen

### 7. Plant Detail Screen
- Plant image
- Scientific name
- Common names
- Description
- Growing conditions
- Uses/benefits
- Care instructions

### 8. History Screen
- List of past scans
- Shows: Image thumbnail, plant type, date, confidence
- Tap to view full details
- Delete option
- Filter by date/plant type

### 9. Settings Screen
- User profile section
- Theme selector (6 colors + dark mode)
- Account management
- Admin Panel button (only for admin)
- About button
- Logout button

### 10. About Screen
- Team information
- Team members with roles
- Project description
- Version info

### 11. Admin Panel (Admin Only)
- Post notices to all users
- View all notices
- Delete notices
- Real-time sync via Firebase

---

## 🔧 Technical Requirements

### Flutter Dependencies:
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  firebase_database: ^11.1.4
  
  # ML/AI
  tflite_flutter: ^0.11.0
  image_picker: ^1.1.2
  image: ^4.0.0
  
  # State Management
  provider: ^6.1.2
  
  # Local Storage
  shared_preferences: ^2.3.3
  path_provider: ^2.1.4
  
  # UI
  flutter_svg: ^2.0.10
```

### Android Configuration:
- `compileSdk`: 36
- `minSdk`: 21
- `targetSdk`: 36
- Disable minification (to avoid TensorFlow Lite issues)
- ProGuard rules for TensorFlow Lite

### Model Service Architecture:

**DetectionModelService:**
```dart
class DetectionModelService {
  Future<void> loadModel();
  Future<DetectionResult> detectPlant(File image);
  void dispose();
}
```

**ClassificationModelService:**
```dart
class ClassificationModelService {
  Future<void> loadModel();
  Future<ClassificationResult> classifyPlant(File image);
  void dispose();
}
```

**ModelPipelineService (Orchestrator):**
```dart
class ModelPipelineService {
  final DetectionModelService _detectionService;
  final ClassificationModelService _classificationService;
  
  Future<PredictionResult> processImage(File image) async {
    // Stage 1: Detection
    final detection = await _detectionService.detectPlant(image);
    
    if (!detection.isPlant || detection.confidence < 0.7) {
      return PredictionResult.notPlant(detection);
    }
    
    // Stage 2: Classification
    final classification = await _classificationService.classifyPlant(image);
    
    return PredictionResult.success(detection, classification);
  }
}
```

---

## 🎯 Key Features Implementation

### 1. Two-Stage Model Processing
- Load both models on app startup
- Show progress for each stage
- Handle errors gracefully
- Display results from both models

### 2. Scan History
- Store locally using SharedPreferences
- Save: image path, detection result, classification result, timestamp
- Limit to 50 scans
- Display in reverse chronological order

### 3. Admin Notice System
- Admin email: [TO BE PROVIDED]
- Post notices from admin panel
- Sync to Firebase Realtime Database
- Show banner on home screen
- Popup after 500ms
- Mark as seen (stored locally)
- Each notice shows once per user

### 4. Interactive Animations
- Floating plant image (±8px, 2s cycle)
- Hover effects on stat cards (scale 1.05, shadow change)
- Rotating gradient border on tips (3s cycle)
- Loading spinner with AI icon
- Hero animations for images
- Smooth page transitions

### 5. Offline Support
- Models loaded locally
- History stored locally
- Works without internet after login
- Firebase only for auth and notices

---

## 📊 Data Models

### DetectionResult
```dart
class DetectionResult {
  final bool isPlant;
  final double confidence;
  final String message;
}
```

### ClassificationResult
```dart
class ClassificationResult {
  final String plantType;
  final String scientificName;
  final double confidence;
  final List<String> alternativePredictions;
}
```

### PredictionResult
```dart
class PredictionResult {
  final DetectionResult detection;
  final ClassificationResult? classification;
  final bool isSuccess;
  final String displayMessage;
}
```

### ScanHistory
```dart
class ScanHistory {
  final String id;
  final String imagePath;
  final bool isPlant;
  final String? plantType;
  final double detectionConfidence;
  final double? classificationConfidence;
  final DateTime timestamp;
}
```

### PlantInfo
```dart
class PlantInfo {
  final String name;
  final String scientificName;
  final String description;
  final String category;
  final String imageUrl;
  final List<String> commonNames;
  final String growingConditions;
  final String uses;
  final String careInstructions;
}
```

---

## 🎨 UI Components

### Interactive Stat Card
- Hover animation (scale, shadow, elevation)
- Touch feedback
- Optional onTap callback
- Arrow icon appears on hover
- Icon color changes on interaction

### Notice Banner
- Orange gradient background
- Campaign icon
- Title and preview text
- Arrow icon
- Tappable to show full popup

### Notice Popup
- Modal dialog
- Admin name and timestamp
- Full message
- Dismiss button
- Marks notice as seen

### Result Card
- Gradient header with status color
- Icon based on result (check, warning, error)
- Confidence meter with progress bar
- Action buttons
- "Learn more" link

### Image Picker Bottom Sheet
- Handle bar
- Title with plant emoji
- Two options: Camera and Gallery
- Icons with colored backgrounds
- Smooth slide-up animation

---

## 🔐 Security & Best Practices

### Authentication:
- Email validation
- Password strength requirements (min 6 characters)
- Confirm password matching
- Error handling for Firebase Auth errors
- Auto-logout on token expiry

### Data Privacy:
- No personal data sent to cloud (except email for auth)
- Images stored locally only
- History stored locally
- Admin notices are public (no sensitive data)

### Performance:
- Lazy load models
- Compress images before processing
- Limit history to 50 items
- Dispose controllers properly
- Use const constructors where possible

### Error Handling:
- Try-catch blocks for all async operations
- User-friendly error messages
- Fallback UI for errors
- Retry mechanisms for network calls

---

## 📝 Educational Content

Create a library of plant information including:

### Categories:
1. **Food Crops** - Maize, Rice, Cassava, Yam, etc.
2. **Vegetables** - Tomato, Pepper, Onion, etc.
3. **Fruits** - Mango, Orange, Banana, etc.
4. **Flowers** - Rose, Sunflower, Hibiscus, etc.
5. **Trees** - Oak, Pine, Palm, etc.
6. **Herbs** - Basil, Mint, Thyme, etc.

### Information for Each Plant:
- Common name
- Scientific name
- Description
- Growing conditions (soil, water, sunlight)
- Planting season
- Harvesting time
- Uses and benefits
- Care instructions
- Common pests/diseases
- Interesting facts

---

## 🚀 Build & Deployment

### Development:
```bash
flutter pub get
flutter run
```

### Build APK:
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Build Split APKs (smaller):
```bash
flutter build apk --split-per-abi
```

### ProGuard Configuration:
- Disable minification for release builds
- Add TensorFlow Lite keep rules
- Add Firebase keep rules

---

## ✅ Testing Checklist

### Functionality:
- [ ] Both models load successfully
- [ ] Detection model works correctly
- [ ] Classification model works correctly
- [ ] Camera capture works
- [ ] Gallery selection works
- [ ] Results display correctly
- [ ] History saves and loads
- [ ] Firebase auth works (signup, login, logout)
- [ ] Admin notices sync across devices
- [ ] Theme changes work
- [ ] Dark mode works
- [ ] Navigation works smoothly

### UI/UX:
- [ ] Animations are smooth
- [ ] Loading states are clear
- [ ] Error messages are helpful
- [ ] Images display correctly
- [ ] Text is readable
- [ ] Buttons are responsive
- [ ] Layout adapts to different screen sizes

### Performance:
- [ ] App starts quickly
- [ ] Models load in reasonable time
- [ ] Predictions are fast (< 3 seconds)
- [ ] No memory leaks
- [ ] Smooth scrolling
- [ ] No frame drops

---

## 📋 Deliverables

1. ✅ Complete Flutter project source code
2. ✅ Two TensorFlow Lite models (.tflite files)
3. ✅ Firebase configuration files
4. ✅ Plant background image
5. ✅ README with setup instructions
6. ✅ Build instructions
7. ✅ APK file (release build)
8. ✅ Documentation

---

## 👥 Team Information

**Team Name:** [TO BE PROVIDED]

**Team Members:**
1. [Name] - [Role]
2. [Name] - [Role]
3. [Name] - [Role]
4. [Name] - [Role]
5. [Name] - [Role]

**Admin Email:** [TO BE PROVIDED]

---

## 🎓 Project Context

This is a **final year agricultural project** for university students. The app should:
- Be professional and production-ready
- Have a clean, modern UI
- Work reliably offline (after initial login)
- Be easy to demonstrate
- Impress supervisors and examiners
- Be suitable for real-world use by farmers

---

## 📞 Important Notes

### DO's:
✅ Use only theme colors (minimalist professional design)
✅ Use Firebase Auth only (NO Firestore to avoid costs)
✅ Store user name in Firebase Auth displayName
✅ Use Firebase Realtime Database for notices (FREE tier)
✅ Make UI farmer-friendly with plant imagery
✅ Add plant emojis throughout (🌱🌿🍃🪴)
✅ Show loading animation immediately when image selected
✅ Use two-stage processing (detection → classification)
✅ Handle "not a plant" case gracefully
✅ Test on real devices before delivery

### DON'Ts:
❌ Don't use Firestore (costs money)
❌ Don't use too many colors (keep it professional)
❌ Don't make UI complicated
❌ Don't skip error handling
❌ Don't forget ProGuard rules for TensorFlow Lite
❌ Don't enable minification (causes TensorFlow issues)
❌ Don't forget to add Firebase index on timestamp

---

## 🔄 Model Integration Steps

### Step 1: Receive Model Files
You will provide:
- `plant_detection.tflite` - Detection model
- `plant_classification.tflite` - Classification model

### Step 2: Model Specifications
You will provide for each model:
- Input image size (e.g., 224x224)
- Input format (RGB, grayscale, etc.)
- Normalization range (e.g., [0,1] or [-1,1])
- Output format (class labels, indices, etc.)
- Number of classes
- Class names/labels

### Step 3: Integration
I will:
- Create model service classes
- Implement preprocessing
- Implement postprocessing
- Handle model loading
- Implement two-stage pipeline
- Add error handling
- Test with sample images

---

## 🎯 Success Criteria

The project is successful when:
1. ✅ Both models work accurately
2. ✅ UI is beautiful and farmer-friendly
3. ✅ All features work as specified
4. ✅ App builds successfully (APK)
5. ✅ Firebase integration works
6. ✅ Admin notices sync across devices
7. ✅ App works offline (after login)
8. ✅ No crashes or major bugs
9. ✅ Performance is good (fast predictions)
10. ✅ Code is clean and well-documented

---

## 📦 Next Steps

1. **Provide Model Files:**
   - Send `plant_detection.tflite`
   - Send `plant_classification.tflite`

2. **Provide Model Specifications:**
   - Input size, format, normalization for each model
   - Output format and class labels
   - Any preprocessing requirements

3. **Provide Project Details:**
   - Team name and members
   - Admin email
   - Firebase project name (or I'll create one)
   - Plant background image (or I'll find one)

4. **Start Development:**
   - I'll build the complete app
   - Following this exact specification
   - With the same quality as the bean disease app

---

## 💡 Example Usage

**User Flow:**
1. User opens app → Sees splash screen
2. User logs in → Goes to home screen
3. User taps animated plant image → Bottom sheet appears
4. User selects "Camera" → Takes photo
5. Loading starts: "Detecting plant..."
6. Detection model runs → "Plant detected! ✓"
7. Loading continues: "Classifying plant type..."
8. Classification model runs → "Tomato Plant (95% confidence)"
9. Results display with both confidences
10. User taps "Learn More" → Sees tomato plant details
11. User taps "Save" → Saved to history
12. User taps "New Scan" → Returns to scanning interface

---

**Ready to start? Provide the model files and specifications, and I'll build your complete Plant Detection & Classification app!** 🚀🌱

