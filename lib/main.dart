import "package:jpstockminimemo/constants/imports.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // .envを読み込めるように設定.
  await dotenv.load(fileName: ".env");

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsModel>(
          // 全ての設定値を取得
          create: (_) => SettingsModel()..getAllSettings(),
        ),
        Provider<RevenueCatService>(
          create: (_) {
            final service = RevenueCatService();
            // 非同期で初期化を開始
            service.initialize();
            return service;
          },
        ),
      ],
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
