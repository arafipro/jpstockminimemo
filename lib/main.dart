import "package:jpstockminimemo/constants/imports.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // .envを読み込めるように設定.
  await dotenv.load(fileName: ".env");

  // RevenueCat の初期化
  await _initializeRevenueCat();

  runApp(
    const MyApp(),
  );
}

/// RevenueCat の初期化処理
Future<void> _initializeRevenueCat() async {
  try {
    await RevenueCatService().initialize();
    debugPrint("RevenueCat initialization completed in main.dart");
  } catch (e) {
    debugPrint("Error initializing RevenueCat in main.dart: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsModel>(
      // 全ての設定値を取得
      create: (_) => SettingsModel()..getAllSettings(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        // Delegate には、flutter_localizations 標準のものだけを設定
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("ja", "JP"), // Japanese
        ],
        home: AppStartup(),
      ),
    );
  }
}
