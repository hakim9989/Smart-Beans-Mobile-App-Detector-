# Build APK Guide 📦

## Quick Commands

### 1. Build Release APK (Recommended)
```bash
flutter build apk --release
```

### 2. Build Split APKs (Smaller file sizes)
```bash
flutter build apk --split-per-abi
```

### 3. Build Debug APK (For testing)
```bash
flutter build apk --debug
```

## Detailed Instructions

### Option 1: Single Universal APK (Works on all devices)

**Command:**
```bash
flutter build apk --release
```

**Output Location:**
```
build/app/outputs/flutter-apk/app-release.apk
```

**File Size:** ~50-60 MB (includes all architectures)

**Use Case:** 
- Easy distribution
- Works on all Android devices
- Good for sharing with team members

---

### Option 2: Split APKs (Recommended for Production)

**Command:**
```bash
flutter build apk --split-per-abi
```

**Output Location:**
```
build/app/outputs/flutter-apk/
├── app-armeabi-v7a-release.apk  (~25 MB) - 32-bit ARM devices
├── app-arm64-v8a-release.apk    (~28 MB) - 64-bit ARM devices (most modern phones)
└── app-x86_64-release.apk       (~30 MB) - x86 devices (emulators, some tablets)
```

**Benefits:**
- Smaller file sizes (users download only what they need)
- Faster installation
- Better for Play Store distribution

**Use Case:**
- Production deployment
- Google Play Store submission
- Optimized distribution

---

### Option 3: Debug APK (For Testing Only)

**Command:**
```bash
flutter build apk --debug
```

**Output Location:**
```
build/app/outputs/flutter-apk/app-debug.apk
```

**Use Case:**
- Quick testing
- Debugging issues
- NOT for distribution (larger size, slower performance)

---

## Step-by-Step Build Process

### Step 1: Clean Previous Builds
```bash
flutter clean
```

### Step 2: Get Dependencies
```bash
flutter pub get
```

### Step 3: Build APK
```bash
flutter build apk --release
```

### Step 4: Locate Your APK
The APK will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Build with Custom Name and Version

### Update Version in pubspec.yaml
```yaml
version: 1.0.0+1
```

Then build:
```bash
flutter build apk --release
```

---

## Build Options Explained

### Release Mode (--release)
- Optimized for performance
- Smaller file size
- No debugging capabilities
- **Use for distribution**

### Debug Mode (--debug)
- Includes debugging symbols
- Larger file size
- Slower performance
- **Use for development only**

### Profile Mode (--profile)
- Performance profiling enabled
- Medium file size
- **Use for performance testing**

---

## Common Build Commands

### 1. Build with Obfuscation (More secure)
```bash
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

### 2. Build with Specific Target
```bash
flutter build apk --release --target=lib/main.dart
```

### 3. Build with Verbose Output
```bash
flutter build apk --release --verbose
```

### 4. Build for Specific Architecture Only
```bash
flutter build apk --release --target-platform android-arm64
```

---

## Recommended Build Command for Your Project

For final year project demonstration:

```bash
flutter build apk --release --split-per-abi
```

This creates optimized APKs for different devices. Share the **arm64-v8a** version (works on most modern phones).

---

## After Building

### 1. Find Your APK
```bash
cd build/app/outputs/flutter-apk
dir
```

### 2. Test on Device
- Copy APK to your phone
- Enable "Install from Unknown Sources" in Settings
- Tap the APK file to install
- Test all features

### 3. Share with Team
- Upload to Google Drive
- Share via WhatsApp/Email
- Use USB transfer
- Use cloud storage

---

## File Sizes (Approximate)

| Build Type | Size | Best For |
|------------|------|----------|
| Universal APK | 50-60 MB | Easy sharing |
| arm64-v8a APK | 25-30 MB | Modern phones |
| armeabi-v7a APK | 23-28 MB | Older phones |
| Debug APK | 70-80 MB | Testing only |

---

## Troubleshooting

### Error: "Gradle build failed"
```bash
cd android
gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --release
```

### Error: "SDK not found"
- Make sure Android SDK is installed
- Set ANDROID_HOME environment variable
- Run `flutter doctor` to check setup

### Error: "Out of memory"
Add to `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m
```

### Error: "License not accepted"
```bash
flutter doctor --android-licenses
```
Accept all licenses.

---

## Build for Google Play Store

### 1. Generate Signing Key
```bash
keytool -genkey -v -keystore ~/bean-model-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias bean-model
```

### 2. Create key.properties
Create `android/key.properties`:
```properties
storePassword=your_password
keyPassword=your_password
keyAlias=bean-model
storeFile=C:/path/to/bean-model-key.jks
```

### 3. Update build.gradle.kts
Already configured in your project!

### 4. Build App Bundle (For Play Store)
```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## Quick Reference

| Command | Output | Use Case |
|---------|--------|----------|
| `flutter build apk --release` | Universal APK | Quick sharing |
| `flutter build apk --split-per-abi` | Split APKs | Production |
| `flutter build apk --debug` | Debug APK | Testing |
| `flutter build appbundle` | AAB file | Play Store |

---

## Your Next Steps

1. **Clean build:**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Build APK:**
   ```bash
   flutter build apk --release
   ```

3. **Find APK:**
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

4. **Install on phone and test!**

---

## Important Notes

✅ Make sure `google-services.json` is in `android/app/`
✅ Make sure `bean_model.tflite` is in `assets/models/`
✅ Make sure `bean_plant.jpg` is in `assets/images/`
✅ Test on real device before sharing
✅ Check all features work (camera, gallery, Firebase)

---

**Ready to build? Run this now:**

```bash
flutter build apk --release
```

Your APK will be ready in ~2-5 minutes! 🚀
