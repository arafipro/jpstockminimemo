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
          onPressed: () => _closePaywall(context),
        ),
        title: const Text(
          "プレミアム機能",
          style: titleTextStyle20,
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PaywallHeader(),
            SizedBox(height: 32),
            PaywallFeatures(),
            SizedBox(height: 32),
            PaywallPlans(),
            SizedBox(height: 24),
            PaywallPurchaseButton(),
            SizedBox(height: 16),
            PaywallRestoreButton(),
            SizedBox(height: 16),
            PaywallTerms(),
          ],
        ),
      ),
    );
  }

  /// ペイウォール画面を閉じてメイン画面に遷移
  void _closePaywall(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Consumer<SettingsModel>(
          builder: (context, model, child) {
            return Scaffold(
              body: model.startEditPage
                  ? EditPage(stockmemo: null)
                  : const ListPage(),
            );
          },
        ),
      ),
    );
  }
}
