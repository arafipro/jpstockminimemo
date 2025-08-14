import "package:jpstockminimemo/constants/imports.dart";

class PaywallRestoreButton extends StatelessWidget {
  const PaywallRestoreButton({super.key});

  @override
  Widget build(BuildContext context) {
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
}
