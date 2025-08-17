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
      debugPrint("RevenueCat is already initialized");
      return;
    }

    try {
      // 環境変数から API キーを取得
      final apiKey = _getApiKey();

      if (apiKey == null) {
        debugPrint("RevenueCat API key not found in environment variables");
        _setError("RevenueCat API key not found");
        return;
      }

      // RevenueCat の設定
      final configuration = PurchasesConfiguration(apiKey);

      // RevenueCat の初期化
      await Purchases.configure(configuration);

      _isInitialized = true;
      _clearError();
      debugPrint("RevenueCat initialized successfully");

      // 初期化後にカスタマー情報を取得
      await _fetchCustomerInfo();

      // 初期化時に現在の状態を取得して設定
      await _initializeStatus();
    } catch (e) {
      debugPrint("Error initializing RevenueCat: $e");
      _isInitialized = false;
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
      debugPrint("Customer info fetched successfully");
    } catch (e) {
      debugPrint("Error fetching customer info: $e");
      _setError("Failed to fetch customer info: $e");
    }
  }

  /// 初期化時に現在の状態を取得して設定
  Future<void> _initializeStatus() async {
    debugPrint("RevenueCatService: _initializeStatus called");
    final status = await getSubscriptionStatus();
    debugPrint(
        "RevenueCatService: Got subscription status: ${status.statusType}");
    _updateStatus(status);

    // ストリームコントローラーが存在する場合は初期状態を送信
    if (_statusController != null) {
      debugPrint(
          "RevenueCatService: Sending initial status to stream: ${status.statusType}");
      _statusController!.add(status);
    } else {
      debugPrint(
          "RevenueCatService: StreamController is null, cannot send initial status");
    }
  }

  /// 状態を更新して通知
  void _updateStatus(SubscriptionStatus newStatus) {
    debugPrint(
        "RevenueCatService: _updateStatus called with status: ${newStatus.statusType}");
    if (_currentStatus != newStatus) {
      _currentStatus = newStatus;
      debugPrint("RevenueCatService: Status changed, sending to stream");
      _statusController?.add(newStatus);
      debugPrint("Subscription status updated: ${newStatus.statusType}");
    } else {
      debugPrint("RevenueCatService: Status unchanged, not sending to stream");
    }
  }

  /// エラー状態を設定
  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    debugPrint("RevenueCat error: $message");
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
    if (!_isInitialized) {
      debugPrint("RevenueCat not initialized");
      return SubscriptionStatus.none();
    }

    try {
      // 最新のカスタマー情報を取得
      await _fetchCustomerInfo();

      if (_customerInfo == null) {
        // テスト用: モックデータを返す（開発中のみ）
        if (kDebugMode) {
          debugPrint("Using mock data for testing");
          return _getMockSubscriptionStatus();
        }
        return SubscriptionStatus.none();
      }

      // CustomerInfo から詳細な SubscriptionStatus を作成
      final status = _createSubscriptionStatusFromCustomerInfo(_customerInfo!);
      return status;
    } catch (e) {
      debugPrint("Error getting subscription status: $e");
      _setError("Failed to get subscription status: $e");

      // テスト用: エラー時もモックデータを返す（開発中のみ）
      if (kDebugMode) {
        debugPrint("Error occurred, using mock data for testing");
        return _getMockSubscriptionStatus();
      }
      return SubscriptionStatus.none();
    }
  }

  /// テスト用のモックサブスクリプション状態を取得
  /// 開発中のみ使用し、本番環境では使用しない
  SubscriptionStatus _getMockSubscriptionStatus() {
    // テスト用の状態を変更するには、この値を変更してください
    const testStatus = StatusType.none; // none, trial, active, expired

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
    debugPrint("RevenueCatService: statusStream getter called");
    if (_statusController == null) {
      debugPrint("RevenueCatService: Creating new StreamController");
      _statusController = StreamController<SubscriptionStatus>.broadcast();
      // 初期状態を送信
      debugPrint(
          "RevenueCatService: Sending initial status: ${_currentStatus.statusType}");
      _statusController!.add(_currentStatus);
    }
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
