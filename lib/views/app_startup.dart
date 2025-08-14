import "package:jpstockminimemo/constants/imports.dart";

class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  bool _isLoading = true;
  bool _onboardingCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  Future<void> _checkAppState() async {
    // オンボーディング完了状態をチェック
    final onboardingCompleted = await OnboardingService.isOnboardingCompleted();

    // ローディング時間を少し長くして、スムーズな遷移を確保
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _onboardingCompleted = onboardingCompleted;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadPage(),
      );
    }

    if (!_onboardingCompleted) {
      return const OnboardingPage();
    }

    return Consumer<SettingsModel>(
      builder: (
        context,
        model,
        child,
      ) {
        return Scaffold(
          body: model.startEditPage
              ? EditPage(stockmemo: null)
              : const ListPage(),
        );
      },
    );
  }
}
