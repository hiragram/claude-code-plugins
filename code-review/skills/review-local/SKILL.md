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
/review-local [base-branch | #PR番号]
```

### 例

```
/review-local           # 現在ブランチ vs main をレビュー
/review-local develop   # 現在ブランチ vs develop をレビュー
/review-local #123      # PR #123 の差分をレビュー（fetch して取得）
```

## 実行手順

### Step 1: 引数の解析

`$ARGUMENTS` を解析して対象を決定します:
- `#数字` の場合: PR番号として扱い、PRのブランチ情報を取得
- ブランチ名の場合: そのブランチをベースとして使用
- 引数なしの場合: `main` をベースとして使用

### Step 2: オーケストレーターエージェントの起動

`review-local-orchestrator` エージェントを Task ツールで起動します。

```
Task tool の呼び出し:
- subagent_type: code-review:review-local-orchestrator
- prompt: "対象: '[引数]'（ベースブランチまたはPR番号）のレビューを実行してください。"
- run_in_background: false（結果を待つ場合）または true（バックグラウンド実行の場合）
```

### Step 3: 結果の出力

オーケストレーターエージェントから返却された結果をそのまま出力します。

## 関連ドキュメント

各レビュー観点の詳細は以下を参照:

- [コード品質レビュー観点](../review-pr/references/code-quality.md)
- [パフォーマンスレビュー観点](../review-pr/references/performance.md)
- [テストカバレッジレビュー観点](../review-pr/references/test-coverage.md)
- [ドキュメント正確性レビュー観点](../review-pr/references/documentation.md)
- [セキュリティレビュー観点](../review-pr/references/security.md)
