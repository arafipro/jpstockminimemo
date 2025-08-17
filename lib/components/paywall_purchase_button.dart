import "package:jpstockminimemo/constants/imports.dart";

class PaywallPurchaseButton extends StatelessWidget {
  const PaywallPurchaseButton({super.key});

  @override
  Widget build(BuildContext context) {
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
}
