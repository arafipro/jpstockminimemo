## プロジェクト概要

- リポジトリ名: **jpstockminimemo**
- アプリ名: **日本株ひとこと投資メモ** (Flutter 製)
- 目的: 日本株の銘柄ごとに短いメモを残し、一覧管理できるモバイルアプリ。

## 技術スタック

| 項目           | 使用技術                                         |
| -------------- | ------------------------------------------------ |
| フレームワーク | Flutter (Dart)                                   |
| 状態管理       | Provider パターン (lib/viewmodels)               |
| データベース   | sqflite + PathProvider (lib/utils/dbhelper.dart) |
| 広告           | Google Mobile Ads                                |
| Linter         | flutter_lints (prefer_double_quotes 等)          |

## ディレクトリ指針

- `lib/` : アプリ本体のソースディレクトリ
  - `components/` : 再利用可能 UI ウィジェット（例: 広告バナー、共通カード）
  - `constants/` : カラー・テキストスタイル・インポート集など定数管理
  - `models/` : DB 永続化対象モデルクラス（例: `StockMemo`）
  - `utils/` : 汎用ヘルパー（DB アクセス `dbhelper.dart` など）
  - `viewmodels/` : MVVM の ViewModel 層（`ChangeNotifier`）
  - `views/` : 画面ウィジェット (`list_page.dart` など)
  - `main.dart` : アプリのエントリーポイント

## コーディングガイドライン

1. **日本語ドキュメント必須** – コメント／README は日本語で統一。
2. **命名規則** – Dart の標準 (lowerCamelCase / UpperCamelCase)。
3. **ダブルクォート推奨** – `analysis_options.yaml` に従い `prefer_double_quotes` を守る。
4. **State を最小化** – viewmodel にビジネスロジックを集約し、Widget は薄く保つ。
5. **非同期処理** – `async/await` を使い、エラーハンドリングは try-catch でユーザ通知。

## 開発ログ運用

- **コミットメッセージ規約** : Conventional Commits を採用 (`feat:`, `fix:`, `docs:` 等)。
- **Pull Request テンプレ** : 背景 / 変更内容 / 影響範囲 / 動作確認 / 関連 Issue を記載。
- **CHANGELOG.md** : リリースごとに追加。`## [1.2.0] - 2025-06-30` のように日付付きヘッダで差分要約。
- **Issue** : 機能追加は `enhancement`、不具合は `bug` ラベルを必ず付与。
- **タグ & リリース** : `vX.Y.Z` 形式の Git タグを push し、GitHub Releases を生成。
- **ドキュメント更新** : 実装変更時は README や `docs/` を同一 PR で更新。

これらに沿って履歴を残すことで、Gemini が変更経緯を理解しやすくなり、質問回答やコード生成時に最新仕様を考慮できます。

## Gemini へのインストラクション

- 本プロジェクトに関する回答・コード例は **すべて日本語** で行うこと。
- 回答は **簡潔かつ段階的 (箇条書き推奨)** にまとめること。
- Flutter / Dart のベストプラクティスを優先し、可能な限り lint エラーを出さないコードを示すこと。
- 未確定情報は推測せず、追加確認が必要な場合は質問を返すこと。

## 参考リンク

- Flutter 公式: <https://docs.flutter.dev/>
- Provider パターン: <https://pub.dev/packages/provider>
- sqflite: <https://pub.dev/packages/sqflite>
