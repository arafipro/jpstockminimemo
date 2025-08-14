import "package:jpstockminimemo/constants/imports.dart";

class PaywallTerms extends StatelessWidget {
  const PaywallTerms({super.key});

  @override
  Widget build(BuildContext context) {
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
