# After Firebase Setup - Next Steps

## 🎯 What to Do After Firebase is Configured

Once you've run all the Firebase setup commands, here's what to do next:

## ✅ Step 1: Verify Firebase Files

Check that these files were created:

### 1. `lib/firebase_options.dart`
This file should exist and contain your Firebase configuration.

### 2. `android/app/google-services.json`
This file should exist with your Android app configuration.

### 3. iOS files (if you selected iOS)
- `ios/Runner/GoogleService-Info.plist`
- `ios/firebase_app_id_file.json`

## 🔄 Step 2: Update main.dart

Replace your current `lib/main.dart` with the Firebase-enabled version:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'utils/theme_provider.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const BeanCropDoctorApp(),
    ),
  );
}

class BeanCropDoctorApp extends StatelessWidget {
  const BeanCropDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'Bean Crop Doctor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(themeProvider.themeColor, false),
      darkTheme: AppTheme.getTheme(themeProvider.themeColor, true),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
```

## 🔐 Step 3: Update AuthService (Optional)

You have two options:

### Option A: Keep Local Authentication (Current)
- Continue using `lib/services/auth_service.dart`
- Data stored locally with SharedPreferences
- Works offline
- No server required

### Option B: Switch to Firebase Authentication
- Use Firebase Auth for user management
- Data stored in cloud
- Sync across devices
- Requires internet connection

**To switch to Firebase Auth:**

1. Rename current auth service:
```bash
mv lib/services/auth_service.dart lib/services/auth_service_local.dart.backup
```

2. Create new Firebase auth service:
```bash
# Copy the example file
cp lib/services/firebase_auth_service.dart.example lib/services/firebase_auth_service.dart
```

3. Update imports in login/signup screens:
```dart
// Change from:
import '../services/auth_service.dart';

// To:
import '../services/firebase_auth_service.dart';
```

## 📊 Step 4: Enable Firebase Services

### Enable Authentication

1. Go to Firebase Console: https://console.firebase.google.com/
2. Select your project: `bean-crop-doctor`
3. Click "Authentication" in left menu
4. Click "Get started"
5. Click "Sign-in method" tab
6. Enable "Email/Password":
   - Click on "Email/Password"
   - Toggle "Enable"
   - Click "Save"

### Enable Cloud Firestore

1. In Firebase Console, click "Firestore Database"
2. Click "Create database"
3. Select "Start in test mode" (for development)
4. Choose location (e.g., `us-central`)
5. Click "Enable"

### Set Firestore Security Rules

For development, use these rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Scan history - users can only access their own
    match /scan_history/{userId}/scans/{scanId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Disease info - public read
    match /diseases/{diseaseId} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

## 🧪 Step 5: Test Firebase Connection

Run your app:

```bash
flutter run
```

**Check console logs for:**
```
[VERBOSE] Initializing Firebase
[VERBOSE] Firebase initialized successfully
```

**If you see errors:**
1. Run `flutter clean`
2. Run `flutter pub get`
3. Try again

## 📱 Step 6: Test Authentication

### With Local Auth (Current):
1. Open app
2. Sign up with test account
3. Verify login works
4. Check logout works

### With Firebase Auth:
1. Open app
2. Sign up with test account
3. Check Firebase Console → Authentication → Users
4. You should see the new user listed
5. Test login and logout

## 🗄️ Step 7: Migrate Data to Firestore (Optional)

If you want to store scan history in the cloud:

### Create Firestore Service

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/scan_history.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save scan to Firestore
  Future<void> saveScan(ScanHistory scan) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('scan_history')
        .doc(userId)
        .collection('scans')
        .doc(scan.id)
        .set(scan.toJson());
  }

  /// Get scan history from Firestore
  Future<List<ScanHistory>> getHistory() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await _firestore
        .collection('scan_history')
        .doc(userId)
        .collection('scans')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) => ScanHistory.fromJson(doc.data()))
        .toList();
  }

  /// Delete scan from Firestore
  Future<void> deleteScan(String scanId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('scan_history')
        .doc(userId)
        .collection('scans')
        .doc(scanId)
        .delete();
  }

  /// Clear all history from Firestore
  Future<void> clearHistory() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final batch = _firestore.batch();
    final snapshot = await _firestore
        .collection('scan_history')
        .doc(userId)
        .collection('scans')
        .get();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
```

## 🎨 Step 8: Update UI for Firebase (Optional)

If using Firebase Auth, you can add:

### Real-time Auth State Listener

In `splash_screen.dart`:

```dart
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    if (snapshot.hasData) {
      return MainNavigation();
    }
    
    return LoginScreen();
  },
)
```

### User Profile Display

In `settings_screen.dart`:

```dart
FutureBuilder<User?>(
  future: FirebaseAuth.instance.currentUser,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListTile(
        title: Text(snapshot.data!.displayName ?? 'User'),
        subtitle: Text(snapshot.data!.email ?? ''),
      );
    }
    return SizedBox();
  },
)
```

## 📊 Step 9: Monitor Firebase Usage

### Firebase Console Dashboards

1. **Authentication**: See user signups and logins
2. **Firestore**: Monitor database reads/writes
3. **Performance**: Track app performance
4. **Crashlytics**: Monitor crashes (if enabled)

### Usage Limits (Free Tier)

- **Authentication**: Unlimited
- **Firestore**: 
  - 50K reads/day
  - 20K writes/day
  - 1GB storage
- **Storage**: 5GB

## 🔒 Step 10: Security Best Practices

### 1. Update Firestore Rules for Production

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /scan_history/{userId}/scans/{scanId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 2. Enable App Check (Optional)

Protects your backend from abuse:

```bash
flutter pub add firebase_app_check
```

### 3. Set Up Email Verification

```dart
await FirebaseAuth.instance.currentUser?.sendEmailVerification();
```

## 🚀 Step 11: Deploy and Test

### Test on Real Device

```bash
flutter run --release
```

### Build APK

```bash
flutter build apk --release
```

### Test All Features

- [ ] User registration
- [ ] User login
- [ ] Logout
- [ ] Scan and save
- [ ] View history
- [ ] Theme changes
- [ ] Offline functionality

## 📚 Additional Firebase Features

### You Can Also Add:

1. **Firebase Storage**: Store scan images in cloud
2. **Cloud Functions**: Server-side logic
3. **Firebase Analytics**: Track user behavior
4. **Crashlytics**: Monitor app crashes
5. **Remote Config**: Update app without releasing
6. **Cloud Messaging**: Push notifications

## 🎯 Quick Decision Guide

### Use Local Auth If:
- ✅ You want offline-first app
- ✅ No need for cloud sync
- ✅ Simple user management
- ✅ No server costs

### Use Firebase Auth If:
- ✅ Need cloud sync
- ✅ Multi-device support
- ✅ Advanced auth features
- ✅ Scalable solution

## 📝 Summary

After Firebase setup:

1. ✅ Verify files created
2. ✅ Update main.dart with Firebase init
3. ✅ Enable Auth and Firestore in console
4. ✅ Test app runs without errors
5. ✅ Decide: Local or Firebase auth
6. ✅ Update services if switching to Firebase
7. ✅ Test authentication flow
8. ✅ Monitor usage in Firebase Console

**Your app is now Firebase-ready!** 🔥

---

**Current Status**: Local auth working ✅  
**Next Step**: Run Firebase setup commands  
**After Setup**: Decide to keep local or switch to Firebase auth
