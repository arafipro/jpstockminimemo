# 🚀 ビルド・デプロイ

このドキュメントでは、日本株ひとこと投資メモアプリのビルドからデプロイまでの手順を説明します。

## 📦 ビルド手順

### iOS 版

#### 前提条件

- macOS 環境
- Xcode がインストール済み
- iOS Developer Program に登録済み

#### ビルドコマンド

```bash
flutter build ipa --release --obfuscate \
    --split-debug-info=build/app/outputs/symbols \
    --export-options-plist=ios/ExportOptions.plist
```

#### 詳細手順

1. **証明書の設定**

   - Xcode で iOS/Runner.xcworkspace を開く
   - Signing & Capabilities で証明書を設定

2. **ビルド設定の確認**

   - Build Settings で Release 設定を確認
   - Bundle Identifier が正しく設定されているか確認

3. **Archive の作成**
   ```bash
   # Archive 作成
   flutter build ipa --release
   ```

### Android 版

#### APK ファイルの生成

```bash
flutter build apk --release --obfuscate \
    --split-debug-info=build/app/outputs/symbols
```

#### App Bundle（推奨）の生成

```bash
flutter build appbundle --release --obfuscate \
    --split-debug-info=build/app/outputs/symbols
```

#### 詳細手順

1. **キーストアの作成**

   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks \
   -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **key.properties の設定**

   ```
   storePassword=your_store_password
   keyPassword=your_key_password
   keyAlias=upload
   storeFile=/path/to/upload-keystore.jks
   ```

3. **ビルド実行**
   ```bash
   flutter build appbundle --release
   ```

## 🎯 リリース準備

### バージョン管理

`pubspec.yaml` でバージョンを更新：

```yaml
version: 1.1.4+1
```

### 難読化オプション

リリースビルドでは必ず難読化を有効にしてください：

```bash
--obfuscate --split-debug-info=build/app/outputs/symbols
```

### 環境変数の確認

本番用の環境変数が正しく設定されているか確認：

- 広告 ID（本番用）
- その他の API キー

## 📱 ストア申請

### Google Play Store（Android）

1. **Google Play Console** にアクセス
2. アプリを作成または選択
3. **リリース管理** → **アプリリリース**
4. **内部テスト** または **本番** を選択
5. App Bundle（.aab）ファイルをアップロード
6. リリースノートを入力
7. **確認** → **リリース開始**

### App Store（iOS）

1. **App Store Connect** にアクセス
2. アプリを作成または選択
3. **TestFlight** でベータテスト（任意）
4. **App Store** タブでリリース準備
5. IPA ファイルをアップロード
6. アプリ情報、スクリーンショットを設定
7. **審査へ提出**

## 🔧 トラブルシューティング

### ビルドエラーの対処

1. **キャッシュのクリア**

   ```bash
   flutter clean
   flutter pub get
   ```

2. **iOS ビルドエラー**

   ```bash
   # Pods の再インストール
   cd ios
   rm -rf Pods Podfile.lock
   pod install
   ```

3. **Android ビルドエラー**
   ```bash
   # Gradle キャッシュのクリア
   cd android
   ./gradlew clean
   ```

### よくある問題

- **証明書エラー**: Xcode で証明書を再設定
- **キーストア エラー**: key.properties のパスを確認
- **依存関係エラー**: `flutter pub get` を再実行
