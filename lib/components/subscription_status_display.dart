import "package:jpstockminimemo/constants/imports.dart";

/// 課金状態を表示するコンポーネント
class SubscriptionStatusDisplay extends StatelessWidget {
  const SubscriptionStatusDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RevenueCatService>(
      builder: (context, revenueCatService, child) {
        debugPrint(
            "SubscriptionStatusDisplay: Building with RevenueCatService");
        return StreamBuilder<SubscriptionStatus>(
          stream: revenueCatService.statusStream,
          builder: (context, snapshot) {
            debugPrint(
                "SubscriptionStatusDisplay: StreamBuilder snapshot - hasData: ${snapshot.hasData}, hasError: ${snapshot.hasError}, error: ${snapshot.error}");
            if (snapshot.hasData) {
              final status = snapshot.data!;
              debugPrint(
                  "SubscriptionStatusDisplay: Status received - ${status.statusType}");
              return _buildStatusWidget(context, status);
            }
            debugPrint(
                "SubscriptionStatusDisplay: No data, showing loading widget");
            return _buildLoadingWidget();
          },
        );
      },
    );
  }

  Widget _buildStatusWidget(BuildContext context, SubscriptionStatus status) {
    switch (status.statusType) {
      case StatusType.none:
        return _buildUpgradePrompt(context);
      case StatusType.trial:
        return _buildTrialStatus(context, status);
      case StatusType.active:
        return _buildActiveStatus(context, status);
      case StatusType.expired:
        return _buildExpiredStatus(context, status);
    }
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildUpgradePrompt(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: Colors.orange.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            color: Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "プレミアム機能で広告を削除",
              style: TextStyle(
                color: Colors.orange[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaywallPage(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "アップグレード",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrialStatus(BuildContext context, SubscriptionStatus status) {
    final remainingDays = status.remainingDays ?? 0;
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: Colors.blue.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time,
            color: Colors.blue,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "無料トライアル中 - 残り$remainingDays日",
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.blue,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveStatus(BuildContext context, SubscriptionStatus status) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: Colors.green.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified,
            color: Colors.green,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "プレミアム会員",
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredStatus(BuildContext context, SubscriptionStatus status) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning,
            color: Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "サブスクリプションが期限切れです",
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaywallPage(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "更新",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
