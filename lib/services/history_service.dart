import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_history.dart';

/// Service for managing scan history
class HistoryService {
  static const String _historyKey = 'scan_history';

  /// Save a new scan to history
  Future<void> saveScan(ScanHistory scan) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    
    history.insert(0, scan); // Add to beginning
    
    // Keep only last 50 scans
    if (history.length > 50) {
      history.removeRange(50, history.length);
    }
    
    final jsonList = history.map((s) => s.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  /// Get all scan history
  Future<List<ScanHistory>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_historyKey);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => ScanHistory.fromJson(json)).toList();
  }

  /// Delete a scan from history
  Future<void> deleteScan(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    
    history.removeWhere((scan) => scan.id == id);
    
    final jsonList = history.map((s) => s.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  /// Clear all history
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
