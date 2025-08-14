import "package:jpstockminimemo/constants/imports.dart";

class PaywallPlans extends StatelessWidget {
  const PaywallPlans({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: PaywallPlanCard(plan: plan),
                ))
            .toList(),
      ],
    );
  }
}
