# 🔥 Firebase Setup - Quick Command Reference

## Copy and paste these commands in order:

### 1️⃣ Install Firebase CLI
```bash
npm install -g firebase-tools
```

### 2️⃣ Login to Firebase
```bash
firebase login
```

### 3️⃣ Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 4️⃣ Navigate to Your Project
```bash
cd C:\Users\navig\StudioProjects\bean_model
```

### 5️⃣ Configure FlutterFire (IMPORTANT!)
```bash
flutterfire configure
```
**When prompted:**
- Select or create project: `bean-crop-doctor`
- Select platforms: `android` (use spacebar, then Enter)

### 6️⃣ Add Firebase Packages
```bash
flutter pub add firebase_core firebase_auth cloud_firestore
```

### 7️⃣ Get Dependencies
```bash
flutter pub get
```

### 8️⃣ Clean Build (if needed)
```bash
flutter clean
flutter pub get
```

### 9️⃣ Run Your App
```bash
flutter run
```

---

## 🔧 If `flutterfire` command not found:

### Add to PATH (Windows PowerShell):
```powershell
$env:Path += ";$env:USERPROFILE\AppData\Local\Pub\Cache\bin"
```

Then retry step 5.

---

## ✅ Verification Commands

### Check Firebase CLI:
```bash
firebase --version
```

### Check FlutterFire CLI:
```bash
flutterfire --version
```

### List Firebase Projects:
```bash
firebase projects:list
```

### Check Flutter Doctor:
```bash
flutter doctor
```

---

## 🌐 Firebase Console Setup

After running commands, go to:

1. **Firebase Console**: https://console.firebase.google.com/
2. Select your project: `bean-crop-doctor`
3. **Enable Authentication**:
   - Click "Authentication" → "Get started"
   - Click "Sign-in method" tab
   - Enable "Email/Password"
4. **Enable Firestore**:
   - Click "Firestore Database" → "Create database"
   - Select "Start in test mode"
   - Choose location → "Enable"

---

## 📝 That's It!

After these steps, Firebase will be fully integrated into your app! 🎉

**Next**: Update your `AuthService` to use Firebase Authentication instead of local storage.
