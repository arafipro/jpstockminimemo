import "package:jpstockminimemo/constants/imports.dart";

final List<SubscriptionPlan> plans = [
  const SubscriptionPlan(
    id: "premium_weekly",
    name: "週額プラン",
    price: "¥120",
    period: "週",
    description: "1週間無料トライアル付き",
    isPopular: false,
  ),
  const SubscriptionPlan(
    id: "premium_monthly",
    name: "月額プラン",
    price: "¥480",
    period: "月",
    description: "1週間無料トライアル付き",
    isPopular: true,
  ),
  const SubscriptionPlan(
    id: "premium_yearly",
    name: "年額プラン",
    price: "¥4,800",
    period: "年",
    description: "1週間無料トライアル付き",
    isPopular: false,
  ),
];
