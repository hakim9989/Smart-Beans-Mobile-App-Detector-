# Firebase Setup Guide - Bean Crop Doctor


## 🔥 Complete Firebase Integration

This guide will help you set up Firebase CLI and integrate it into your Flutter app.

## 📋 Prerequisites

Before starting, ensure you have:
- ✅ Node.js installed (for Firebase CLI)
- ✅ Flutter SDK installed
- ✅ Google account (for Firebase Console)
- ✅ Your app running locally

## 🚀 Step-by-Step Setup

### Step 1: Install Firebase CLI

Open your terminal and run:

```bash
npm install -g firebase-tools
```

**Verify installation:**
```bash
firebase --version
```

### Step 2: Login to Firebase

```bash
firebase login
```

This will:
- Open your browser
- Ask you to sign in with Google
- Grant permissions to Firebase CLI

**If already logged in, verify with:**
```bash
firebase projects:list
```

### Step 3: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

**Verify installation:**
```bash
flutterfire --version
```

**If command not found, add to PATH:**

**Windows (PowerShell):**
```powershell
$env:Path += ";$env:USERPROFILE\AppData\Local\Pub\Cache\bin"
```

**Or permanently add:**
```
C:\Users\YourUsername\AppData\Local\Pub\Cache\bin
```
to your System Environment Variables PATH.

### Step 4: Create Firebase Project

**Option A: Via Firebase Console (Recommended)**
1. Go to https://console.firebase.google.com/
2. Click "Add project"
3. Enter project name: `bean-crop-doctor`
4. Accept terms and click "Continue"
5. Disable Google Analytics (optional) or configure it
6. Click "Create project"
7. Wait for project creation
8. Click "Continue"
flutterfire configure
**Option B: Via CLI**
```bash
firebase projects:create bean-crop-doctor
```

### Step 5: Navigate to Your Project Directory

```bash
cd C:\Users\navig\StudioProjects\bean_model
```

### Step 6: Configure FlutterFire

Run the FlutterFire configuration command:

```bash
flutterfire configure
```

**This will:**
1. Ask you to select a Firebase project (choose `bean-crop-doctor`)
2. Ask which platforms to support:
   - Select: `android` (use spacebar to select)
   - Select: `ios` (optional, if you want iOS support)
   - Press Enter to confirm
3. Automatically create `firebase_options.dart`
4. Update platform-specific configuration files

**Expected output:**
```
✔ Firebase project selected: bean-crop-doctor
✔ Registered Android app
✔ Registered iOS app (if selected)
✔ Generated firebase_options.dart
```

### Step 7: Add Firebase Dependencies

Add Firebase packages to your `pubspec.yaml`:

```bash
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add cloud_firestore
```

**Or manually add to pubspec.yaml:**
```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
```

Then run:
```bash
flutter pub get
```

### Step 8: Enable Firebase Authentication

**Via Firebase Console:**
1. Go to https://console.firebase.google.com/
2. Select your project: `bean-crop-doctor`
3. Click "Authentication" in left menu
4. Click "Get started"
5. Click "Sign-in method" tab
6. Enable "Email/Password"
   - Click on "Email/Password"
   - Toggle "Enable"
   - Click "Save"

**Via CLI (alternative):**
```bash
firebase init auth
```

### Step 9: Enable Cloud Firestore

**Via Firebase Console:**
1. In Firebase Console, click "Firestore Database"
2. Click "Create database"
3. Select "Start in test mode" (for development)
4. Choose location (e.g., `us-central`)
5. Click "Enable"

**Security Rules (for development):**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Step 10: Update Android Configuration

**Update `android/app/build.gradle.kts`:**

The FlutterFire CLI should have already added the necessary configuration, but verify:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Add this line
}
```

**Update `android/build.gradle.kts`:**

Add Google services classpath:

```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

### Step 11: Initialize Firebase in Your App

The FlutterFire CLI created `lib/firebase_options.dart`. Now update your `main.dart`:

**Update `lib/main.dart`:**
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
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set preferred orientations
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

### Step 12: Test Firebase Connection

Run your app:

```bash
flutter run
```

**Check for Firebase initialization in logs:**
```
[VERBOSE-2:FlutterMain.java(xxx)] Initializing Firebase
```

If no errors, Firebase is successfully integrated! 🎉

## 📝 Summary of Commands

Here's the complete sequence:

```bash
# 1. Install Firebase CLI
npm install -g firebase-tools

# 2. Login to Firebase
firebase login

# 3. Install FlutterFire CLI
dart pub global activate flutterfire_cli

# 4. Navigate to project
cd C:\Users\navig\StudioProjects\bean_model

# 5. Configure FlutterFire
flutterfire configure

# 6. Add Firebase packages
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add cloud_firestore

# 7. Get dependencies
flutter pub get

# 8. Run the app
flutter run
```

## 🔧 Troubleshooting

### Issue: `flutterfire` command not found

**Solution:**
Add Dart pub cache to PATH:

**Windows:**
```powershell
$env:Path += ";$env:USERPROFILE\AppData\Local\Pub\Cache\bin"
```

**Or add permanently:**
1. Search "Environment Variables" in Windows
2. Edit "Path" variable
3. Add: `C:\Users\YourUsername\AppData\Local\Pub\Cache\bin`

### Issue: Firebase initialization fails

**Solution:**
1. Check `firebase_options.dart` exists
2. Verify `google-services.json` in `android/app/`
3. Clean and rebuild:
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Build fails with Google Services error

**Solution:**
Ensure `android/build.gradle.kts` has:
```kotlin
classpath("com.google.gms:google-services:4.4.0")
```

And `android/app/build.gradle.kts` has:
```kotlin
id("com.google.gms.google-services")
```

## 📱 Next Steps

After Firebase is set up, you can:

1. **Update AuthService** to use Firebase Auth
2. **Store user data** in Firestore
3. **Save scan history** to cloud
4. **Enable real-time sync**
5. **Add cloud storage** for images

## 🎯 Quick Verification Checklist

- [ ] Firebase CLI installed (`firebase --version`)
- [ ] Logged into Firebase (`firebase login`)
- [ ] FlutterFire CLI installed (`flutterfire --version`)
- [ ] Firebase project created
- [ ] FlutterFire configured (`flutterfire configure`)
- [ ] Firebase packages added to pubspec.yaml
- [ ] `firebase_options.dart` exists
- [ ] `main.dart` updated with Firebase initialization
- [ ] App runs without Firebase errors
- [ ] Authentication enabled in Firebase Console
- [ ] Firestore enabled in Firebase Console

## 🔥 Firebase Console URLs

- **Main Console**: https://console.firebase.google.com/
- **Your Project**: https://console.firebase.google.com/project/bean-crop-doctor
- **Authentication**: https://console.firebase.google.com/project/bean-crop-doctor/authentication
- **Firestore**: https://console.firebase.google.com/project/bean-crop-doctor/firestore

## 📚 Additional Resources

- **Firebase Docs**: https://firebase.google.com/docs
- **FlutterFire Docs**: https://firebase.flutter.dev/
- **Firebase CLI Docs**: https://firebase.google.com/docs/cli

---

**You're now ready to use Firebase in your Bean Crop Doctor app!** 🚀🔥
