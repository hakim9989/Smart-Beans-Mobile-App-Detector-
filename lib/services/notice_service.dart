import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notice.dart';

/// Service for managing admin notices using Firebase Realtime Database (FREE tier)
class NoticeService {
  static const String _lastSeenKey = 'last_seen_notice';
  final DatabaseReference _noticesRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://bean-model-default-rtdb.firebaseio.com',
  ).ref('notices');
  
  // Admin email (only the developer)
  static const List<String> adminEmails = [
    'admin@codedtechs.com', // Developer admin account
  ];

  /// Check if user is admin
  static bool isAdmin(String? email) {
    if (email == null) return false;
    return adminEmails.contains(email.toLowerCase());
  }

  /// Get all notices from Firebase
  Future<List<Notice>> getNotices() async {
    try {
      print('📥 Fetching notices from Firebase...');
      final snapshot = await _noticesRef
          .orderByChild('timestamp')
          .limitToLast(50)
          .get();
      
      print('📥 Snapshot exists: ${snapshot.exists}');
      
      if (!snapshot.exists) {
        print('📥 No notices found in database');
        return [];
      }
      
      final noticesMap = snapshot.value as Map<dynamic, dynamic>;
      print('📥 Found ${noticesMap.length} notices in database');
      
      final notices = noticesMap.entries
          .map((entry) {
            final data = Map<String, dynamic>.from(entry.value as Map);
            data['id'] = entry.key;
            return Notice.fromJson(data);
          })
          .where((notice) => notice.isActive)
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      print('📥 Returning ${notices.length} active notices');
      return notices;
    } catch (e) {
      print('❌ Error getting notices: $e');
      return [];
    }
  }

  /// Get latest active notice
  Future<Notice?> getLatestNotice() async {
    print('📥 Getting latest notice...');
    final notices = await getNotices();
    final latest = notices.isEmpty ? null : notices.first;
    print('📥 Latest notice: ${latest?.title ?? "None"}');
    return latest;
  }

  /// Listen to notices in real-time
  Stream<List<Notice>> watchNotices() {
    return _noticesRef
        .orderByChild('timestamp')
        .limitToLast(50)
        .onValue
        .map((event) {
      if (!event.snapshot.exists) return <Notice>[];
      
      final noticesMap = event.snapshot.value as Map<dynamic, dynamic>;
      final notices = noticesMap.entries
          .map((entry) {
            final data = Map<String, dynamic>.from(entry.value as Map);
            data['id'] = entry.key;
            return Notice.fromJson(data);
          })
          .where((notice) => notice.isActive)
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      return notices;
    });
  }

  /// Post a new notice (admin only) - syncs to all devices
  Future<bool> postNotice({
    required String title,
    required String message,
    required String adminName,
  }) async {
    try {
      final newNoticeRef = _noticesRef.push();
      
      final notice = Notice(
        id: newNoticeRef.key!,
        title: title,
        message: message,
        timestamp: DateTime.now(),
        adminName: adminName,
        isActive: true,
      );
      
      // Add timeout to prevent infinite loading
      await newNoticeRef.set(notice.toJson()).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out. Check your internet connection.');
        },
      );
      
      print('Notice posted successfully: ${notice.id}');
      return true;
    } catch (e) {
      print('Error posting notice: $e');
      return false;
    }
  }

  /// Check if user has seen the latest notice
  Future<bool> hasSeenLatestNotice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSeenId = prefs.getString(_lastSeenKey);
      final latestNotice = await getLatestNotice();
      
      if (latestNotice == null) return true;
      return lastSeenId == latestNotice.id;
    } catch (e) {
      return true;
    }
  }

  /// Mark latest notice as seen
  Future<void> markNoticeSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final latestNotice = await getLatestNotice();
      
      if (latestNotice != null) {
        await prefs.setString(_lastSeenKey, latestNotice.id);
      }
    } catch (e) {
      print('Error marking notice as seen: $e');
    }
  }

  /// Delete a notice (admin only)
  Future<bool> deleteNotice(String noticeId) async {
    try {
      await _noticesRef.child(noticeId).remove();
      return true;
    } catch (e) {
      print('Error deleting notice: $e');
      return false;
    }
  }
}
