# 英単語学習アプリ (eng_vocab_app)

例文・発音・イメージ画像・意味のセットで単語を覚える、自分専用の単語帳アプリ。
詳細な仕様は [CLAUDE.md](./CLAUDE.md) を参照してください。

## 実装状況

CLAUDE.md記載のPhase 1〜5まで実装済み・Androidエミュレータで動作確認済みです。

- **Phase 1**: 手動追加 + フラッシュカード学習（表裏2段階・スワイプ判定）+ 進捗円グラフ
- **Phase 2**: 単語入力から意味・例文・類語・画像を自動生成（Free Dictionary API + DeepL + Unsplash）
- **Phase 3**: マーカースキャン（HSV色検出 + Google ML Kit OCR）による単語一括登録
- **Phase 4**: 学習記録ヒートマップカレンダー（月間合計時間・連続学習日数）
- **Phase 5**: Firebase（Google認証 + Firestore）によるクラウド同期

iOS対応は未着手（macOS環境が必要なため）。

## 技術構成

- Flutter / Dart, 状態管理: Riverpod
- ローカルDB: drift (SQLite)
- クラウド: Firebase Authentication (Google Sign-In) + Cloud Firestore
- 外部API: Free Dictionary API, DeepL API, Unsplash API
- OCR: Google ML Kit Text Recognition
- PDF処理: pdfx

## セットアップ

### 1. 前提ツール

- Flutter SDK（[公式手順](https://docs.flutter.dev/get-started/install)）
- Android実機/エミュレータで動かす場合はAndroid Studio + Android SDK
- iOSで動かす場合はmacOS + Xcode（現時点で未対応）

### 2. リポジトリの取得

```bash
git clone https://github.com/naoto0307/eng-vocab-app.git
cd eng-vocab-app
flutter pub get
```

### 3. APIキーの設定

`.env`はGit管理外（`.gitignore`済み）のため、`.env.example`を参考に手動で作成してください。

```bash
cp .env.example .env
```

`.env`の中身:

```
DEEPL_API_KEY=（DeepLで取得したキー）
UNSPLASH_ACCESS_KEY=（Unsplashで取得したキー）
```

- DeepL: https://www.deepl.com/ja/pro-api （Developerプラン=無料、100万文字まで）
- Unsplash: https://unsplash.com/developers

### 4. Firebase設定ファイル

Android用の`android/app/google-services.json`と`lib/firebase_options.dart`はリポジトリに含まれているためそのまま使えます。別のFirebaseプロジェクトに切り替える場合は [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup) で再生成してください。

### 5. 起動

```bash
flutter run
```

## テスト

```bash
flutter analyze
flutter test
```

## ディレクトリ構成（feature-first）

```
lib/
  core/         # DB, 設定, 認証, 同期, 外部API, OCR/画像処理などの共通基盤
  features/     # 画面ごとの機能単位（home, word, study, scan, record, settings, auth）
```

## 開発メモ

Windows環境でのビルド時の注意点や過去に発生した問題の対処法は、開発時のセッション記録に残っています。詰まった場合はまず`flutter clean && flutter pub get`を試してください。
