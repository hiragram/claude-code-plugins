---
name: design-system
description: iOS/SwiftUIアプリのデザインシステム・スタイルガイドを構築するスキル。カラーパレット、タイポグラフィ、スペーシング、コンポーネントスタイルをSwiftコードとして生成。使用シーン：(1)「スタイルガイドを作って」「デザインシステムを構築して」などの新規作成リクエスト (2)「既存のスタイルを分析して」「色やフォントを整理して」などの既存コード分析リクエスト (3) UI実装時にスタイル定義の一貫性が必要な場合
---

# iOS Design System

iOS/SwiftUIアプリのデザインシステムをSwiftコードとして構築・管理する。

## ワークフロー

```
ユーザーリクエスト
       │
       ▼
┌──────────────────┐
│ 新規作成 or 分析？│
└────────┬─────────┘
    ┌────┴────┐
    ▼         ▼
 新規作成    既存分析
    │         │
    ▼         ▼
 世界観ヒアリング  コード検索
    │         │
    ▼         ▼
 プリセット選定   パターン抽出
    │         │
    ▼         ▼
 カスタマイズ    整理・提案
    │         │
    └────┬────┘
         ▼
   Swiftコード出力
```

## 新規作成フロー

### Step 1: 世界観のヒアリング

以下を確認してスタイルの方向性を決定：

**必須確認項目**:
- アプリの種類・目的（タスク管理、SNS、EC、ヘルスケア等）
- ターゲットユーザー（年齢層、性別、職業等）
- 求める雰囲気・印象（キーワード）

**雰囲気キーワード例**:
| キーワード | 対応プリセット |
|-----------|---------------|
| シンプル、洗練、クリーン | ミニマル/モダン |
| 楽しい、明るい、カラフル | ポップ/カジュアル |
| 高級、エレガント、上質 | 高級/プレミアム |
| 自然、健康、温かみ | ナチュラル/オーガニック |
| 先進的、クール、テック | ダーク/テック |
| 優しい、安心、親しみ | フレンドリー/ソフト |
| 信頼、堅実、ビジネス | ビジネス/プロフェッショナル |
| ノスタルジック、クラシック | レトロ/ヴィンテージ |

### Step 2: プリセット選定とカスタマイズ

1. `references/style-presets.md` から最適なプリセットを選定
2. ユーザーの要件に合わせてカラー・フォントを調整
3. ブランドカラーがある場合は組み込む

**カスタマイズポイント**:
- プライマリカラー: ブランドカラーまたはプリセットベース
- アクセントカラー: 補色または類似色から選定
- 背景温度: 暖色系（#FFFxxx）か寒色系（#F0Fxxx）か

### Step 3: コード生成

`assets/templates/` のテンプレートをベースにカスタマイズしたコードを生成。

### 生成するファイル構成

```
DesignSystem/
├── Colors.swift          # カラーパレット定義
├── Typography.swift      # フォントスタイル定義
├── Spacing.swift         # スペーシング定数
├── Shadows.swift         # シャドウスタイル
├── CornerRadius.swift    # 角丸定数
└── Components/           # 共通コンポーネントスタイル
    ├── ButtonStyles.swift
    └── TextFieldStyles.swift
```

## 既存コード分析フロー

1. **コード検索**: `Color`, `Font`, `.padding`, `.cornerRadius` などの使用箇所を検索
2. **パターン抽出**: 使われている値を収集・分類
3. **整理・提案**: 一貫性のあるデザインシステムとして再構成を提案

### 検索パターン

```swift
// カラー検索
Color(.*)
UIColor(.*)
.foregroundColor(.*)
.background(.*)

// フォント検索
.font(.*)
Font.system(.*)
Font.custom(.*)

// スペーシング検索
.padding(.*)
.spacing(.*)
VStack(spacing:.*)
HStack(spacing:.*)

// その他
.cornerRadius(.*)
.shadow(.*)
```

## リファレンス

| ファイル | 内容 |
|---------|------|
| `references/style-presets.md` | 世界観別カラーパレット・スタイルプリセット |
| `references/design-guidelines.md` | 詳細なデザインガイドライン、色彩理論 |
| `assets/templates/Colors.swift` | カラー定義テンプレート |
| `assets/templates/Typography.swift` | タイポグラフィテンプレート |
| `assets/templates/Spacing.swift` | スペーシング・角丸・シャドウテンプレート |
| `assets/templates/ButtonStyles.swift` | ボタンスタイルテンプレート |
| `assets/templates/TextFieldStyles.swift` | テキストフィールドテンプレート |

## 出力規約

- Color は `Color` extension で定義（Asset Catalog 非依存）
- Font は `Font` extension で定義
- 全ての値に明確な命名規則を適用（semantic naming）
- SwiftUI の標準パターンに準拠
- ダークモード対応を考慮
