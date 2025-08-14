import "package:jpstockminimemo/constants/imports.dart";

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.close, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "プレミアム機能",
          style: titleTextStyle20,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ヘッダーセクション
            _buildHeaderSection(),
            const SizedBox(height: 32),

            // 機能紹介セクション
            _buildFeaturesSection(),
            const SizedBox(height: 32),

            // プラン選択セクション
            _buildPlansSection(),
            const SizedBox(height: 24),

            // 購入ボタン
            _buildPurchaseButton(context),
            const SizedBox(height: 16),

            // 復元ボタン
            _buildRestoreButton(context),
            const SizedBox(height: 16),

            // 利用規約リンク
            _buildTermsLinks(),
          ],
        ),
      ),
    );
  }

  /// ヘッダーセクション
  Widget _buildHeaderSection() {
    return const Column(
      children: [
        Icon(
          Icons.star,
          size: 64,
          color: appBarColor,
        ),
        SizedBox(height: 16),
        Text(
          "プレミアム機能で\nより快適に",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: appBarColor,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          "1週間無料トライアルで\nすべての機能をお試しください",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 機能紹介セクション
  Widget _buildFeaturesSection() {
    final features = [
      {"icon": Icons.block, "title": "広告の完全削除", "description": "快適な使用環境"},
      {
        "icon": Icons.all_inclusive,
        "title": "メモ数の無制限",
        "description": "制限なくメモを保存"
      },
      {"icon": Icons.backup, "title": "データバックアップ", "description": "大切なデータを保護"},
      {"icon": Icons.search, "title": "検索機能", "description": "素早くメモを検索"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "プレミアム機能",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: appBarColor,
          ),
        ),
        const SizedBox(height: 16),
        ...features
            .map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: appBarColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          feature["icon"] as IconData,
                          color: appBarColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feature["title"] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              feature["description"] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  /// プラン選択セクション
  Widget _buildPlansSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "プランを選択",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: appBarColor,
          ),
        ),
        const SizedBox(height: 16),
        ...plans
            .map((plan) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildPlanCard(plan),
                ))
            .toList(),
      ],
    );
  }

  /// プランカード
  Widget _buildPlanCard(SubscriptionPlan plan) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: plan.isPopular ? appBarColor : Colors.grey.shade300,
          width: plan.isPopular ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color:
            plan.isPopular ? appBarColor.withValues(alpha: 0.05) : Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plan.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: plan.isPopular ? appBarColor : Colors.black87,
                        ),
                      ),
                      if (plan.isPopular) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: appBarColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "おすすめ",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plan.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan.price,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: plan.isPopular ? appBarColor : Colors.black87,
                  ),
                ),
                Text(
                  "/${plan.period}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 購入ボタン
  Widget _buildPurchaseButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // TODO: 購入処理を実装（Phase 2）
        debugPrint("Purchase button tapped");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: appBarColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        "1週間無料トライアルを開始",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 復元ボタン
  Widget _buildRestoreButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        // TODO: 復元処理を実装（Phase 2）
        debugPrint("Restore button tapped");
      },
      child: const Text(
        "購入を復元",
        style: TextStyle(
          color: appBarColor,
          fontSize: 16,
        ),
      ),
    );
  }

  /// 利用規約リンク
  Widget _buildTermsLinks() {
    return Column(
      children: [
        const Text(
          "続行することで、",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // TODO: 利用規約ページを開く
                debugPrint("Terms of service tapped");
              },
              child: const Text(
                "利用規約",
                style: TextStyle(
                  fontSize: 12,
                  color: appBarColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Text(
              "と",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: プライバシーポリシーページを開く
                debugPrint("Privacy policy tapped");
              },
              child: const Text(
                "プライバシーポリシー",
                style: TextStyle(
                  fontSize: 12,
                  color: appBarColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Text(
              "に同意します",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
