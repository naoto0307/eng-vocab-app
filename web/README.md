# 英単語帳 Web版

英単語学習アプリのWeb版（React + Vite + TypeScript）。詳細な仕様はリポジトリルートの [CLAUDE.md](../CLAUDE.md) を参照してください。

Web版を先に完成させ、そのあとモバイル版（Flutter, リポジトリルートの `lib/`）を実装する方針で開発しています。デザインは `/design` スキルで作成したデザイン案（複数ラウンドのレビュー・修正を経たもの）に忠実に実装しています。

## 実装状況

- ホーム（進捗ドーナツグラフ、統計、最近追加した単語、「今日の一周」ナッジ）
- 単語帳一覧（検索・ステータスフィルタ、空状態）
- 単語詳細・編集（ステータス変更、削除、未保存離脱の確認モーダル）
- 単語追加（手動入力・自動生成プレビュー）
- 学習範囲選択（間違えた単語のみ／期間／タグのAND絞り込み）
- フラッシュカード学習（表裏切替、キーボードショートカット `←`/`→`/`Space`、undo、2段階削除確認、セッション終了サマリー）
- 学習記録（月表示ヒートマップカレンダー、連続学習日数）
- 設定（判定方向反転など）

マーカースキャン（OCR）・DeepL翻訳・Unsplash画像・クラウド同期はAPIキーや追加インフラが必要なため未実装です。単語の自動生成は [Free Dictionary API](https://dictionaryapi.dev/)（無料・キー不要）による英語の定義・例文・類語の取得のみ対応しています。

## 技術構成

- React 19 / TypeScript / Vite
- ローカルDB: Dexie（IndexedDB） — `Word` / `StudySession` / `StudyLog` はCLAUDE.mdのスキーマに準拠
- ルーティング: react-router-dom
- スタイル: 素のCSS（`src/styles/`）。oklchカラートークンとライト/ダーク対応はデザイン案からそのまま移植

## セットアップ

```bash
cd web
npm install
npm run dev
```

## ビルド・テスト

```bash
npm run build   # 型チェック + 本番ビルド
npm run lint    # oxlint
node smoke-test.mjs  # Playwrightでの一連の画面遷移スモークテスト（要 npx playwright install 相当のChromiumバイナリ）
```
