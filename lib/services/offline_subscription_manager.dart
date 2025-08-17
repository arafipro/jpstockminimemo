import "package:jpstockminimemo/constants/imports.dart";

/// オフライン時のサブスクリプション状態管理サービス
/// Phase 1: 最小限の機能（ローカル保存・取得）
/// タスク1.4.2: ローカルストレージでの状態保存
class OfflineSubscriptionManager {
  static final OfflineSubscriptionManager _instance =
      OfflineSubscriptionManager._internal();
  factory OfflineSubscriptionManager() => _instance;
  OfflineSubscriptionManager._internal();

  // ローカルストレージのキー定義
  static const String _subscriptionStatusKey = "offline_subscription_status";
  static const String _subscriptionStatusBackupKey =
      "offline_subscription_status_backup";
  static const String _lastSyncTimestampKey = "last_sync_timestamp";
  static const String _isOnlineKey = "is_online_status";
  static const String _dataVersionKey = "data_version";
  static const String _lastSaveAttemptKey = "last_save_attempt";

  // データバージョン（将来的な互換性のため）
  static const int _currentDataVersion = 1;

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

      // 初期化時にデータバージョンを設定
      await _ensureDataVersion();

      debugPrint("OfflineSubscriptionManager initialized successfully");
    } catch (e) {
      debugPrint("Failed to initialize OfflineSubscriptionManager: $e");
      _isInitialized = false;
    }
  }

  /// データバージョンの確認と設定
  Future<void> _ensureDataVersion() async {
    if (_prefs == null) return;

    final currentVersion = _prefs!.getInt(_dataVersionKey);
    if (currentVersion == null || currentVersion != _currentDataVersion) {
      await _prefs!.setInt(_dataVersionKey, _currentDataVersion);
      debugPrint("Data version updated to $_currentDataVersion");
    }
  }

  /// サブスクリプション状態をローカルに保存
  /// タスク1.4.2の主要機能：ローカルストレージでの状態保存
  Future<bool> saveSubscriptionStatus(SubscriptionStatus status) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      if (_prefs == null) {
        debugPrint("SharedPreferences is not initialized");
        return false;
      }

      // 保存前のデータ整合性チェック
      if (!_validateSubscriptionStatus(status)) {
        debugPrint("Invalid subscription status data");
        return false;
      }

      // 現在のデータをバックアップとして保存
      await _createBackup();

      // SubscriptionStatusをJSONに変換して保存
      final statusJson = status.toJson();
      final statusJsonString = jsonEncode(statusJson);

      // メインデータの保存
      final success =
          await _prefs!.setString(_subscriptionStatusKey, statusJsonString);

      if (success) {
        // 保存成功時にタイムスタンプと保存試行時刻を更新
        final now = DateTime.now();
        await _prefs!.setInt(_lastSyncTimestampKey, now.millisecondsSinceEpoch);
        await _prefs!.setInt(_lastSaveAttemptKey, now.millisecondsSinceEpoch);

        debugPrint(
            "Subscription status saved successfully: ${status.statusType}");
        debugPrint("Saved data: $statusJsonString");
      }

      return success;
    } catch (e) {
      debugPrint("Failed to save subscription status: $e");

      // エラー時はバックアップから復元を試行
      await _restoreFromBackup();
      return false;
    }
  }

  /// サブスクリプション状態の整合性チェック
  bool _validateSubscriptionStatus(SubscriptionStatus status) {
    try {
      // 必須フィールドのチェック
      if (status.statusType == null) {
        debugPrint("Status type is null");
        return false;
      }

      // 日付の整合性チェック
      if (status.startDate != null && status.endDate != null) {
        if (status.startDate!.isAfter(status.endDate!)) {
          debugPrint("Start date is after end date");
          return false;
        }
      }

      if (status.trialEndDate != null) {
        if (status.trialEndDate!.isBefore(DateTime.now())) {
          debugPrint("Trial end date is in the past");
          // 警告のみで、保存は許可
        }
      }

      return true;
    } catch (e) {
      debugPrint("Error validating subscription status: $e");
      return false;
    }
  }

  /// バックアップの作成
  Future<void> _createBackup() async {
    if (_prefs == null) return;

    try {
      final currentData = _prefs!.getString(_subscriptionStatusKey);
      if (currentData != null) {
        await _prefs!.setString(_subscriptionStatusBackupKey, currentData);
        debugPrint("Backup created successfully");
      }
    } catch (e) {
      debugPrint("Failed to create backup: $e");
    }
  }

  /// バックアップからの復元
  Future<void> _restoreFromBackup() async {
    if (_prefs == null) return;

    try {
      final backupData = _prefs!.getString(_subscriptionStatusBackupKey);
      if (backupData != null) {
        await _prefs!.setString(_subscriptionStatusKey, backupData);
        debugPrint("Data restored from backup");
      }
    } catch (e) {
      debugPrint("Failed to restore from backup: $e");
    }
  }

  /// ローカルからサブスクリプション状態を取得
  /// タスク1.4.2の主要機能：ローカルストレージからの状態取得
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

      // JSONデータの整合性チェック
      if (!_validateJsonData(statusJsonString)) {
        debugPrint("Invalid JSON data found, attempting backup restore");
        await _restoreFromBackup();

        // バックアップから再取得
        final backupJsonString = _prefs!.getString(_subscriptionStatusKey);
        if (backupJsonString == null) {
          return null;
        }

        if (!_validateJsonData(backupJsonString)) {
          debugPrint("Backup data is also invalid");
          return null;
        }

        final statusJson = jsonDecode(backupJsonString) as Map<String, dynamic>;
        final status = SubscriptionStatus.fromJson(statusJson);

        debugPrint(
            "Retrieved offline subscription status from backup: ${status.statusType}");
        return status;
      }

      final statusJson = jsonDecode(statusJsonString) as Map<String, dynamic>;
      final status = SubscriptionStatus.fromJson(statusJson);

      debugPrint("Retrieved offline subscription status: ${status.statusType}");
      return status;
    } catch (e) {
      debugPrint("Failed to get offline subscription status: $e");

      // エラー時はバックアップから復元を試行
      try {
        await _restoreFromBackup();
        return await getOfflineSubscriptionStatus();
      } catch (restoreError) {
        debugPrint("Failed to restore from backup: $restoreError");
        return null;
      }
    }
  }

  /// JSONデータの整合性チェック
  bool _validateJsonData(String jsonString) {
    try {
      final jsonData = jsonDecode(jsonString);
      if (jsonData is! Map<String, dynamic>) {
        debugPrint("JSON data is not a map");
        return false;
      }

      // 必須フィールドの存在チェック
      if (!jsonData.containsKey("statusType")) {
        debugPrint("JSON data missing statusType");
        return false;
      }

      // statusTypeの値チェック
      final statusTypeIndex = jsonData["statusType"] as int?;
      if (statusTypeIndex == null ||
          statusTypeIndex < 0 ||
          statusTypeIndex >= StatusType.values.length) {
        debugPrint("Invalid statusType index: $statusTypeIndex");
        return false;
      }

      return true;
    } catch (e) {
      debugPrint("Error validating JSON data: $e");
      return false;
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

  /// 強制的にオフライン状態にする（テスト用）
  Future<bool> forceOffline() async {
    try {
      if (_prefs != null) {
        await _prefs!.setBool(_isOnlineKey, false);
        debugPrint("Forced offline mode enabled");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Failed to force offline mode: $e");
      return false;
    }
  }

  /// 強制的にオンライン状態にする（テスト用）
  Future<bool> forceOnline() async {
    try {
      if (_prefs != null) {
        await _prefs!.setBool(_isOnlineKey, true);
        debugPrint("Forced online mode enabled");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Failed to force online mode: $e");
      return false;
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

  /// 最後の保存試行時刻を取得
  DateTime? getLastSaveAttempt() {
    if (_prefs == null) return null;

    final timestamp = _prefs!.getInt(_lastSaveAttemptKey);
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
      await _prefs!.remove(_subscriptionStatusBackupKey);
      await _prefs!.remove(_lastSyncTimestampKey);
      await _prefs!.remove(_lastSaveAttemptKey);
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

  /// バックアップデータが存在するかどうか
  Future<bool> hasBackupData() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_prefs == null) return false;

    return _prefs!.containsKey(_subscriptionStatusBackupKey);
  }

  /// データの整合性をチェック
  Future<bool> validateStoredData() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_prefs == null) return false;

    try {
      final statusJsonString = _prefs!.getString(_subscriptionStatusKey);
      if (statusJsonString == null) return true; // データがない場合は正常

      return _validateJsonData(statusJsonString);
    } catch (e) {
      debugPrint("Error validating stored data: $e");
      return false;
    }
  }

  /// デバッグ情報を取得
  Map<String, dynamic> getDebugInfo() {
    if (_prefs == null) {
      return {"error": "SharedPreferences not initialized"};
    }

    return {
      "isInitialized": _isInitialized,
      "hasSavedData": _prefs!.containsKey(_subscriptionStatusKey),
      "hasBackupData": _prefs!.containsKey(_subscriptionStatusBackupKey),
      "dataVersion": _prefs!.getInt(_dataVersionKey),
      "lastSyncTimestamp": getLastSyncTimestamp()?.toIso8601String(),
      "lastSaveAttempt": getLastSaveAttempt()?.toIso8601String(),
      "isOnline": _prefs!.getBool(_isOnlineKey),
      "dataIntegrity": _validateStoredDataSync(),
    };
  }

  /// データの整合性を同期的にチェック（デバッグ用）
  bool _validateStoredDataSync() {
    if (_prefs == null) return false;

    try {
      final statusJsonString = _prefs!.getString(_subscriptionStatusKey);
      if (statusJsonString == null) return true; // データがない場合は正常

      return _validateJsonData(statusJsonString);
    } catch (e) {
      debugPrint("Error validating stored data: $e");
      return false;
    }
  }

  /// ストレージの使用状況を取得
  Map<String, dynamic> getStorageInfo() {
    if (_prefs == null) {
      return {"error": "SharedPreferences not initialized"};
    }

    final keys = _prefs!.getKeys();
    final storageData = <String, dynamic>{};

    for (final key in keys) {
      if (key.startsWith("offline_") ||
          key.startsWith("last_") ||
          key.startsWith("is_") ||
          key.startsWith("data_")) {
        final value = _prefs!.get(key);
        if (value is String) {
          storageData[key] = "${value.length} characters";
        } else {
          storageData[key] = value.toString();
        }
      }
    }

    return storageData;
  }
}
