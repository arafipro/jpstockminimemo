import "package:jpstockminimemo/constants/imports.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsModel>(
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
        body: Consumer<SettingsModel>(
          builder: (context, model, child) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
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

                // オフラインサブスクリプション管理のテストセクション
                const SizedBox(height: 20),
                const Text(
                  "オフラインサブスクリプション管理テスト",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // デバッグ情報表示
                ElevatedButton(
                  onPressed: () => _showDebugInfo(context),
                  child: const Text("デバッグ情報を表示"),
                ),
                const SizedBox(height: 8),

                // 手動で状態保存テスト
                ElevatedButton(
                  onPressed: () => _testSaveStatus(context),
                  child: const Text("テスト状態を保存"),
                ),
                const SizedBox(height: 8),

                // 手動で状態取得テスト
                ElevatedButton(
                  onPressed: () => _testGetStatus(context),
                  child: const Text("保存された状態を取得"),
                ),
                const SizedBox(height: 8),

                // ネットワーク状態確認
                ElevatedButton(
                  onPressed: () => _checkNetworkStatus(context),
                  child: const Text("ネットワーク状態を確認"),
                ),
                const SizedBox(height: 8),

                // データクリア
                ElevatedButton(
                  onPressed: () => _clearOfflineData(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("オフラインデータをクリア"),
                ),
                const SizedBox(height: 8),

                // 強制オフラインテスト（Wi-Fiがない環境用）
                ElevatedButton(
                  onPressed: () => _forceOfflineTest(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("強制オフラインテスト"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// デバッグ情報を表示
  void _showDebugInfo(BuildContext context) async {
    final offlineManager = OfflineSubscriptionManager();
    await offlineManager.initialize();

    final debugInfo = offlineManager.getDebugInfo();
    final storageInfo = offlineManager.getStorageInfo();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("オフライン管理デバッグ情報"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("デバッグ情報:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...debugInfo.entries
                  .map((entry) => Text("${entry.key}: ${entry.value}")),
              const SizedBox(height: 16),
              const Text("ストレージ情報:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...storageInfo.entries
                  .map((entry) => Text("${entry.key}: ${entry.value}")),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("閉じる"),
          ),
        ],
      ),
    );
  }

  /// テスト状態を保存
  void _testSaveStatus(BuildContext context) async {
    final offlineManager = OfflineSubscriptionManager();
    await offlineManager.initialize();

    // テスト用のサブスクリプション状態を作成
    final testStatus = SubscriptionStatus.trial(
      trialEndDate: DateTime.now().add(const Duration(days: 7)),
      subscriptionId: "test_subscription_123",
      platform: "test",
    );

    final success = await offlineManager.saveSubscriptionStatus(testStatus);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? "テスト状態を保存しました: ${testStatus.statusType}"
            : "テスト状態の保存に失敗しました"),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  /// 保存された状態を取得
  void _testGetStatus(BuildContext context) async {
    final offlineManager = OfflineSubscriptionManager();
    await offlineManager.initialize();

    final status = await offlineManager.getOfflineSubscriptionStatus();

    if (status != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("取得された状態"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("状態タイプ: ${status.statusType}"),
              Text("表示名: ${status.displayName}"),
              Text("プレミアム: ${status.isPremium}"),
              if (status.trialEndDate != null)
                Text("トライアル終了: ${status.trialEndDate!.toLocal()}"),
              if (status.startDate != null)
                Text("開始日: ${status.startDate!.toLocal()}"),
              if (status.endDate != null)
                Text("終了日: ${status.endDate!.toLocal()}"),
              if (status.remainingDays != null)
                Text("残り日数: ${status.remainingDays}日"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("閉じる"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("保存された状態が見つかりません"),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  /// ネットワーク状態を確認
  void _checkNetworkStatus(BuildContext context) async {
    final offlineManager = OfflineSubscriptionManager();
    await offlineManager.initialize();

    final isOnline = await offlineManager.isOnline();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isOnline ? "オンライン" : "オフライン"),
        backgroundColor: isOnline ? Colors.green : Colors.red,
      ),
    );
  }

  /// オフラインデータをクリア
  void _clearOfflineData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("確認"),
        content: const Text("オフラインデータをクリアしますか？"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("キャンセル"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("クリア"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final offlineManager = OfflineSubscriptionManager();
      await offlineManager.initialize();

      final success = await offlineManager.clearSavedData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? "データをクリアしました" : "データのクリアに失敗しました"),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  /// 強制オフラインテスト（Wi-Fiがない環境用）
  void _forceOfflineTest(BuildContext context) async {
    final offlineManager = OfflineSubscriptionManager();
    await offlineManager.initialize();

    // オフライン状態に設定
    final success = await offlineManager.forceOffline();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "オフライン状態に強制設定しました。" : "オフライン状態への強制設定に失敗しました。"),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }
}
