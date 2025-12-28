---
description: 話題を視覚的な関係図にまとめる
---

# Visualize コマンド

ユーザーから指定された話題について、要素間の関係性が視覚的にわかるグラフィックレコーディング風の画像を生成します。

**目指すスタイル**: 箇条書きの羅列ではなく、マインドマップ＋フローチャートのハイブリッド。要素が空間的に配置され、矢印や線で関係性が示されている図。

## 入力

$ARGUMENTS

## 手順

### 1. 入力の解析

$ARGUMENTS の内容を解析し、以下のパターンを判別してください：

- **直接指示**: トピックが直接テキストで指定されている場合
- **URL参照**: Webページへの参照がある場合
  - WebFetch で内容を取得
  - **重要**: 「要約して」ではなく「全セクション・全項目を構造化してリストアップして」と指示
- **Issue/PR参照**: GitHub Issue や PR への参照がある場合
  - `gh` コマンドで内容を取得
- **コードベース参照**: コードや設計について説明を求められている場合
  - 必要に応じてコードを探索

### 2. 情報の構造分析（最重要ステップ）

単なるリストアップではなく、**要素間の関係性**を分析してください：

#### a) 要素の抽出
- 主要な概念・トピックをすべて抽出
- それぞれに短いラベル（2〜5語）をつける

#### b) 関係性の特定
以下の関係性を見つけ出してください：

| 関係タイプ | 記号 | 例 |
|---|---|---|
| 包含（AはBを含む） | ○の中に○ | 「環境設定」⊃「CLAUDE.md」 |
| 因果（AがBを引き起こす） | → | 「計画」→「実装」 |
| 双方向（AとBは相互作用） | ↔ | 「テスト」↔「コード」 |
| グループ（A,B,Cは同カテゴリ） | 囲み | ツール群をまとめる |
| 依存（AはBに依存） | 点線→ | 「並列実行」...>「Git Worktrees」 |

#### c) 中心概念の特定
- 図の中心に置くべき核となる概念は何か
- そこから放射状に広がる構造か、フローとして流れる構造か

### 3. 構造マップの作成（テキストで）

画像生成の前に、構造をテキストで表現してください：

```
【中心概念】
○○○

【主要な枝/フロー】
中心 → 枝1 → 詳細a, 詳細b
     → 枝2 → 詳細c
     ↔ 枝3（双方向）

【グループ】
[グループA]: 要素1, 要素2, 要素3
[グループB]: 要素4, 要素5

【重要な関係性】
- 要素X → 要素Y: （理由/説明）
- 要素Z ↔ 要素W: （相互作用の内容）
```

### 4. 画像生成

Nano-Banana-MCP の `generate_image` ツールを使用して生成してください。

**プロンプト構築の必須要素**:

```
Create a graphic recording / visual note style illustration about [トピック].

STYLE REQUIREMENTS:
- Hand-drawn, sketch-like aesthetic with organic flowing layout
- NOT a rigid grid or bullet-point list
- Elements connected by arrows, lines, and visual flow
- Central concept in the middle, related concepts radiating outward
- Use visual hierarchy: larger = more important
- Include small icons/doodles as visual anchors
- Whiteboard or paper-like background
- Japanese text for all labels

STRUCTURE:
[ステップ3で作成した構造をここに記述]

RELATIONSHIPS TO SHOW:
- [要素A] --arrow--> [要素B] (cause/effect)
- [要素C] <--双方向--> [要素D] (互いに影響)
- Group [要素E, F, G] together in a bubble

COLOR SCHEME:
- 2-3 accent colors maximum
- Use color to distinguish different categories/groups
- Black or dark gray for main text and lines
```

**避けるべきこと**:
- 「infographic」という単語（整然としたレイアウトになりがち）
- 「clean」「organized」「structured」（有機的な配置の逆）
- 番号付きリストの指示

### 5. 結果の提示と改善提案

生成された画像のパスを提示し、以下を確認：
- 関係性が視覚的に表現されているか
- 中心概念が明確か
- 必要なら再生成や補足画像を提案

## 注意事項

- **関係性の可視化が最優先**: 要素を並べるだけでなく、つながりを示す
- 完璧な網羅性より、構造の理解しやすさを重視
- 手書き風・有機的なレイアウトを目指す
- 情報が多すぎる場合は「全体俯瞰図」＋「詳細図」に分割
