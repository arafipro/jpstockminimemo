/// サブスクリプション状態のモデル
///
/// このモデルは課金状態を管理し、アプリ全体で一貫した状態管理を提供します。
/// RevenueCat の CustomerInfo から取得した情報を基に、
/// アプリ内で使用しやすい形式に変換します。
class SubscriptionStatus {
  /// サブスクリプション状態の種類
  final StatusType statusType;

  /// サブスクリプションの開始日
  final DateTime? startDate;

  /// サブスクリプションの終了日
  final DateTime? endDate;

  /// トライアル期間の終了日（トライアル中の場合）
  final DateTime? trialEndDate;

  /// サブスクリプションの識別子
  final String? subscriptionId;

  /// プラットフォーム（iOS/Android）
  final String? platform;

  const SubscriptionStatus({
    required this.statusType,
    this.startDate,
    this.endDate,
    this.trialEndDate,
    this.subscriptionId,
    this.platform,
  });

  /// 未購入状態のファクトリメソッド
  factory SubscriptionStatus.none() {
    return const SubscriptionStatus(statusType: StatusType.none);
  }

  /// トライアル状態のファクトリメソッド
  factory SubscriptionStatus.trial({
    required DateTime trialEndDate,
    String? subscriptionId,
    String? platform,
  }) {
    return SubscriptionStatus(
      statusType: StatusType.trial,
      trialEndDate: trialEndDate,
      subscriptionId: subscriptionId,
      platform: platform,
    );
  }

  /// アクティブ状態のファクトリメソッド
  factory SubscriptionStatus.active({
    required DateTime startDate,
    required DateTime endDate,
    String? subscriptionId,
    String? platform,
  }) {
    return SubscriptionStatus(
      statusType: StatusType.active,
      startDate: startDate,
      endDate: endDate,
      subscriptionId: subscriptionId,
      platform: platform,
    );
  }

  /// 期限切れ状態のファクトリメソッド
  factory SubscriptionStatus.expired({
    required DateTime startDate,
    required DateTime endDate,
    String? subscriptionId,
    String? platform,
  }) {
    return SubscriptionStatus(
      statusType: StatusType.expired,
      startDate: startDate,
      endDate: endDate,
      subscriptionId: subscriptionId,
      platform: platform,
    );
  }

  /// プレミアム機能が利用可能かどうか
  bool get isPremium {
    return statusType == StatusType.trial || statusType == StatusType.active;
  }

  /// トライアル期間が残っているかどうか
  bool get isInTrial {
    if (statusType != StatusType.trial || trialEndDate == null) {
      return false;
    }
    return DateTime.now().isBefore(trialEndDate!);
  }

  /// サブスクリプションが有効かどうか
  bool get isActive {
    if (statusType != StatusType.active || endDate == null) {
      return false;
    }
    return DateTime.now().isBefore(endDate!);
  }

  /// 状態の日本語表示名を取得
  String get displayName {
    switch (statusType) {
      case StatusType.none:
        return "未購入";
      case StatusType.trial:
        return isInTrial ? "トライアル中" : "トライアル終了";
      case StatusType.active:
        return isActive ? "アクティブ" : "期限切れ";
      case StatusType.expired:
        return "期限切れ";
    }
  }

  /// 残り日数を取得
  int? get remainingDays {
    if (statusType == StatusType.trial && trialEndDate != null) {
      return trialEndDate!.difference(DateTime.now()).inDays;
    }
    if (statusType == StatusType.active && endDate != null) {
      return endDate!.difference(DateTime.now()).inDays;
    }
    return null;
  }

  /// JSON から SubscriptionStatus を作成
  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      statusType: StatusType.values[json["statusType"] as int],
      startDate: json["startDate"] != null
          ? DateTime.parse(json["startDate"] as String)
          : null,
      endDate: json["endDate"] != null
          ? DateTime.parse(json["endDate"] as String)
          : null,
      trialEndDate: json["trialEndDate"] != null
          ? DateTime.parse(json["trialEndDate"] as String)
          : null,
      subscriptionId: json["subscriptionId"] as String?,
      platform: json["platform"] as String?,
    );
  }

  /// SubscriptionStatus を JSON に変換
  Map<String, dynamic> toJson() {
    return {
      "statusType": statusType.index,
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "trialEndDate": trialEndDate?.toIso8601String(),
      "subscriptionId": subscriptionId,
      "platform": platform,
    };
  }

  /// コピーメソッド
  SubscriptionStatus copyWith({
    StatusType? statusType,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? trialEndDate,
    String? subscriptionId,
    String? platform,
  }) {
    return SubscriptionStatus(
      statusType: statusType ?? this.statusType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      platform: platform ?? this.platform,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubscriptionStatus &&
        other.statusType == statusType &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.trialEndDate == trialEndDate &&
        other.subscriptionId == subscriptionId &&
        other.platform == platform;
  }

  @override
  int get hashCode {
    return Object.hash(
      statusType,
      startDate,
      endDate,
      trialEndDate,
      subscriptionId,
      platform,
    );
  }

  @override
  String toString() {
    return "SubscriptionStatus("
        "statusType: $statusType, "
        "startDate: $startDate, "
        "endDate: $endDate, "
        "trialEndDate: $trialEndDate, "
        "subscriptionId: $subscriptionId, "
        "platform: $platform)";
  }
}

/// サブスクリプション状態の種類を表す列挙型
enum StatusType {
  /// 未購入
  none,

  /// 無料トライアル中
  trial,

  /// アクティブ（有料サブスクリプション）
  active,

  /// 期限切れ
  expired,
}
