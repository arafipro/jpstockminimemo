import "package:jpstockminimemo/constants/imports.dart";

class OnboardingService {
  static const String _onboardingCompletedKey = "onboarding_completed";

  /// オンボーディングが完了しているかチェック
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getBool(_onboardingCompletedKey) ?? false;
    return result;
  }

  /// オンボーディング完了フラグを設定
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  /// オンボーディング完了フラグをリセット（デバッグ用）
  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, false);
  }

  /// 現在のオンボーディング状態を取得（デバッグ用）
  static Future<bool> getOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }
}
