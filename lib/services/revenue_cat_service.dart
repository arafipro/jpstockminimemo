import "package:jpstockminimemo/constants/imports.dart";

/// RevenueCat サービスクラス
/// Phase 1: 最小限の機能（初期化と状態取得）
class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  bool _isInitialized = false;
  CustomerInfo? _customerInfo;

  // 状態管理用のプロパティ
  StreamController<SubscriptionStatus>? _statusController;
  SubscriptionStatus _currentStatus = SubscriptionStatus.none();
  bool _hasError = false;
  String? _errorMessage;

  /// RevenueCat の初期化
  /// Phase 1: 基本機能のみ
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      // 初期状態を設定（初期化中でも表示できるように）
      _currentStatus = _getMockSubscriptionStatus();

      // 環境変数から API キーを取得
      final apiKey = _getApiKey();

      if (apiKey == null) {
        _setError("RevenueCat API key not found");
        // エラー時でも初期状態は設定済み
        _isInitialized = true;
        return;
      }

      // RevenueCat の設定
      final configuration = PurchasesConfiguration(apiKey);

      // RevenueCat の初期化
      await Purchases.configure(configuration);

      _isInitialized = true;
      _clearError();

      // 初期化後にカスタマー情報を取得
      await _fetchCustomerInfo();

      // 初期化時に現在の状態を取得して設定
      await _initializeStatus();
    } catch (e) {
      _isInitialized = true; // エラー時でも初期化完了として扱う
      _setError("Failed to initialize RevenueCat: $e");
    }
  }

  /// プラットフォームに応じた API キーを取得
  String? _getApiKey() {
    if (Platform.isAndroid) {
      return dotenv.env["REVENUECAT_ANDROID_API_KEY"];
    } else if (Platform.isIOS) {
      return dotenv.env["REVENUECAT_IOS_API_KEY"];
    }
    return null;
  }

  /// カスタマー情報を取得
  Future<void> _fetchCustomerInfo() async {
    try {
      _customerInfo = await Purchases.getCustomerInfo();
    } catch (e) {
      _setError("Failed to fetch customer info: $e");
    }
  }

  /// 初期化時に現在の状態を取得して設定
  Future<void> _initializeStatus() async {
    final status = await getSubscriptionStatus();
    _updateStatus(status);

    // ストリームコントローラーが存在する場合は初期状態を送信
    if (_statusController != null) {
      _statusController!.add(status);
    }
  }

  /// 状態を更新して通知
  void _updateStatus(SubscriptionStatus newStatus) {
    if (_currentStatus != newStatus) {
      _currentStatus = newStatus;
      _statusController?.add(newStatus);
    }
  }

  /// エラー状態を設定
  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
  }

  /// エラー状態をクリア
  void _clearError() {
    _hasError = false;
    _errorMessage = null;
  }

  /// CustomerInfo から詳細な SubscriptionStatus を作成
  SubscriptionStatus _createSubscriptionStatusFromCustomerInfo(
      CustomerInfo customerInfo) {
    final entitlements = customerInfo.entitlements.active;

    if (entitlements.isEmpty) {
      return SubscriptionStatus.none();
    }

    final premiumEntitlement = entitlements["premium"];
    if (premiumEntitlement == null) {
      return SubscriptionStatus.none();
    }

    final platform = Platform.isAndroid ? "android" : "ios";
    final subscriptionId = premiumEntitlement.productIdentifier;

    // 日付の変換ヘルパー関数
    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        debugPrint("Error parsing date: $dateString");
        return null;
      }
    }

    // トライアル期間の確認
    if (premiumEntitlement.periodType == PeriodType.trial) {
      final trialEndDate = parseDate(premiumEntitlement.expirationDate);
      if (trialEndDate != null) {
        return SubscriptionStatus.trial(
          trialEndDate: trialEndDate,
          subscriptionId: subscriptionId,
          platform: platform,
        );
      }
      return SubscriptionStatus.none();
    }

    // アクティブなサブスクリプション
    if (premiumEntitlement.isActive) {
      final startDate = parseDate(premiumEntitlement.latestPurchaseDate);
      final endDate = parseDate(premiumEntitlement.expirationDate);
      if (startDate != null && endDate != null) {
        return SubscriptionStatus.active(
          startDate: startDate,
          endDate: endDate,
          subscriptionId: subscriptionId,
          platform: platform,
        );
      }
      return SubscriptionStatus.none();
    }

    // 期限切れ
    final startDate = parseDate(premiumEntitlement.latestPurchaseDate);
    final endDate = parseDate(premiumEntitlement.expirationDate);
    if (startDate != null && endDate != null) {
      return SubscriptionStatus.expired(
        startDate: startDate,
        endDate: endDate,
        subscriptionId: subscriptionId,
        platform: platform,
      );
    }
    return SubscriptionStatus.none();
  }

  /// サブスクリプション状態を取得
  /// Phase 1: 基本機能のみ
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    // 初期化前でもモックデータを返す
    if (!_isInitialized) {
      return _getMockSubscriptionStatus();
    }

    try {
      // 最新のカスタマー情報を取得
      await _fetchCustomerInfo();

      if (_customerInfo == null) {
        // テスト用: モックデータを返す（開発中のみ）
        if (kDebugMode) {
          return _getMockSubscriptionStatus();
        }
        return SubscriptionStatus.none();
      }

      // CustomerInfo から詳細な SubscriptionStatus を作成
      final status = _createSubscriptionStatusFromCustomerInfo(_customerInfo!);
      return status;
    } catch (e) {
      _setError("Failed to get subscription status: $e");

      // テスト用: エラー時もモックデータを返す（開発中のみ）
      if (kDebugMode) {
        return _getMockSubscriptionStatus();
      }
      return SubscriptionStatus.none();
    }
  }

  /// テスト用のモックサブスクリプション状態を取得
  /// 開発中のみ使用し、本番環境では使用しない
  SubscriptionStatus _getMockSubscriptionStatus() {
    // ===== タスク1.3.4 動作確認用 =====
    // 以下の値を順番に変更して各状態をテストしてください：
    // StatusType.none      -> 未購入状態（オレンジバー + アップグレードボタン）
    // StatusType.trial     -> トライアル中（青バー + 残り日数表示）
    // StatusType.active    -> プレミアム会員（緑バー + チェックマーク）
    // StatusType.expired   -> 期限切れ（赤バー + 更新ボタン）
    const testStatus = StatusType.none; // 現在のテスト状態

    switch (testStatus) {
      case StatusType.none:
        return SubscriptionStatus.none();
      case StatusType.trial:
        return SubscriptionStatus.trial(
          trialEndDate: DateTime.now().add(const Duration(days: 5)),
          subscriptionId: "test_trial",
          platform: Platform.isAndroid ? "android" : "ios",
        );
      case StatusType.active:
        return SubscriptionStatus.active(
          startDate: DateTime.now().subtract(const Duration(days: 10)),
          endDate: DateTime.now().add(const Duration(days: 20)),
          subscriptionId: "test_active",
          platform: Platform.isAndroid ? "android" : "ios",
        );
      case StatusType.expired:
        return SubscriptionStatus.expired(
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now().subtract(const Duration(days: 5)),
          subscriptionId: "test_expired",
          platform: Platform.isAndroid ? "android" : "ios",
        );
    }
  }

  /// 状態変更のストリームを取得
  Stream<SubscriptionStatus> get statusStream {
    _statusController ??= StreamController<SubscriptionStatus>.broadcast();

    // 毎回最新のモックデータを取得して送信
    final currentMockStatus = _getMockSubscriptionStatus();
    _statusController!.add(currentMockStatus);

    return _statusController!.stream;
  }

  /// 現在の状態を取得
  SubscriptionStatus get currentStatus => _currentStatus;

  /// 初期化状態を確認
  bool get isInitialized => _isInitialized;

  /// カスタマー情報を取得（デバッグ用）
  CustomerInfo? get customerInfo => _customerInfo;

  /// エラー状態を確認
  bool get hasError => _hasError;

  /// エラーメッセージを取得
  String? get errorMessage => _errorMessage;

  /// サービスの破棄時にストリームを閉じる
  void dispose() {
    _statusController?.close();
    _statusController = null;
  }
}
