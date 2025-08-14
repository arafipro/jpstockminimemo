# 🚀 オンボーディングとペイウォール実装ガイド

このドキュメントでは、日本株ひとこと投資メモアプリにオンボーディングとペイウォール機能を実装する方法を説明します。

## 📋 目次

1. [オンボーディング実装](#オンボーディング実装)
2. [ペイウォール実装](#ペイウォール実装)
3. [RevenueCat を使った課金機能](#revenuecatを使った課金機能)
4. [従来の課金実装（in_app_purchase）](#従来の課金実装in_app_purchase)
5. [実装のポイント](#実装のポイント)
6. [設定手順](#設定手順)

---

## 🎯 オンボーディング実装

### 概要

ユーザーが初回起動時にアプリの機能を理解し、使い方を学ぶための画面を実装します。

### 主要コンポーネント

#### 1. オンボーディング画面（OnboardingPage）

- **PageView**: スワイプ可能な複数ページ
- **プログレスインジケーター**: 現在のページ位置を表示
- **魅力的なデザイン**: アイコンとカラーで機能を説明

#### 2. 実装例

```dart
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: '日本株投資を簡単管理',
      description: '証券コードと銘柄名を登録して、投資の理由や戦略をメモできます',
      icon: Icons.trending_up,
      color: Colors.blue,
    ),
    OnboardingItem(
      title: 'オフラインで動作',
      description: 'インターネット接続不要で、いつでもメモの確認・編集が可能です',
      icon: Icons.offline_bolt,
      color: Colors.green,
    ),
    OnboardingItem(
      title: '東証市場再編対応',
      description: 'プライム・スタンダード・グロース市場の新しい証券コード体系に対応',
      icon: Icons.newspaper,
      color: Colors.orange,
    ),
  ];

  // 実装詳細...
}
```

#### 3. 状態管理

- **SharedPreferences**: オンボーディング完了フラグの保存
- **初回起動判定**: アプリ起動時の状態チェック

---

## 💰 ペイウォール実装

### 概要

プレミアム機能の価値を伝え、課金への導線を提供する画面を実装します。

### 主要コンポーネント

#### 1. ペイウォール画面（PaywallPage）

- **機能説明**: プレミアム機能のメリットを具体的に説明
- **価格表示**: 複数の価格プランを表示
- **購入ボタン**: 課金処理への導線
- **復元機能**: 既存購入の復元

#### 2. 実装例

```dart
class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  bool _isLoading = false;

  final List<FeatureItem> _features = [
    FeatureItem(
      title: '無制限のメモ作成',
      description: 'メモの数に制限なし',
      icon: Icons.note_add,
    ),
    FeatureItem(
      title: '広告なし',
      description: '快適な使用体験',
      icon: Icons.block,
    ),
    FeatureItem(
      title: 'データバックアップ',
      description: 'クラウド同期で安全に保存',
      icon: Icons.backup,
    ),
    FeatureItem(
      title: '検索機能',
      description: 'メモを素早く見つける',
      icon: Icons.search,
    ),
  ];

  // 実装詳細...
}
```

#### 3. デザイン要素

- **機能リスト**: プレミアム機能の一覧表示
- **価格プラン**: 月額・年額の選択肢
- **お得感の演出**: 年額プランの割引表示
- **信頼性の表示**: キャンセル可能の明示

---

## 🎯 RevenueCat を使った課金機能

### 概要

RevenueCat は、iOS/Android の課金管理を統一的に扱えるサービスです。

### 利点

- **統一された API**: iOS/Android で同じコードで課金管理
- **自動購入復元**: 購入状態の自動同期
- **リアルタイム分析**: 購入データの詳細分析
- **A/B テスト**: ペイウォールの A/B テスト機能
- **エラーハンドリング**: 包括的なエラー処理
- **サーバーサイド検証**: 自動的な購入検証

### 依存関係

```yaml
dependencies:
  purchases_flutter: ^6.0.0
```

### 実装例

#### 1. RevenueCat サービス

```dart
class RevenueCatService {
  static const String _apiKeyAndroid = 'your_android_api_key';
  static const String _apiKeyIOS = 'your_ios_api_key';

  static const String _premiumMonthly = 'premium_monthly';
  static const String _premiumYearly = 'premium_yearly';

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    PurchasesConfiguration configuration;

    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(_apiKeyAndroid);
    } else {
      configuration = PurchasesConfiguration(_apiKeyIOS);
    }

    await Purchases.configure(configuration);
    _isInitialized = true;

    Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdate);
  }

  // 実装詳細...
}
```

#### 2. 主要メソッド

- `initialize()`: RevenueCat の初期化
- `getOfferings()`: 利用可能なオファリングを取得
- `purchasePackage()`: パッケージの購入
- `restorePurchases()`: 購入の復元
- `isPremium()`: プレミアム状態の確認

#### 3. 購入状態の監視

```dart
void _onCustomerInfoUpdate(CustomerInfo customerInfo) async {
  final isPremium = customerInfo.entitlements.active.containsKey('premium');

  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('is_premium', isPremium);
}
```

---

## 🔧 従来の課金実装（in_app_purchase）

### 概要

Flutter の公式 in_app_purchase パッケージを使った実装方法です。

### 依存関係

```yaml
dependencies:
  in_app_purchase: ^3.1.13
  in_app_purchase_android: ^0.3.7+1
  in_app_purchase_storekit: ^0.3.6+1
```

### 実装例

#### 1. 購入サービス

```dart
class PurchaseService {
  static const String _premiumProductId = 'premium_monthly';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  List<ProductDetails> _products = [];

  Future<void> initialize() async {
    _isAvailable = await _inAppPurchase.isAvailable();

    if (_isAvailable) {
      await _loadProducts();
      _setupPurchaseStream();
    }
  }

  // 実装詳細...
}
```

#### 2. 購入処理

```dart
Future<bool> buyPremium() async {
  if (!_isAvailable || _products.isEmpty) {
    return false;
  }

  final ProductDetails product = _products.first;
  final PurchaseParam purchaseParam = PurchaseParam(
    productDetails: product,
  );

  return await _inAppPurchase.buyNonConsumable(
    purchaseParam: purchaseParam,
  );
}
```

---

## 🎯 実装のポイント

### オンボーディング

#### 1. ユーザー体験の最適化

- **初回起動時のみ表示**: SharedPreferences で完了フラグを管理
- **スワイプ可能なページ**: PageView を使用した直感的な操作
- **プログレスインジケーター**: 現在のページ位置を視覚的に表示
- **魅力的なデザイン**: アイコンとカラーで機能を分かりやすく説明

#### 2. コンテンツ設計

- **機能の価値を明確に**: アプリの主要機能を 3-5 ページで説明
- **視覚的な要素**: アイコン、イラスト、アニメーションを活用
- **簡潔な説明文**: 長すぎない、分かりやすい文章

### ペイウォール

#### 1. コンバージョン最適化

- **機能の価値を明確に**: プレミアム機能のメリットを具体的に説明
- **複数の価格プラン**: 月額・年額など選択肢を提供
- **無料トライアル**: 初月無料などで導入のハードルを下げる
- **購入復元機能**: 既存ユーザーの利便性を確保
- **キャンセル可能**: いつでも解約できることを明示

#### 2. デザイン要素

- **信頼性の表示**: セキュリティ、プライバシーの保証
- **社会的証明**: ユーザー数、評価などの表示
- **緊急性の演出**: 限定オファー、期間限定割引

### 課金システム

#### 1. 技術的考慮事項

- **プラットフォーム対応**: iOS/Android 両方の課金システムに対応
- **購入検証**: サーバーサイドでの検証も検討
- **エラーハンドリング**: ネットワークエラーや課金エラーの適切な処理
- **状態管理**: 購入状態の永続化

#### 2. ユーザー体験

- **シームレスな購入**: 購入フローを簡素化
- **明確な価格表示**: 税込み価格、更新条件を明示
- **購入後の確認**: 購入完了の明確な通知

---

## ⚙️ 設定手順

### RevenueCat 設定

#### 1. プロジェクト作成

1. RevenueCat ダッシュボードで新しいプロジェクトを作成
2. iOS/Android アプリを追加
3. API キーを取得

#### 2. 製品設定

1. App Store Connect/Google Play Console で製品を作成
2. RevenueCat で製品を設定
3. エンティタイメントを作成（例: `premium`）
4. 製品とエンティタイメントを関連付け

#### 3. オファリング設定

1. 月額・年額プランのオファリングを作成
2. 価格設定とプロモーション設定
3. A/B テストの設定（オプション）

### 環境変数設定

```env
# .env
REVENUECAT_ANDROID_API_KEY=your_android_api_key
REVENUECAT_IOS_API_KEY=your_ios_api_key
```

### アプリ統合

#### 1. メインアプリの更新

```dart
class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  bool _isLoading = true;
  bool _onboardingCompleted = false;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  Future<void> _checkAppState() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    final revenueCatService = context.read<RevenueCatService>();
    final isPremium = await revenueCatService.isPremium();

    setState(() {
      _onboardingCompleted = onboardingCompleted;
      _isPremium = isPremium;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: LoadPage());
    }

    if (!_onboardingCompleted) {
      return const OnboardingPage();
    }

    if (!_isPremium) {
      return const PaywallPage();
    }

    return Consumer<SettingsModel>(
      builder: (context, model, child) {
        // メインアプリの表示
        return Scaffold(
          body: model.startEditPage
              ? EditPage(stockmemo: null)
              : const ListPage(),
        );
      },
    );
  }
}
```

#### 2. プロバイダー設定

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider<SettingsModel>(
      create: (_) => SettingsModel()..getAllSettings(),
    ),
    Provider<RevenueCatService>(
      create: (_) => RevenueCatService()..initialize(),
    ),
  ],
  child: MaterialApp(
    // アプリ設定
  ),
)
```

---

## 📊 実装比較

### RevenueCat vs in_app_purchase

| 項目                 | RevenueCat | in_app_purchase |
| -------------------- | ---------- | --------------- |
| 実装の簡素さ         | ⭐⭐⭐⭐⭐ | ⭐⭐⭐          |
| プラットフォーム対応 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐        |
| エラーハンドリング   | ⭐⭐⭐⭐⭐ | ⭐⭐⭐          |
| 分析機能             | ⭐⭐⭐⭐⭐ | ⭐⭐            |
| A/B テスト           | ⭐⭐⭐⭐⭐ | ❌              |
| サーバーサイド検証   | ⭐⭐⭐⭐⭐ | ⭐⭐            |
| 学習コスト           | ⭐⭐⭐⭐   | ⭐⭐⭐⭐⭐      |

### 推奨事項

**RevenueCat を推奨する理由:**

1. **開発効率**: 実装が大幅に簡素化
2. **保守性**: 包括的なエラーハンドリング
3. **分析**: 詳細な購入データ分析
4. **拡張性**: A/B テストや高度な機能

**in_app_purchase を選択する場合:**

1. **コスト**: RevenueCat の月額費用を避けたい
2. **シンプルな要件**: 基本的な課金機能のみ必要
3. **学習目的**: 課金システムの仕組みを理解したい

---

## 🔮 今後の拡張予定

### 機能拡張

- [ ] オンボーディングの A/B テスト
- [ ] ペイウォールの動的コンテンツ
- [ ] 段階的な機能解放
- [ ] リテンション施策の実装

### 分析・最適化

- [ ] コンバージョンレートの測定
- [ ] ユーザー行動分析
- [ ] ペイウォール最適化
- [ ] 価格戦略の検証

---

## 📚 参考資料

### 公式ドキュメント

- [RevenueCat Flutter SDK](https://docs.revenuecat.com/docs/flutter)
- [Flutter in_app_purchase](https://pub.dev/packages/in_app_purchase)
- [Google Play Billing](https://developer.android.com/google/play/billing)
- [App Store Connect](https://developer.apple.com/app-store-connect/)

### ベストプラクティス

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Google Play Developer Policy](https://play.google.com/about/developer-content-policy/)
- [Subscription Best Practices](https://developer.apple.com/app-store/subscriptions/)

---

**注意**: この実装ガイドは参考資料です。実際の実装時は、各プラットフォームの最新ガイドラインとポリシーを確認してください。
