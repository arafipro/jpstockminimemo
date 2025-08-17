import "package:jpstockminimemo/constants/imports.dart";

class ListPage extends StatelessWidget {
  const ListPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    const bool isButtonMode = true;
    return ChangeNotifierProvider<ListModel>(
      create: (_) => ListModel()..fetchMemos(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          automaticallyImplyLeading: false, // 戻るボタンを表示しない
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.white,
              onPressed: () async {
                // 画面遷移の動きを変更
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                    ) {
                      return const SettingsPage();
                    },
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      const Offset begin = Offset(1.0, 0.0); // 右から左
                      // final Offset begin = Offset(-1.0, 0.0); // 左から右
                      const Offset end = Offset.zero;
                      final Animatable<Offset> tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(
                        CurveTween(curve: Curves.easeInOut),
                      );
                      final Animation<Offset> offsetAnimation =
                          animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          ],
          title: const Text(
            appName,
            style: titleTextStyle20,
          ),
        ),
        body: Column(
          children: [
            // 課金状態に応じた広告表示制御
            Consumer<RevenueCatService>(
              builder: (context, revenueCatService, child) {
                return StreamBuilder<SubscriptionStatus>(
                  stream: revenueCatService.statusStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final status = snapshot.data!;
                      // プレミアムユーザーは広告を非表示
                      if (status.isPremium) {
                        return const SizedBox.shrink();
                      }
                      // 非プレミアムユーザーは広告を表示
                      return AdBanner();
                    }
                    // ローディング中は広告を表示
                    return AdBanner();
                  },
                );
              },
            ),
            // 課金状態表示（ローディング中は非表示）
            Consumer<RevenueCatService>(
              builder: (context, revenueCatService, child) {
                return StreamBuilder<SubscriptionStatus>(
                  stream: revenueCatService.statusStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return const SubscriptionStatusDisplay();
                    }
                    // ローディング中は非表示
                    return const SizedBox.shrink();
                  },
                );
              },
            ),
            Expanded(
              child: Consumer<ListModel>(
                builder: (
                  BuildContext context,
                  ListModel model,
                  Widget? child,
                ) {
                  final stockmemos = model.stockmemos;
                  final stockcards = stockmemos
                      .map(
                        (stockcard) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          child: StockCard(
                            isButtonMode: isButtonMode,
                            stockname: stockcard.name,
                            code: stockcard.code,
                            market: stockcard.market,
                            memo: stockcard.memo,
                            createdAt: stockcard.createdAt,
                            updatedAt: stockcard.updatedAt,
                            onDeleteChanged: () async {
                              await showDialog(
                                context: context,
                                builder: (
                                  BuildContext context,
                                ) {
                                  return CustomAlertDialog(
                                    title: "${stockcard.name}を削除しますか？",
                                    buttonText: "OK",
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await model.deleteMemo(stockcard);
                                      await model.fetchMemos();
                                    },
                                  );
                                },
                              );
                            },
                            onEditChanged: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPage(
                                    stockmemo: stockcard,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toList();
                  return ListView(
                    key: GlobalKey(),
                    children: stockcards,
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: buttonColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (
                  context,
                ) =>
                    EditPage(
                  stockmemo: null,
                ),
                fullscreenDialog: true,
              ),
            );
          },
          label: const Text(
            "新規登録",
            style: titleTextStyle16,
          ),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
