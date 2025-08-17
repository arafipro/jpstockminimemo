import "package:jpstockminimemo/constants/imports.dart";

class PaywallHeader extends StatelessWidget {
  const PaywallHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
}
