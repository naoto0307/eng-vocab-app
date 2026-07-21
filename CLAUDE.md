# 英単語学習アプリ（プロジェクト指示書）

## コンセプト
単語を「例文・発音・イメージ画像・意味」のセットで覚える、自分専用の単語帳アプリ。
「金のフレーズ」のような高速周回学習を目指す。

## 技術構成
- プラットフォーム: Flutter（iOS/Android両対応）
- ローカルDB: SQLite（drift または sqflite）
- 発音（TTS）: flutter_tts（単語・例文どちらも読み上げ、無料・APIキー不要）
- 意味・例文・類語・語源生成: Free Dictionary API + DeepL API（無料枠）
- 画像取得: Unsplash API（無料枠）
- OCR: Google ML Kit Text Recognition（オンデバイス・無料）
- PDF処理: pdfx（PDFをページ単位で画像化）
- グラフ表示: fl_chart
- 将来のクラウド同期: Firebase（Firestore + Authentication、無料枠）※MVPでは未実装

## データモデル

### Word（単語）
| フィールド | 型 | 備考 |
|---|---|---|
| id | string | PK |
| word | string | UNIQUE制約（正規化: 大小文字統一・前後スペース除去） |
| meaning | string | 日本語訳 |
| example_en | string | 例文（英語） |
| example_ja | string | 例文の日本語訳 |
| synonyms | string[] | 類語 |
| etymology | string | 語源・豆知識（任意） |
| audio_word_url | string? | 発音音声（TTS都度生成の場合は不要） |
| audio_example_url | string? | 例文音読音声 |
| image_url | string | イメージ画像 |
| tags | string[] | タグ（複数可） |
| created_at | datetime | 追加日時 |
| source | enum | `manual` / `marker_scan` |
| status | enum | `remembered` / `not_yet` / `unstudied` / `pending_review` |

### StudyLog（学習ログ）
| フィールド | 型 | 備考 |
|---|---|---|
| id | string | PK |
| word_id | string | FK -> Word |
| studied_at | datetime | 学習日時 |
| result | enum | `remembered` / `not_yet` |
| session_id | string | FK -> StudySession |

### StudySession（学習セッション）
| フィールド | 型 | 備考 |
|---|---|---|
| id | string | PK |
| started_at | datetime | |
| ended_at | datetime | |
| word_count | int | 学習単語数 |
| accuracy | float | 正答率 |

## 主要機能仕様

### 単語追加
1. **手動入力**: 単語を入力 → 意味・例文・発音・イラスト・類語・語源を自動生成 → プレビュー確認 → 保存
2. **マーカースキャン**: PDF/画像 → マーカー領域検出（HSV色検出） → OCR（ML Kit） → 候補内重複を集約 → 辞書照合で不完全読み取りを検知（`pending_review`扱い） → 既存単語帳との重複チェック → 設定に応じてプレビュー表示 or 即登録
3. 重複判定は正規化した完全一致（大小文字無視）。原形化（lemmatization）は将来拡張。

### 学習画面（フラッシュカード）
- **判定前（表面）**: 例文のみ表示、対象単語を色分け強調。例文の音読ボタン常時表示。イラスト・意味は非表示。
- **判定後（裏面）**: 画像、例文（英語・強調表示維持）+ 日本語訳、単語の意味、類語、語源、単語発音+例文音読ボタン、削除ボタン。
- **操作**:
  - タップ = 表面→裏面の表示切替（判定はしない）
  - スワイプ（表面・裏面どちらでも可） = 判定確定 + 次のカードへ（右=覚えた、左=まだ、設定で反転可）
  - 誤スワイプ防止のしきい値あり、直前の判定を戻す機能あり
- `pending_review` の単語は学習画面に一切出現させない（クエリで除外）。

### 進捗・学習記録
- ホーム画面: 円グラフ（覚えた/まだ/未学習）+ 覚えた単語数/総単語数 + 覚えた割合(%)
- 学習記録画面: 月表示ヒートマップカレンダー。各マスに学習時間を `◯min` で表示、色の濃淡も学習時間に連動。
- サマリー表記ルール: カレンダー内の日別時間 = `min`、月間合計時間 = `◯h◯min`、連続学習日数 = `◯days`

### 学習範囲選択
- 間違えた単語のみ / 追加期間指定 / タグ指定 / これらのAND組み合わせ
- `pending_review` は常に除外

## 画面一覧
1. ホーム画面
2. 単語追加方法選択画面
3. 単語追加：手動入力画面
4. 単語追加：スキャン画面
5. 単語帳一覧画面
6. 学習範囲選択画面
7. 学習画面（フラッシュカード）
8. 学習記録画面
9. 単語詳細・編集画面
10. 設定画面（スキャン確認スキップON/OFF、スワイプ方向反転）

## 開発フェーズ（MVP方針）
- フェーズ1: 手動追加 + フラッシュカード（判定前後2段階、スワイプ判定）+ 進捗円グラフ
- フェーズ2: 自動生成連携（意味・例文・類語・語源・画像・発音）
- フェーズ3: マーカースキャン機能（OCR・色検出・重複/要確認処理）
- フェーズ4: 学習記録・時間管理の可視化強化
- フェーズ5（リリース後）: Firebase連携によるクラウド同期

## コーディング規約（適宜追記）
- 状態管理: （未定 - Riverpod / Provider などお好みで指定してください）
- ディレクトリ構成: （未定 - feature-first を推奨）
- テスト方針: （未定）