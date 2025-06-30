# 🔧 トラブルシューティング

このドキュメントでは、日本株ひとこと投資メモアプリでよくある問題と解決方法を説明します。

## 🚨 よくある問題と解決方法

### 1. ビルドエラー

#### 問題: `flutter build` でエラーが発生する

**解決方法:**

```bash
# キャッシュをクリア
flutter clean
flutter pub get

# 依存関係を再インストール
flutter packages get
```

#### 問題: iOS ビルドでエラーが発生する

**解決方法:**

```bash
# Pods の再インストール
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter build ios
```

#### 問題: Android ビルドでエラーが発生する

**解決方法:**

```bash
# Gradle キャッシュをクリア
cd android
./gradlew clean
cd ..
flutter build apk
```

### 2. 広告関連の問題

#### 問題: 広告が表示されない

**確認事項:**

1. `.env` ファイルが正しく設定されているか
2. 広告 ID が本番用 ID になっているか（テスト用 ID ではないか）
3. Google Mobile Ads SDK の設定が正しいか

**解決方法:**

```bash
# .env ファイルの確認
cat .env

# 環境変数の例
ANDROID_AD_UNIT_ID=ca-app-pub-xxxxxxxxxx/xxxxxxxxxx
IOS_AD_UNIT_ID=ca-app-pub-xxxxxxxxxx/xxxxxxxxxx
```

#### 問題: テスト広告が表示されない

**解決方法:**

- テスト用デバイス ID を設定
- Google Mobile Ads の初期化を確認
- アプリの再起動

### 3. データベース関連の問題

#### 問題: データが保存されない

**解決方法:**

1. アプリの完全再起動
2. デバイスの再起動
3. アプリの再インストール

#### 問題: アプリがクラッシュする

**解決方法:**

```bash
# デバッグログの確認
flutter logs

# クラッシュ情報の確認
adb logcat  # Android の場合
```

#### 問題: データベースマイグレーションエラー

**解決方法:**

- アプリを完全にアンインストール
- 再インストールしてデータベースを初期化

### 4. 開発環境の問題

#### 問題: Flutter Doctor でエラーが表示される

**解決方法:**

```bash
# Flutter の状態確認
flutter doctor -v

# よくある解決方法
# - Android SDK のパスを設定
# - Xcode のコマンドラインツールをインストール
# - Android ライセンスに同意
flutter doctor --android-licenses
```

#### 問題: 依存関係の競合エラー

**解決方法:**

```bash
# 依存関係の確認
flutter pub deps

# pubspec.yaml の dependency_overrides を確認
# 必要に応じて特定バージョンを指定
```

### 5. デバイス固有の問題

#### 問題: iOS シミュレーターで動作しない

**解決方法:**

```bash
# iOS シミュレーターのリセット
xcrun simctl erase all

# 新しいシミュレーターを作成
xcrun simctl create "iPhone 14" iPhone-14
```

#### 問題: Android エミュレーターで動作しない

**解決方法:**

- AVD Manager で新しいエミュレーターを作成
- Hardware Acceleration を有効にする
- 十分なメモリとストレージを割り当て

### 6. パフォーマンスの問題

#### 問題: アプリの動作が重い

**解決方法:**

1. **プロファイルモードで実行**

   ```bash
   flutter run --profile
   ```

2. **メモリリークの確認**

   ```bash
   flutter run --profile --track-widget-creation
   ```

3. **不要なウィジェットのリビルドを避ける**
   - const コンストラクタを使用
   - Consumer の範囲を最小限にする

#### 問題: ビルドが遅い

**解決方法:**

```bash
# 並列ビルドを有効にする
flutter build apk --split-per-abi

# Gradle デーモンを有効にする（Android）
echo "org.gradle.daemon=true" >> android/gradle.properties
```

## 🛠 デバッグ方法

### ログの確認

#### Flutter ログ

```bash
flutter logs
```

#### Android ログ

```bash
adb logcat | grep flutter
```

#### iOS ログ

```bash
# Xcode の Console アプリを使用
# または以下のコマンド
xcrun simctl spawn booted log stream --predicate 'category CONTAINS "flutter"'
```

### デバッグツールの使用

#### Flutter Inspector

```bash
flutter run
# ブラウザでデバッグページを開く
```

#### Performance View

- Flutter DevTools を使用
- パフォーマンスの問題を特定

## 📞 サポート

### 自己解決できない場合

1. **GitHub Issues**

   - バグ報告や機能要求を投稿
   - 詳細な情報（エラーメッセージ、環境情報など）を含める

2. **Stack Overflow**

   - Flutter タグで質問
   - コミュニティからの回答を期待

3. **公式ドキュメント**
   - [Flutter 公式ドキュメント](https://flutter.dev/docs)
   - [Dart 公式ドキュメント](https://dart.dev/guides)

### バグ報告時の情報

以下の情報を含めてください：

- Flutter バージョン（`flutter --version`）
- 使用デバイス・OS
- エラーメッセージの全文
- 再現手順
- 期待する動作と実際の動作
