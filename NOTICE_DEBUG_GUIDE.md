# Notice System Debug Guide 🔍

## Problem
Admin can post notices and see them, but regular users don't see the notices when they log in.

## Debug Steps Added

### 1. Added Console Logging
I've added debug print statements to track the notice flow:

**In `home_screen.dart`:**
- 🔔 Checking for notices...
- 🔔 Has seen latest: true/false
- 🔔 Latest notice: [title or "None"]
- 🔔 Showing notice popup... (if showing)
- 🔔 Not showing popup - [reason]

**In `notice_service.dart`:**
- 📥 Fetching notices from Firebase...
- 📥 Snapshot exists: true/false
- 📥 Found X notices in database
- 📥 Returning X active notices
- 📥 Getting latest notice...
- 📥 Latest notice: [title or "None"]

### 2. How to Debug

#### Step 1: Check Console When Regular User Logs In
Look for these messages in the console:
```
🔔 Checking for notices...
📥 Fetching notices from Firebase...
📥 Snapshot exists: true/false
📥 Found X notices in database
📥 Returning X active notices
📥 Getting latest notice...
📥 Latest notice: [title]
🔔 Has seen latest: false
🔔 Latest notice: [title]
🔔 Showing notice popup...
```

#### Step 2: Common Issues & Solutions

**Issue 1: "Snapshot exists: false"**
- **Problem**: No data in Firebase
- **Solution**: Check Firebase Console → Realtime Database → notices node
- **Verify**: Admin posted notice successfully

**Issue 2: "Found 0 notices" but snapshot exists**
- **Problem**: All notices are inactive
- **Solution**: Check `isActive` field in Firebase (should be `true`)

**Issue 3: "Has seen latest: true" immediately**
- **Problem**: SharedPreferences has old notice ID
- **Solution**: Clear app data or use different device/emulator
- **Command**: `flutter run --clear-cache` or uninstall/reinstall app

**Issue 4: No logs at all**
- **Problem**: `_checkForNotices()` not being called
- **Solution**: Check if `initState()` is running properly

### 3. Firebase Database Structure Check

Your notices should look like this in Firebase:
```json
{
  "notices": {
    "-NxxxxxxxxxxxXXX": {
      "title": "Test Notice",
      "message": "This is a test message",
      "timestamp": 1234567890000,
      "adminName": "Admin",
      "isActive": true
    }
  }
}
```

### 4. Firebase Rules Check

Current rules (from your setup):
```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

This allows everyone to read and write. If notices still don't show, it's not a permissions issue.

### 5. Testing Checklist

- [ ] Admin can post notice (✅ Working)
- [ ] Admin can see notice in dashboard (✅ Working)
- [ ] Check Firebase Console - notice exists in database
- [ ] Check Firebase Console - `isActive` is `true`
- [ ] Regular user logs in - check console logs
- [ ] Regular user sees notice banner on home screen
- [ ] Regular user sees notice popup after 500ms
- [ ] Tapping notice banner shows popup
- [ ] Dismissing popup marks notice as seen
- [ ] Notice doesn't show again after being dismissed

### 6. Quick Test Commands

```bash
# Clear app data and reinstall
flutter clean
flutter pub get
flutter run

# Or just reinstall
flutter run --clear-cache
```

### 7. Manual Test in Firebase Console

1. Go to Firebase Console
2. Navigate to Realtime Database
3. Find the `notices` node
4. Check if your notice exists
5. Verify all fields are present
6. Try manually adding a test notice:
   ```json
   {
     "title": "Manual Test",
     "message": "Testing from console",
     "timestamp": 1708000000000,
     "adminName": "Console",
     "isActive": true
   }
   ```

### 8. Expected Behavior

**For Admin:**
1. Post notice → Success message
2. See notice in admin panel list
3. See notice banner on home screen
4. See notice popup

**For Regular User:**
1. Login → Home screen loads
2. Console shows: "🔔 Checking for notices..."
3. Console shows: "📥 Found X notices"
4. Console shows: "🔔 Latest notice: [title]"
5. If not seen: Banner appears at top
6. After 500ms: Popup appears
7. Tap banner or wait: Popup shows
8. Dismiss: Notice marked as seen

### 9. Next Steps

Run the app with a regular user account and check the console output. Share the logs here and I can help identify the exact issue!

Look for patterns like:
- ❌ "Error getting notices: [error]" - Firebase connection issue
- 📥 "Found 0 notices" - No notices in database
- 🔔 "Has seen latest: true" - Already marked as seen
- 🔔 "Not showing popup" - Logic preventing display
