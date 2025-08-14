import "package:jpstockminimemo/constants/imports.dart";

/// RevenueCat サービスクラス
/// Phase 1: 最小限の機能（初期化と状態取得）
class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  bool _isInitialized = false;
  CustomerInfo? _customerInfo;

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
        return;
      }

      // RevenueCat の設定
      final configuration = PurchasesConfiguration(apiKey);

      // RevenueCat の初期化
      await Purchases.configure(configuration);

      _isInitialized = true;
      debugPrint("RevenueCat initialized successfully");

      // 初期化後にカスタマー情報を取得
      await _fetchCustomerInfo();
    } catch (e) {
      debugPrint("Error initializing RevenueCat: $e");
      _isInitialized = false;
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
    }
  }

  /// サブスクリプション状態を取得
  /// Phase 1: 基本機能のみ
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    if (!_isInitialized) {
      debugPrint("RevenueCat not initialized");
      return SubscriptionStatus.none;
    }

    try {
      // 最新のカスタマー情報を取得
      await _fetchCustomerInfo();

      if (_customerInfo == null) {
        return SubscriptionStatus.none;
      }

      // アクティブなエンタイトルメントを確認
      final entitlements = _customerInfo!.entitlements.active;

      if (entitlements.isEmpty) {
        return SubscriptionStatus.none;
      }

      // プレミアムエンタイトルメントを確認
      final premiumEntitlement = entitlements["premium"];
      if (premiumEntitlement == null) {
        return SubscriptionStatus.none;
      }

      // トライアル期間の確認
      if (premiumEntitlement.periodType == PeriodType.trial) {
        return SubscriptionStatus.trial;
      }

      // アクティブなサブスクリプション
      if (premiumEntitlement.isActive) {
        return SubscriptionStatus.active;
      }

      return SubscriptionStatus.expired;
    } catch (e) {
      debugPrint("Error getting subscription status: $e");
      return SubscriptionStatus.none;
    }
  }

  /// 初期化状態を確認
  bool get isInitialized => _isInitialized;

  /// カスタマー情報を取得（デバッグ用）
  CustomerInfo? get customerInfo => _customerInfo;
}

/// サブスクリプション状態の列挙型
/// Phase 1: 基本モデル
enum SubscriptionStatus {
  none, // 未購入
  trial, // 無料トライアル中
  active, // アクティブ
  expired // 期限切れ
}

/// サブスクリプション状態の拡張メソッド
extension SubscriptionStatusExtension on SubscriptionStatus {
  /// 状態の日本語表示名を取得
  String get displayName {
    switch (this) {
      case SubscriptionStatus.none:
        return "未購入";
      case SubscriptionStatus.trial:
        return "トライアル中";
      case SubscriptionStatus.active:
        return "アクティブ";
      case SubscriptionStatus.expired:
        return "期限切れ";
    }
  }

  /// プレミアム機能が利用可能かどうか
  bool get isPremium {
    return this == SubscriptionStatus.trial ||
        this == SubscriptionStatus.active;
  }
}
