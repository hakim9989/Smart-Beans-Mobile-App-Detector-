# Notice System Behavior 📢

## Current Behavior

### When a Notice Appears:

1. **First Time Only**: Each notice appears only ONCE per user
2. **On Login**: Notice shows when user opens the app (if they haven't seen it)
3. **Timing**: 
   - Banner appears immediately on home screen
   - Popup appears after 500ms (half a second)
4. **Dismissal**: Once user dismisses the popup, they won't see that specific notice again

### How It Works:

```
Admin posts notice → All users see it ONCE → User dismisses → Never shows again
```

### Storage:
- Uses **SharedPreferences** (local device storage)
- Stores the notice ID when dismissed
- Each device tracks independently

## Example Timeline:

**Monday 9:00 AM** - Admin posts "System Maintenance Tonight"
- User A logs in at 9:05 AM → Sees notice → Dismisses
- User B logs in at 10:00 AM → Sees notice → Dismisses
- User A logs in at 11:00 AM → Does NOT see notice (already dismissed)
- User B logs in at 2:00 PM → Does NOT see notice (already dismissed)

**Tuesday 8:00 AM** - Admin posts "New Feature Available"
- User A logs in → Sees NEW notice → Dismisses
- User B logs in → Sees NEW notice → Dismisses

## Current Limitations:

❌ Notice doesn't repeat after X hours/days
❌ No "remind me later" option
❌ Can't force re-show a notice
❌ No expiration date for notices
❌ Clearing app data resets (user will see old notices again)

## What Users See:

### First Time (New Notice):
1. Orange banner at top of home screen
2. Popup appears after 500ms
3. Can tap banner OR wait for popup
4. Dismiss button marks as seen

### After Dismissal:
- Nothing! Notice is gone forever for that user
- Unless they clear app data or reinstall

## If You Want Different Behavior:

### Option 1: Show Notice Every Login
Remove the "seen" check - notice shows every time

### Option 2: Show Notice Every X Hours
Add timestamp check - show if last seen was > X hours ago

### Option 3: Show Notice X Times
Add counter - show up to X times, then stop

### Option 4: Show Until Expiration Date
Add expiry field - show until specific date/time

### Option 5: Priority Notices
Add priority levels - critical notices show multiple times

## Recommended for Your Use Case:

Since this is for a final year project with multiple team members, the current behavior (show once per user) is good because:

✅ Users aren't annoyed by repeated notices
✅ Important info is communicated once
✅ Admin can post new notices anytime
✅ Each new notice is treated separately

## To Test:

1. **See notice again**: Clear app data or reinstall app
2. **Test with multiple users**: Each user sees it independently
3. **Post new notice**: All users see the new one, even if they dismissed the old one

## Current Code Location:

- **Check if seen**: `lib/services/notice_service.dart` → `hasSeenLatestNotice()`
- **Mark as seen**: `lib/services/notice_service.dart` → `markNoticeSeen()`
- **Display logic**: `lib/screens/home_screen.dart` → `_checkForNotices()`
- **Storage key**: `'last_seen_notice'` in SharedPreferences

Would you like me to modify the behavior to show notices multiple times or add any of the options above?
