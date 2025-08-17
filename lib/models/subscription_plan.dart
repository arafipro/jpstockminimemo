/// サブスクリプションプランのモデル
class SubscriptionPlan {
  final String id;
  final String name;
  final String price;
  final String period;
  final String description;
  final bool isPopular;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.description,
    required this.isPopular,
  });
}
