import 'package:flutter/foundation.dart';
import "package:jpstockminimemo/constants/imports.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsModel>(
      // 全ての設定値を取得
      create: (_) => SettingsModel()..getAllSettings(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text(
            "設定",
            style: titleTextStyle20,
          ),
        ),
        body: Consumer(
          builder: (
            BuildContext context,
            SettingsModel model,
            Widget? child,
          ) =>
              ListView(
            children: [
              ListTile(
                title: const Text("いきなり入力"),
                subtitle: const Text("起動時に新規登録を表示する"),
                trailing: Switch(
                  value: model.startEditPage,
                  onChanged: (value) => model.setStartEditPage(value),
                ),
              ),
              FutureBuilder<PackageInfo>(
                future: _getPackageInfo(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<PackageInfo> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return const Text("ERROR");
                  } else if (!snapshot.hasData) {
                    return const Text("Loading...");
                  }
                  final data = snapshot.data!;
                  return ListTile(
                    title: const Text("アプリバージョン"),
                    subtitle: Text(data.version),
                  );
                },
              ),
              // デバッグ用メニュー（デバッグビルド時のみ表示）
              if (kDebugMode) ...[
                // デバッグ用：オンボーディング状態表示
                FutureBuilder<bool>(
                  future: OnboardingService.getOnboardingStatus(),
                  builder: (context, snapshot) {
                    final isCompleted = snapshot.data ?? false;
                    return ListTile(
                      title: const Text("オンボーディング状態"),
                      subtitle: Text(isCompleted ? "完了済み" : "未完了"),
                      trailing: Icon(
                        isCompleted ? Icons.check_circle : Icons.pending,
                        color: isCompleted ? Colors.green : Colors.orange,
                      ),
                    );
                  },
                ),
                // デバッグ用：オンボーディングリセット
                ListTile(
                  title: const Text("オンボーディングをリセット"),
                  subtitle: const Text("開発・テスト用（デバッグ時のみ表示）"),
                  trailing: const Icon(Icons.refresh),
                  onTap: () async {
                    await OnboardingService.resetOnboarding();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("オンボーディングがリセットされました。"),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // 少し待ってからオンボーディング画面に遷移
                      await Future.delayed(const Duration(seconds: 2));
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const OnboardingPage(),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
