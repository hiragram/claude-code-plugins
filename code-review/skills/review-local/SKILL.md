---
name: review-local
description: ローカルの未コミット変更を含むmainブランチとの差分、またはPRの差分を5つの観点からレビューする。コミット前のコードチェックやPRレビューに使用。
user-invocable: true
---

# ローカルレビュースキル

mainブランチとの差分（未コミット変更含む）、またはPR番号を指定してその差分を、5つの専門エージェントでファイル単位に並列レビューし、Markdownレポートを出力します。

## 概要

このスキルは以下の5つの観点でコードをレビューします:

1. **コード品質** - クリーンコード、命名規則、エラーハンドリング
2. **パフォーマンス** - アルゴリズム複雑度、メモリ管理、N+1問題
3. **テストカバレッジ** - テストの有無、エッジケース、境界値テスト
4. **ドキュメント正確性** - コメントとコードの整合性、API文書
5. **セキュリティ** - OWASP Top 10、入力検証、認証認可

## 使い方

```
/review-local [base-branch | #PR番号] [追加の指示]
```

### 例

```
/review-local                            # レビュー → 指摘があれば修正 → 再レビュー案内
/review-local develop                    # develop との差分をレビュー → 修正対応
/review-local #123                       # PR #123 の差分をレビュー → 修正対応
/review-local 開いて                      # レビュー後にVSCodeでレポートを開く（修正は手動）
/review-local develop 終わったら開いて    # develop との差分をレビューし、VSCodeで開く
```

### 動作モード

| 引数 | 動作 |
|-----|------|
| なし / ブランチ名 / PR番号のみ | レビュー → 自動修正 → 再レビュー案内 |
| 「開いて」「open」等を含む | レビュー → VSCodeでレポートを開く |

## 実行手順

### Step 1: 情報収集

1. **プロジェクトルールの読み込み**
   - CLAUDE.mdがあれば読み込み、プロジェクト固有のルールを把握

2. **対象の判定と差分情報の取得**

   `$ARGUMENTS` を解析して対象を決定:

   **PR番号の場合**（`#数字` 形式）:
   ```bash
   # PRのブランチ情報を取得
   gh pr view [番号] --json baseRefName,headRefName

   # 両ブランチをfetch
   git fetch origin [headRefName] [baseRefName]
   ```
   - `base_ref` = `origin/[baseRefName]`
   - `head_ref` = `origin/[headRefName]`

   **ブランチ名または指定なしの場合**:
   - `base_ref` = 指定されたブランチ名、または `main`
   - `head_ref` = なし（ワーキングツリーとの比較）

3. **変更ファイル一覧の取得**
   ```bash
   # head_ref がある場合（PR）
   git diff --name-only [base_ref] [head_ref]

   # head_ref がない場合（ローカル）
   git diff --name-only [base_ref]
   ```

### Step 2: サブエージェントの並列起動

変更ファイル一覧の各ファイルに対して、以下の5つのエージェントを **`run_in_background: true` で非同期起動** します。

つまり、変更ファイルがN個あれば、N×5個のサブエージェントを一斉にバックグラウンドで起動します。

| エージェント | 役割 |
|-------------|------|
| `code-review:code-quality-reviewer` | コード品質・可読性・エラーハンドリング |
| `code-review:performance-reviewer` | パフォーマンス・メモリ管理・アルゴリズム |
| `code-review:test-coverage-reviewer` | テストカバレッジ・テスト品質 |
| `code-review:documentation-accuracy-reviewer` | ドキュメント・コメントの正確性 |
| `code-review:security-code-reviewer` | セキュリティ脆弱性・認証認可 |

各エージェントには以下を渡します:
- `base_ref`: 比較元（ブランチ名 or `origin/xxx`）
- `head_ref`: 比較先（省略時はワーキングツリー、PR時は `origin/xxx`）
- `file_path`: レビュー対象のファイルパス
- プロジェクトルール（CLAUDE.mdの内容、あれば）

