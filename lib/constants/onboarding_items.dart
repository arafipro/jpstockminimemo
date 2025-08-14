import "package:jpstockminimemo/constants/imports.dart";

final List<OnboardingItem> items = [
  OnboardingItem(
    title: "日本株投資を簡単管理",
    description: "証券コードと銘柄名を登録して、投資の理由や戦略をメモできます",
    icon: Icons.trending_up,
    color: Colors.blue,
  ),
  OnboardingItem(
    title: "オフラインで動作",
    description: "インターネット接続不要で、いつでもメモの確認・編集が可能です",
    icon: Icons.offline_bolt,
    color: Colors.green,
  ),
  OnboardingItem(
    title: "東証市場再編対応",
    description: "プライム・スタンダード・グロース市場の新しい証券コード体系に対応",
    icon: Icons.newspaper,
    color: Colors.orange,
  ),
  OnboardingItem(
    title: "シンプルで使いやすい",
    description: "直感的な操作で、投資メモを効率的に管理できます",
    icon: Icons.thumb_up,
    color: Colors.purple,
  ),
];
