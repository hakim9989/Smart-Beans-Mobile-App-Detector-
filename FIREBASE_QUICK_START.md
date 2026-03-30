# 🔥 Firebase Setup - Quick Start

## Copy & Paste These Commands

Open your terminal (PowerShell) and run these commands **in order**:

### 1. Install Firebase CLI
```bash
npm install -g firebase-tools
```

### 2. Login to Firebase
```bash
firebase login
```
*(Browser will open - sign in with Google)*

### 3. Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 4. Add Dart to PATH (if flutterfire not found)
```powershell
$env:Path += ";$env:USERPROFILE\AppData\Local\Pub\Cache\bin"
```

### 5. Go to Your Project
```bash
cd C:\Users\navig\StudioProjects\bean_model
```

### 6. Configure Firebase
```bash
flutterfire configure
```
**When prompted:**
- Create new project or select existing
- Project name: `bean-crop-doctor`
- Select platforms: `android` (spacebar to select, Enter to confirm)

### 7. Add Firebase Packages
```bash
flutter pub add firebase_core firebase_auth cloud_firestore
```

### 8. Get Dependencies
```bash
flutter pub get
```

### 9. Run Your App
```bash
flutter run
```

---

## 🌐 Firebase Console Setup

After running commands above:

1. Go to: https://console.firebase.google.com/
2. Select project: `bean-crop-doctor`

### Enable Authentication:
- Click "Authentication" → "Get started"
- Click "Sign-in method" tab
- Enable "Email/Password" → Save

### Enable Firestore:
- Click "Firestore Database" → "Create database"
- Select "Start in test mode"
- Choose location → "Enable"

---

## ✅ Verification

Your app should now:
- ✅ Run without errors
- ✅ Show Firebase initialization in logs
- ✅ Have `firebase_options.dart` file
- ✅ Have `google-services.json` in android/app/

---

## 📝 What's Next?

See `AFTER_FIREBASE_SETUP.md` for:
- Updating main.dart
- Switching to Firebase Auth (optional)
- Storing data in Firestore
- Security rules
- Testing

---

**That's it! Firebase is now integrated.** 🎉

Your app currently uses local authentication. You can keep it that way or switch to Firebase Auth - both work perfectly!
