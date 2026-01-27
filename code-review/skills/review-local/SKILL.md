---
name: review-local
description: ローカルの未コミット変更を含むmainブランチとの差分を5つの観点からレビューする。コミット前のコードチェックに使用。
user-invocable: true
---

# ローカルレビュースキル

mainブランチとの差分（未コミット変更含む）を5つの専門エージェントで並列レビューし、Markdown形式で指摘を出力します。

## 概要

このスキルは以下の5つの観点でコードをレビューします:

1. **コード品質** - クリーンコード、命名規則、エラーハンドリング
2. **パフォーマンス** - アルゴリズム複雑度、メモリ管理、N+1問題
3. **テストカバレッジ** - テストの有無、エッジケース、境界値テスト
4. **ドキュメント正確性** - コメントとコードの整合性、API文書
5. **セキュリティ** - OWASP Top 10、入力検証、認証認可

## 使い方

```
/review-local [base-branch]
```

### 例

```
/review-local           # mainブランチとの差分をレビュー
/review-local develop   # developブランチとの差分をレビュー
```

## 実行手順

### Step 1: 引数の解析

`$ARGUMENTS` を解析してベースブランチを決定します:
- 引数があれば、その値をベースブランチとして使用
- 引数がなければ `main` を使用

### Step 2: オーケストレーターエージェントの起動

`review-local-orchestrator` エージェントを Task ツールで起動します。

```
Task tool の呼び出し:
- subagent_type: code-review:review-local-orchestrator
- prompt: "ベースブランチ '[base-branch]' との差分をレビューしてください。"
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
