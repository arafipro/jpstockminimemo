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
