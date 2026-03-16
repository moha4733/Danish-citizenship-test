import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String _isSubscribedKey = 'is_subscribed';
  static const String _subscriptionExpiryKey = 'subscription_expiry';
  static const String _darkModeKey = 'dark_mode';
  static const String _bestScoreKey = 'best_score';
  static const String _testHistoryKey = 'test_history';

  static Future<void> saveTestResult(int score, int total) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_testHistoryKey) ?? [];
    
    final result = {
      'score': score,
      'total': total,
      'date': DateTime.now().toIso8601String(),
    };
    
    history.add(jsonEncode(result));
    await prefs.setStringList(_testHistoryKey, history);
    
    // Also update best score
    final currentBest = prefs.getInt(_bestScoreKey) ?? 0;
    if (score > currentBest) {
      await prefs.setInt(_bestScoreKey, score);
    }
  }

  static Future<List<Map<String, dynamic>>> getTestHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_testHistoryKey) ?? [];
    
    return history.map((e) => jsonDecode(e) as Map<String, dynamic>).toList().reversed.toList();
  }

  static Future<void> setHasSeenOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, value);
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  static Future<void> setSubscriptionStatus(bool isSubscribed, DateTime? expiryDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isSubscribedKey, isSubscribed);
    if (expiryDate != null) {
      await prefs.setString(_subscriptionExpiryKey, expiryDate.toIso8601String());
    }
  }

  static Future<bool> isSubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    final isSubscribed = prefs.getBool(_isSubscribedKey) ?? false;
    
    if (!isSubscribed) return false;
    
    final expiryString = prefs.getString(_subscriptionExpiryKey);
    if (expiryString == null) return false;
    
    final expiryDate = DateTime.parse(expiryString);
    return DateTime.now().isBefore(expiryDate);
  }

  static Future<void> setDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode);
  }

  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  static Future<void> setBestScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentBest = prefs.getInt(_bestScoreKey) ?? 0;
    if (score > currentBest) {
      await prefs.setInt(_bestScoreKey, score);
    }
  }

  static Future<int> getBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bestScoreKey) ?? 0;
  }
}