**重要: 各エージェントへの指示に以下を含めてください:**

> **diff取得**: `git diff [base_ref] [head_ref] -- [file_path]` を実行し、対象ファイルのdiffを取得してください。head_refが省略されている場合は `git diff [base_ref] -- [file_path]` を使用してください。
>
> **深掘りレビュー**: 単にdiffを見るだけでなく、変更箇所に関連する他のクラスやモジュールの実装も Read/Grep で確認し、整合性やインターフェース違反がないかチェックしてください。必要に応じて `git log --oneline -10 -- [file_path]` で過去の変更履歴も参照し、退行や意図の逸脱がないか確認してください。
>
> **出力形式**: GitHub APIは使用しないでください。指摘内容を以下のMarkdown形式で返却してください。
>
> ```markdown
> ### [ファイル名]:[行番号]
> **問題**: [問題の説明]
>
> **影響**: [潜在的な影響]
>
> **提案**:
> ```suggestion
> [修正コード]
> ```
> ```
>
> 指摘がない場合は「（指摘なし）」と返却してください。

### Step 3: 結果の集約

全バックグラウンドエージェントの `output_file` を `Read` ツールで読み取り、完了を確認します。

ファイル×観点の結果を、**観点ごとにグルーピング**して集約します。

### Step 4: レポート保存と後続アクション

集約したMarkdownレポートを以下の手順で出力します:

1. レポートをファイルに保存:
   ```bash
   # タイムスタンプ付きファイル名で /tmp に保存
   # 例: /tmp/review-local-20260128-143022.md
   ```

2. 後続アクションの分岐:

   **`$ARGUMENTS` に「開いて」「open」などVSCodeで開く指示がある場合:**
   ```bash
   code /tmp/review-local-YYYYMMDD-HHmmss.md
   ```

   **それ以外（引数なし、またはブランチ/PR指定のみ）の場合:**
   - レポートファイルを読み込み、指摘内容を確認
   - 指摘があれば、該当ファイルを修正
   - 修正完了後、再度 `/review-local` を実行してレビューを受けるようユーザーに案内
   - 指摘がなければ「指摘事項なし」と報告して完了

## 出力形式

```markdown
# ローカルレビュー結果

対象: [base-branch / PR #番号] との差分
変更ファイル数: X件

---

## 🔍 コード品質

[code-quality-reviewerの結果をファイルごとに集約]

---

## ⚡ パフォーマンス

[performance-reviewerの結果をファイルごとに集約]

---

## 🧪 テストカバレッジ

[test-coverage-reviewerの結果をファイルごとに集約]

---

## 📚 ドキュメント

[documentation-accuracy-reviewerの結果をファイルごとに集約]

---

## 🔒 セキュリティ

[security-code-reviewerの結果をファイルごとに集約]

---

## サマリー

| 観点 | 指摘数 |
|-----|-------|
| コード品質 | X件 |
| パフォーマンス | X件 |
| テストカバレッジ | X件 |
| ドキュメント | X件 |
| セキュリティ | X件 |
| **合計** | **X件** |
```

## 注意事項

- **注目すべき問題のみ指摘**: 軽微な問題や好みの問題は指摘しません
- **具体的な改善案**: 可能な限り修正コードを提供
- **プロジェクトルール尊重**: CLAUDE.mdで定義されたルールに従います
- **ローカル実行専用**: GitHub APIは使用しません
- **深掘りレビュー**: diffだけでなく関連コードや過去の変更履歴も参照して深いレビューを行います

## 関連ドキュメント

各レビュー観点の詳細は以下を参照:

- [コード品質レビュー観点](../review-pr/references/code-quality.md)
- [パフォーマンスレビュー観点](../review-pr/references/performance.md)
- [テストカバレッジレビュー観点](../review-pr/references/test-coverage.md)
- [ドキュメント正確性レビュー観点](../review-pr/references/documentation.md)
- [セキュリティレビュー観点](../review-pr/references/security.md)
