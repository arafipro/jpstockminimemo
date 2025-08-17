import "package:jpstockminimemo/constants/imports.dart";

class PaywallFeatures extends StatelessWidget {
  const PaywallFeatures({super.key});

  @override
  Widget build(BuildContext context) {
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
            .map((feature) => PaywallFeatureItem(
                  icon: feature["icon"] as IconData,
                  title: feature["title"] as String,
                  description: feature["description"] as String,
                ))
            .toList(),
      ],
    );
  }
}
