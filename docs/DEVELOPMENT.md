# 🛠 開発ガイド

このドキュメントでは、日本株ひとこと投資メモアプリの開発環境セットアップから開発方法まで説明します。

## 🛠 技術スタック

### フレームワーク・言語

- **Flutter**: クロスプラットフォーム開発フレームワーク
- **Dart**: プログラミング言語

### 主要なライブラリ・パッケージ

- **状態管理**: Provider パターンを使用
- **データベース**: SQLite（sqflite パッケージ）
- **国際化**: flutter_localizations, intl
- **広告**: Google Mobile Ads
- **設定保存**: SharedPreferences
- **環境変数**: flutter_dotenv
- **アプリ情報**: package_info_plus

## 🚀 クイックスタート

```bash
# リポジトリのクローン
git clone https://github.com/arafipro/jpstockminimemo.git
cd jpstockminimemo

# 依存関係のインストール
flutter pub get

# 開発サーバーの起動
flutter run
```

## 🔧 詳細な開発環境セットアップ

### 必要な環境

- Flutter SDK (>=2.18.2 <3.0.0)
- Dart SDK
- Android Studio または Xcode（各プラットフォーム向けビルド用）

### セットアップ手順

#### 1. リポジトリのクローン

```bash
git clone https://github.com/arafipro/jpstockminimemo.git
cd jpstockminimemo
```

#### 2. 依存関係のインストール

```bash
flutter pub get
```

#### 3. 環境変数の設定

```bash
# プロジェクトルートに .env ファイルを作成
touch .env
```

`.env` ファイルに以下の環境変数を設定してください：

```env
# Google Mobile Ads
ANDROID_AD_UNIT_ID=your_android_ad_unit_id
IOS_AD_UNIT_ID=your_ios_ad_unit_id
```

#### 4. アプリアイコンの生成

```bash
flutter pub run flutter_launcher_icons:main
```

#### 5. 開発サーバーの起動

```bash
flutter run
```

## 🧪 テスト

### 単体テストの実行

```bash
# 全テストの実行
flutter test

# 特定のテストファイルを実行
flutter test test/stock_code_validator_test.dart
```

### テストカバレッジの確認

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🔄 開発フロー

### ブランチ戦略

- `main`: 本番リリース用ブランチ
- `develop`: 開発用ブランチ
- `feature/*`: 機能開発用ブランチ

### コミット規約

```
feat: 新機能追加
fix: バグ修正
docs: ドキュメント更新
style: コードフォーマット
refactor: リファクタリング
test: テスト追加・修正
```

## 🛠 開発 Tips

### ホットリロード

開発中は `r` キーでホットリロード、`R` キーでホットリスタートを使用してください。

### デバッグ

```bash
# デバッグモードで実行
flutter run --debug

# プロファイルモードで実行
flutter run --profile
```

### 依存関係の更新

```bash
# 依存関係の更新確認
flutter pub outdated

# 依存関係の更新
flutter pub upgrade
```
