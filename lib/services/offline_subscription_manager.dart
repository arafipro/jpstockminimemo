import "package:jpstockminimemo/constants/imports.dart";

/// オフライン時のサブスクリプション状態管理サービス
/// Phase 1: 最小限の機能（ローカル保存・取得）
class OfflineSubscriptionManager {
  static final OfflineSubscriptionManager _instance =
      OfflineSubscriptionManager._internal();
  factory OfflineSubscriptionManager() => _instance;
  OfflineSubscriptionManager._internal();

  static const String _subscriptionStatusKey = "offline_subscription_status";
  static const String _lastSyncTimestampKey = "last_sync_timestamp";
  static const String _isOnlineKey = "is_online_status";

  bool _isInitialized = false;
  SharedPreferences? _prefs;

  /// サービスの初期化
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    } catch (e) {
      debugPrint("Failed to initialize OfflineSubscriptionManager: $e");
      _isInitialized = false;
    }
  }

  /// サブスクリプション状態をローカルに保存
  Future<bool> saveSubscriptionStatus(SubscriptionStatus status) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      if (_prefs == null) {
        debugPrint("SharedPreferences is not initialized");
        return false;
      }

      // SubscriptionStatusをJSONに変換して保存
      final statusJson = status.toJson();
      final success = await _prefs!
          .setString(_subscriptionStatusKey, jsonEncode(statusJson));

      if (success) {
        // 保存成功時にタイムスタンプも更新
        await _prefs!.setInt(
            _lastSyncTimestampKey, DateTime.now().millisecondsSinceEpoch);
        debugPrint(
            "Subscription status saved successfully: ${status.statusType}");
      }

      return success;
    } catch (e) {
      debugPrint("Failed to save subscription status: $e");
      return false;
    }
  }

  /// ローカルからサブスクリプション状態を取得
  Future<SubscriptionStatus?> getOfflineSubscriptionStatus() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      if (_prefs == null) {
        debugPrint("SharedPreferences is not initialized");
        return null;
      }

      final statusJsonString = _prefs!.getString(_subscriptionStatusKey);
      if (statusJsonString == null) {
        debugPrint("No saved subscription status found");
        return null;
      }

      final statusJson = jsonDecode(statusJsonString) as Map<String, dynamic>;
      final status = SubscriptionStatus.fromJson(statusJson);

      debugPrint("Retrieved offline subscription status: ${status.statusType}");
      return status;
    } catch (e) {
      debugPrint("Failed to get offline subscription status: $e");
      return null;
    }
  }

  /// ネットワーク接続状態を確認
  Future<bool> isOnline() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final isConnected = connectivityResult != ConnectivityResult.none;

      // ローカルにも保存（オフライン時の参照用）
      if (_prefs != null) {
        await _prefs!.setBool(_isOnlineKey, isConnected);
      }

      return isConnected;
    } catch (e) {
      debugPrint("Failed to check network connectivity: $e");
      // エラー時はローカルに保存された状態を参照
      return _prefs?.getBool(_isOnlineKey) ?? false;
    }
  }

  /// オンライン状態のサブスクリプション状態と同期
  Future<bool> syncStatus(SubscriptionStatus onlineStatus) async {
    try {
      final success = await saveSubscriptionStatus(onlineStatus);
      if (success) {
        debugPrint(
            "Subscription status synced successfully: ${onlineStatus.statusType}");
      }
      return success;
    } catch (e) {
      debugPrint("Failed to sync subscription status: $e");
      return false;
    }
  }

  /// 最後の同期タイムスタンプを取得
  DateTime? getLastSyncTimestamp() {
    if (_prefs == null) return null;

    final timestamp = _prefs!.getInt(_lastSyncTimestampKey);
    if (timestamp == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// 保存されたデータをクリア（デバッグ用）
  Future<bool> clearSavedData() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      if (_prefs == null) return false;

      await _prefs!.remove(_subscriptionStatusKey);
      await _prefs!.remove(_lastSyncTimestampKey);
      await _prefs!.remove(_isOnlineKey);

      debugPrint("Offline subscription data cleared");
      return true;
    } catch (e) {
      debugPrint("Failed to clear saved data: $e");
      return false;
    }
  }

  /// 初期化状態を確認
  bool get isInitialized => _isInitialized;

  /// 保存されたデータが存在するかどうか
  Future<bool> hasSavedData() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_prefs == null) return false;

    return _prefs!.containsKey(_subscriptionStatusKey);
  }

  /// デバッグ情報を取得
  Map<String, dynamic> getDebugInfo() {
    if (_prefs == null) {
      return {"error": "SharedPreferences not initialized"};
    }

    return {
      "isInitialized": _isInitialized,
      "hasSavedData": _prefs!.containsKey(_subscriptionStatusKey),
      "lastSyncTimestamp": getLastSyncTimestamp()?.toIso8601String(),
      "isOnline": _prefs!.getBool(_isOnlineKey),
    };
  }
}
