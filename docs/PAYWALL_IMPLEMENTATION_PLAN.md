# 🚀 1 週間無料トライアル付きペイウォール実装計画

日本株ひとこと投資メモアプリに 1 週間無料トライアル付きサブスクリプション機能を実装する計画です。

## 📋 目次

1. [概要](#概要)
2. [実装フェーズ](#実装フェーズ)
3. [技術仕様](#技術仕様)
4. [価格プラン](#価格プラン)
5. [実装手順](#実装手順)

---

## 🎯 概要

### 基本情報

- **技術スタック**: Flutter + RevenueCat + Provider
- **実装期間**: 約 3 週間
- **対象プラットフォーム**: iOS, Android

### 主要機能

- 1 週間無料トライアル付きサブスクリプション
- 週額・月額・年額の 3 つのプラン
- 広告削除機能
- 購入復元機能
- オフライン時の課金状態管理

---

## 📅 実装フェーズ

### Phase 1: 最小限の基盤構築 (3-4 日)

**ブランチ名**: `feature/minimal-paywall-foundation`

#### Step 1.1: RevenueCat 基本設定 (1 日)

| タスク       | 内容                                                                   | 完了 |
| ------------ | ---------------------------------------------------------------------- | ---- |
| タスク 1.1.1 | `pubspec.yaml` に依存関係追加                                          | [x]  |
| タスク 1.1.2 | `lib/services/revenue_cat_service.dart` 作成（最小限の機能）           | [x]  |
| タスク 1.1.3 | `main.dart` で RevenueCat 初期化                                       | [x]  |
| タスク 1.1.4 | **動作確認**: アプリ起動時に RevenueCat が正常に初期化されることを確認 | [x]  |

#### Step 1.2: 基本的なペイウォール画面 (1 日)

| タスク       | 内容                                                                       | 完了 |
| ------------ | -------------------------------------------------------------------------- | ---- |
| タスク 1.2.1 | `lib/views/paywall_page.dart` 作成（シンプルな UI）                        | [ ]  |
| タスク 1.2.2 | `lib/constants/subscription_plans.dart` 作成                               | [x]  |
| タスク 1.2.3 | メイン画面からペイウォール画面への遷移追加                                 | [ ]  |
| タスク 1.2.4 | **動作確認**: ペイウォール画面が表示され、プラン一覧が表示されることを確認 | [ ]  |

#### Step 1.3: 基本的な課金状態管理 (1 日)

| タスク       | 内容                                                       | 完了 |
| ------------ | ---------------------------------------------------------- | ---- |
| タスク 1.3.1 | `lib/models/subscription_status.dart` 作成                 | [ ]  |
| タスク 1.3.2 | `lib/services/revenue_cat_service.dart` に状態管理機能追加 | [ ]  |
| タスク 1.3.3 | メイン画面で課金状態を表示                                 | [ ]  |
| タスク 1.3.4 | **動作確認**: 課金状態が正しく表示されることを確認         | [ ]  |

#### Step 1.4: オフライン対応の基本実装 (1 日)

| タスク       | 内容                                                            | 完了 |
| ------------ | --------------------------------------------------------------- | ---- |
| タスク 1.4.1 | `lib/services/offline_subscription_manager.dart` 作成（最小限） | [ ]  |
| タスク 1.4.2 | ローカルストレージでの状態保存                                  | [ ]  |
| タスク 1.4.3 | **動作確認**: オフライン時でも課金状態が表示されることを確認    | [ ]  |

### Phase 2: 課金機能の段階的実装 (1 週間)

**ブランチ名**: `feature/step-by-step-subscription`

#### Step 2.1: サブスクリプション購入機能 (2 日)

| タスク       | 内容                                                               | 完了 |
| ------------ | ------------------------------------------------------------------ | ---- |
| タスク 2.1.1 | `lib/services/revenue_cat_service.dart` に購入機能追加             | [ ]  |
| タスク 2.1.2 | `lib/views/paywall_page.dart` に購入ボタン追加                     | [ ]  |
| タスク 2.1.3 | **動作確認**: 購入ボタンをタップして課金画面が表示されることを確認 | [ ]  |

#### Step 2.2: 無料トライアル機能 (2 日)

| タスク       | 内容                                                                 | 完了 |
| ------------ | -------------------------------------------------------------------- | ---- |
| タスク 2.2.1 | `lib/services/revenue_cat_service.dart` にトライアル機能追加         | [ ]  |
| タスク 2.2.2 | トライアル開始・終了の処理                                           | [ ]  |
| タスク 2.2.3 | **動作確認**: トライアル開始後、プレミアム機能が利用できることを確認 | [ ]  |

#### Step 2.3: 購入復元機能 (1 日)

| タスク       | 内容                                                       | 完了 |
| ------------ | ---------------------------------------------------------- | ---- |
| タスク 2.3.1 | `lib/services/revenue_cat_service.dart` に復元機能追加     | [ ]  |
| タスク 2.3.2 | ペイウォール画面に復元ボタン追加                           | [ ]  |
| タスク 2.3.3 | **動作確認**: 復元ボタンで過去の購入が復元されることを確認 | [ ]  |

#### Step 2.4: 広告削除機能の統合 (2 日)

| タスク       | 内容                                                   | 完了 |
| ------------ | ------------------------------------------------------ | ---- |
| タスク 2.4.1 | 既存の広告表示ロジックを修正                           | [ ]  |
| タスク 2.4.2 | 課金状態に応じた広告表示制御                           | [ ]  |
| タスク 2.4.3 | **動作確認**: 課金後、広告が表示されなくなることを確認 | [ ]  |

### Phase 3: 高度な機能実装 (1 週間)

**ブランチ名**: `feature/advanced-features`

#### Step 3.1: A/B テスト機能 (2 日)

| タスク       | 内容                                                     | 完了 |
| ------------ | -------------------------------------------------------- | ---- |
| タスク 3.1.1 | `lib/services/revenue_cat_ab_test_service.dart` 作成     | [ ]  |
| タスク 3.1.2 | ペイウォール画面に A/B テスト機能統合                    | [ ]  |
| タスク 3.1.3 | **動作確認**: 異なるバリエーションが表示されることを確認 | [ ]  |

#### Step 3.2: 通知機能 (2 日)

| タスク       | 内容                                           | 完了 |
| ------------ | ---------------------------------------------- | ---- |
| タスク 3.2.1 | `lib/services/notification_service.dart` 作成  | [ ]  |
| タスク 3.2.2 | トライアル終了リマインダー                     | [ ]  |
| タスク 3.2.3 | **動作確認**: 通知が正しく送信されることを確認 | [ ]  |

#### Step 3.3: オフライン機能強化 (2 日)

| タスク       | 内容                                                        | 完了 |
| ------------ | ----------------------------------------------------------- | ---- |
| タスク 3.3.1 | `lib/services/offline_subscription_manager.dart` 機能拡張   | [ ]  |
| タスク 3.3.2 | ネットワーク復帰時の同期機能                                | [ ]  |
| タスク 3.3.3 | **動作確認**: オフライン → オンライン復帰時の状態同期を確認 | [ ]  |

#### Step 3.4: UI/UX 改善 (1 日)

| タスク       | 内容                                                              | 完了 |
| ------------ | ----------------------------------------------------------------- | ---- |
| タスク 3.4.1 | ペイウォール画面のデザイン改善                                    | [ ]  |
| タスク 3.4.2 | ローディング状態の追加                                            | [ ]  |
| タスク 3.4.3 | エラーハンドリングの改善                                          | [ ]  |
| タスク 3.4.4 | **動作確認**: UI が改善され、エラー処理が適切に動作することを確認 | [ ]  |

---

## 🏗️ 技術仕様

### 段階的なファイル構造

#### Phase 1 完了時

```
lib/
├── services/
│   ├── revenue_cat_service.dart          # 基本機能のみ
│   └── offline_subscription_manager.dart # 最小限の機能
├── models/
│   └── subscription_status.dart          # 基本モデル
├── views/
│   └── paywall_page.dart                 # シンプルなUI
└── constants/
    └── subscription_plans.dart           # プラン定義
```

#### Phase 2 完了時

```
lib/
├── services/
│   ├── revenue_cat_service.dart          # 購入・トライアル・復元機能追加
│   └── offline_subscription_manager.dart # 基本機能
├── models/
│   └── subscription_status.dart
├── views/
│   └── paywall_page.dart                 # 購入ボタン・復元ボタン追加
└── constants/
    └── subscription_plans.dart
```

#### Phase 3 完了時

```
lib/
├── services/
│   ├── revenue_cat_service.dart
│   ├── offline_subscription_manager.dart # 機能拡張
│   ├── revenue_cat_ab_test_service.dart  # 新規追加
│   └── notification_service.dart         # 新規追加
├── models/
│   ├── subscription_status.dart
│   └── experiment_config.dart            # 新規追加
├── views/
│   └── paywall_page.dart                 # UI改善
├── components/
│   ├── subscription_plan_card.dart       # 新規追加
│   └── subscription_features_list.dart   # 新規追加
└── constants/
    ├── subscription_plans.dart
    └── notification_types.dart           # 新規追加
```

### 状態管理

```dart
enum SubscriptionStatus {
  none,           // 未購入
  trial,          // 無料トライアル中
  active,         // アクティブ
  expired         // 期限切れ
}

// 段階的に機能を追加
class RevenueCatService {
  // Phase 1: 基本機能
  Future<void> initialize() async { /* 初期化 */ }
  Future<SubscriptionStatus> getSubscriptionStatus() async { /* 状態取得 */ }

  // Phase 2: 課金機能
  Future<bool> purchaseSubscription(String productId) async { /* 購入 */ }
  Future<bool> startTrial() async { /* トライアル開始 */ }
  Future<bool> restorePurchases() async { /* 復元 */ }

  // Phase 3: 高度な機能
  Future<Offering?> getExperimentOffering() async { /* A/B テスト */ }
  Future<void> scheduleNotifications() async { /* 通知設定 */ }
}
```

---

## 💰 価格プラン

| プラン   | 価格      | 無料期間   | 製品 ID           |
| -------- | --------- | ---------- | ----------------- |
| **週額** | ¥120/週   | 1 週間無料 | `premium_weekly`  |
| **月額** | ¥480/月   | 1 週間無料 | `premium_monthly` |
| **年額** | ¥4,800/年 | 1 週間無料 | `premium_yearly`  |

### プレミアム機能

- 広告の完全削除
- メモ数の無制限
- データバックアップ（将来実装）
- 検索機能（将来実装）

---

## 🧪 RevenueCat A/B テスト機能

### テスト対象項目

| テスト項目               | バリエーション                     | 目的                       |
| ------------------------ | ---------------------------------- | -------------------------- |
| **価格設定**             | 通常価格 / 割引価格 / 特別価格     | 最適な価格設定の特定       |
| **無料トライアル期間**   | 3 日間 / 1 週間 / 2 週間           | 最適なトライアル期間の特定 |
| **製品構成**             | 単一プラン / 複数プラン / 年額優先 | 最も効果的な製品構成       |
| **ペイウォールデザイン** | シンプル / 詳細 / カード型         | 最も効果的な UI デザイン   |
| **デフォルト選択**       | 月額 / 年額 / 週額                 | 最適なデフォルト選択       |

### RevenueCat Experiments 設定

```dart
class RevenueCatABTestService {
  // RevenueCat Experiments を使用した A/B テスト
  Future<Offering?> getExperimentOffering() async {
    try {
      final offerings = await Purchases.getOfferings();

      // 実験用のオファリングを取得
      final experimentOffering = offerings.all['experiment_group'];
      if (experimentOffering != null && experimentOffering.availablePackages.isNotEmpty) {
        return experimentOffering;
      }

      // デフォルトオファリングを返す
      return offerings.current;
    } catch (e) {
      print('Error getting experiment offering: $e');
      return null;
    }
  }

  // オファリングメタデータを使用した A/B テスト
  Future<Map<String, dynamic>> getPaywallVariants() async {
    try {
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;

      if (currentOffering?.metadata != null) {
        return {
          'buttonColor': currentOffering!.metadata['buttonColor'] ?? '#007AFF',
          'description': currentOffering.metadata['description'] ?? 'デフォルト説明',
          'title': currentOffering.metadata['title'] ?? 'プレミアム機能',
          'showTrialBadge': currentOffering.metadata['showTrialBadge'] ?? true,
        };
      }

      return {
        'buttonColor': '#007AFF',
        'description': 'デフォルト説明',
        'title': 'プレミアム機能',
        'showTrialBadge': true,
      };
    } catch (e) {
      print('Error getting paywall variants: $e');
      return {};
    }
  }

  // 実験結果の追跡
  Future<void> trackExperimentEvent(String eventName, Map<String, dynamic> properties) async {
    try {
      // RevenueCat の分析イベントを送信
      await Purchases.logEvent(eventName, properties);
    } catch (e) {
      print('Error tracking experiment event: $e');
    }
  }
}
```

### 実験設定手順

1. **RevenueCat ダッシュボードで実験を作成**

   - 実験名: "ペイウォール最適化実験"
   - コントロールグループ: 現在のオファリング
   - 治療グループ: 新しいオファリング

2. **オファリングの設定**

   ```dart
   // コントロールグループ用オファリング
   Offering(
     identifier: 'control_group',
     packages: [monthlyPackage, yearlyPackage],
     metadata: {
       'buttonColor': '#007AFF',
       'description': '現在の説明文',
     }
   )

   // 治療グループ用オファリング
   Offering(
     identifier: 'treatment_group',
     packages: [monthlyPackage, yearlyPackage],
     metadata: {
       'buttonColor': '#FF6B35',
       'description': '新しい説明文',
     }
   )
   ```

3. **実験参加者の割り当て**

   - 新規ユーザーの 20% を実験に参加
   - コントロールグループ: 10%
   - 治療グループ: 10%

4. **メトリクスの追跡**
   - コンバージョン率
   - 平均収益（ARPU）
   - サブスクリプション継続率
   - ペイウォール表示回数

---

## 🔔 RevenueCat + ローカル通知機能

### 通知タイプ

| 通知タイプ           | タイミング       | 実装方法            | 内容                                 |
| -------------------- | ---------------- | ------------------- | ------------------------------------ |
| **トライアル開始**   | アプリ初回起動時 | RevenueCat 自動通知 | 無料トライアル開始のお知らせ         |
| **トライアル終了前** | 終了 3 日前      | ローカル通知        | トライアル終了のリマインダー         |
| **トライアル終了**   | 終了当日         | RevenueCat 自動通知 | トライアル終了とプレミアム機能の案内 |
| **特別オファー**     | 定期的           | ローカル通知        | 限定クーポンや割引の案内             |
| **機能紹介**         | 新機能リリース時 | ローカル通知        | 新機能の紹介とプレミアム機能の案内   |

### RevenueCat 自動通知設定

```dart
class RevenueCatNotificationService {
  // RevenueCatの自動通知機能を有効化
  Future<void> enableRevenueCatNotifications() async {
    try {
      // トライアル終了リマインダーの自動設定
      await Purchases.shared.enableTrialEndReminders();

      // サブスクリプション状態変更の通知
      await Purchases.shared.enableSubscriptionStatusNotifications();

      // 特別オファーの自動通知
      await Purchases.shared.enablePromotionalNotifications();
    } catch (e) {
      print('Error enabling RevenueCat notifications: $e');
    }
  }

  // 通知リスナーの設定
  void setupNotificationListeners() {
    Purchases.shared.addCustomerInfoUpdateListener((customerInfo) {
      // サブスクリプション状態変更時の処理
      _handleSubscriptionStatusChange(customerInfo);
    });
  }

  // サブスクリプション状態変更の処理
  void _handleSubscriptionStatusChange(CustomerInfo customerInfo) {
    if (customerInfo.entitlements.active.isEmpty) {
      // サブスクリプションが終了した場合の処理
      _scheduleReactivationReminder();
    }
  }
}
```

### ローカル通知設定

```dart
class LocalNotificationService {
  // トライアル終了前のリマインダー設定
  Future<void> scheduleTrialEndReminder(DateTime trialEndDate) async {
    final reminderDate = trialEndDate.subtract(const Duration(days: 3));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'トライアル終了まであと3日',
      'プレミアム機能を継続してご利用いただけます',
      tz.TZDateTime.from(reminderDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'trial_reminder',
          'Trial Reminder',
          importance: Importance.high,
          channelDescription: 'トライアル終了のリマインダー',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // 特別オファーの通知設定
  Future<void> scheduleSpecialOffer() async {
    // ユーザーの行動パターンに基づいて最適なタイミングで通知
    final optimalTime = await _calculateOptimalNotificationTime();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      '特別オファー',
      '今なら50%OFFでプレミアム機能をご利用いただけます',
      optimalTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'special_offer',
          'Special Offer',
          importance: Importance.high,
          channelDescription: '特別オファーのお知らせ',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // 最適な通知タイミングの計算
  Future<tz.TZDateTime> _calculateOptimalNotificationTime() async {
    // ユーザーの使用パターンを分析して最適な時間を決定
    final userPreferences = await _getUserNotificationPreferences();
    final optimalHour = userPreferences['optimalHour'] ?? 20; // デフォルト20時

    final now = tz.TZDateTime.now(tz.local);
    var optimalTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, optimalHour);

    // 今日の最適時間が過ぎている場合は明日に設定
    if (optimalTime.isBefore(now)) {
      optimalTime = optimalTime.add(const Duration(days: 1));
    }

    return optimalTime;
  }
}
```

### 通知権限管理

```dart
class NotificationPermissionManager {
  // 通知権限の確認と要求
  Future<bool> requestNotificationPermission() async {
    final status = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return status?.alert == true;
  }

  // 通知設定の確認
  Future<bool> isNotificationEnabled() async {
    final status = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();

    return status ?? false;
  }

  // 通知チャンネルの設定（Android）
  Future<void> setupNotificationChannels() async {
    const androidChannel = AndroidNotificationChannel(
      'trial_reminder',
      'Trial Reminder',
      description: 'トライアル終了のリマインダー',
      importance: Importance.high,
    );

    const specialOfferChannel = AndroidNotificationChannel(
      'special_offer',
      'Special Offer',
      description: '特別オファーのお知らせ',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(specialOfferChannel);
  }
}
```

---

## 🔧 実装手順

### 1. 準備作業 (1 日)

**ブランチ名**: `feature/setup-preparation`

- [ ] RevenueCat アカウント作成
- [ ] App Store Connect / Google Play Console 設定
- [ ] 製品 ID の設定
- [ ] API キーの取得

### 2. 依存関係追加

```yaml
dependencies:
  purchases_flutter: ^9.2.0
  purchases_ui_flutter: ^9.2.0
  connectivity_plus: ^6.1.5 # ネットワーク状態監視
  flutter_local_notifications: ^19.4.0 # ローカル通知用
```

### 3. 環境変数設定

```env
# .env
REVENUECAT_ANDROID_API_KEY=your_android_api_key
REVENUECAT_IOS_API_KEY=your_ios_api_key
```

### 4. 実装順序

1. RevenueCat サービスの作成
2. オフライン状態管理の実装
3. ペイウォール画面の実装
4. 課金機能の統合
5. 広告削除機能の実装
6. テスト・デバッグ

### 5. ブランチ戦略

```bash
# メインブランチ
main                    # 本番環境用
develop                 # 開発環境用

# 機能ブランチ
feature/setup-preparation           # 準備作業
feature/paywall-foundation          # Phase 1: 基盤構築
feature/subscription-implementation # Phase 2: 課金機能実装
feature/testing-optimization        # Phase 3: テスト・最適化

# リリースブランチ
release/v1.2.0-paywall              # ペイウォール機能リリース用

# ホットフィックスブランチ
hotfix/critical-paywall-bug         # 緊急バグ修正用
```

### 6. マージ戦略

1. **機能ブランチ** → **develop** (プルリクエスト)
2. **develop** → **release/v1.2.0-paywall** (リリース準備)
3. **release/v1.2.0-paywall** → **main** (本番リリース)
4. **main** → **develop** (本番反映)

---

## 📊 成功指標

### 技術指標

- 課金処理成功率 > 95%
- アプリ起動時間 < 3 秒
- クラッシュ率 < 0.1%
- オフライン時の状態表示精度 > 99%
- プッシュ通知配信成功率 > 90%

### ビジネス指標

- 無料トライアル開始率 > 30%
- トライアル → 有料変換率 > 15%
- 月間継続率 > 80%
- A/B テスト効果測定精度 > 95%
- プッシュ通知開封率 > 20%

---

## ⚠️ 注意事項

### 技術的考慮事項

- プラットフォーム固有の課金システムに対応
- 購入状態の永続化
- エラーハンドリングの実装
- オフライン時の適切な状態管理

### オフライン対応

- ローカルキャッシュでの課金状態管理
- ネットワーク復帰時の自動同期
- オフライン時の適切なユーザー案内
- 購入状態の整合性保証

### 法的要件

- プライバシーポリシーの更新
- 利用規約の更新
- 課金条件の明示
- キャンセル方法の案内
- ローカル通知の利用規約への追加
- A/B テストの利用規約への追加

---

## 📚 参考資料

- [RevenueCat Flutter SDK](https://docs.revenuecat.com/docs/flutter)
- [RevenueCat Experiments](https://docs.revenuecat.com/docs/experiments)
- [RevenueCat Paywalls](https://docs.revenuecat.com/docs/paywalls)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Google Play Developer Policy](https://play.google.com/about/developer-content-policy/)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
