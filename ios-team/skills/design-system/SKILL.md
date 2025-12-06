---
name: design-system
description: iOS/SwiftUIアプリのデザインシステム・スタイルガイドを構築するスキル。カラーパレット、タイポグラフィ、スペーシング、コンポーネントスタイルをSwiftコードとして生成。使用シーン：(1)「スタイルガイドを作って」「デザインシステムを構築して」などの新規作成リクエスト (2)「既存のスタイルを分析して」「色やフォントを整理して」などの既存コード分析リクエスト (3) UI実装時にスタイル定義の一貫性が必要な場合
---

# iOS Design System

iOS/SwiftUIアプリのデザインシステムをSwiftコードとして構築・管理する。

## コード構造

型（構造）と値（インスタンス）を分離した設計。複数テーマの切り替えや比較が可能。

```swift
// 統合struct
struct DesignSystem {
    let colors: ColorPalette
    let typography: Typography
    let spacing: SpacingScale
    let cornerRadius: CornerRadiusScale
    let shadow: ShadowScale
    let layout: LayoutConstants
}

// プリセットインスタンス
extension DesignSystem {
    static let `default` = DesignSystem(...)
    static let minimal = DesignSystem(...)
    static let pop = DesignSystem(...)
}

// 使用例
let theme = DesignSystem.default
Text("Hello")
    .font(theme.typography.bodyLarge)
    .foregroundColor(theme.colors.textPrimary)
```

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

### Step 3: コード生成

`assets/templates/` のテンプレートをベースにカスタマイズ。

### 生成するファイル構成

```
DesignSystem/
├── DesignSystem.swift    # 統合struct + テーマインスタンス
├── Colors.swift          # ColorPalette struct
├── Typography.swift      # Typography struct
├── Spacing.swift         # SpacingScale, CornerRadiusScale, ShadowScale
└── Components/
    ├── ButtonStyles.swift
    └── TextFieldStyles.swift
```

## 複数テーマの作成例

```swift
// カスタムテーマの定義
extension DesignSystem {
    static let myBrand = DesignSystem(
        colors: ColorPalette(
            primaryBrand: Color(hex: "FF6B6B"),
            // ...
        ),
        typography: .rounded,
        spacing: .default,
        cornerRadius: .rounded,
        shadow: .default,
        layout: .default
    )
}

// テーマ切り替え
struct ContentView: View {
    @State private var theme = DesignSystem.default

    var body: some View {
        VStack {
            Text("Title").font(theme.typography.displayLarge)
            Button("Switch Theme") {
                theme = (theme === .default) ? .myBrand : .default
            }
            .buttonStyle(PrimaryButtonStyle(theme: theme))
        }
    }
}
```

## 既存コード分析フロー

1. **コード検索**: `Color`, `Font`, `.padding`, `.cornerRadius` などの使用箇所を検索
2. **パターン抽出**: 使われている値を収集・分類
3. **整理・提案**: 一貫性のある DesignSystem として再構成を提案

## リファレンス

| ファイル | 内容 |
|---------|------|
| `references/style-presets.md` | 世界観別カラーパレット・スタイルプリセット |
| `references/design-guidelines.md` | 詳細なデザインガイドライン、色彩理論 |
| `assets/templates/DesignSystem.swift` | 統合struct定義 |
| `assets/templates/Colors.swift` | ColorPalette struct |
| `assets/templates/Typography.swift` | Typography struct |
| `assets/templates/Spacing.swift` | Spacing/CornerRadius/Shadow structs |
| `assets/templates/ButtonStyles.swift` | テーマ対応ボタンスタイル |
| `assets/templates/TextFieldStyles.swift` | テーマ対応テキストフィールド |

## 出力規約

- 型と値を分離（struct定義 + static インスタンス）
- 全ての値に明確な命名規則を適用（semantic naming）
- SwiftUI の標準パターンに準拠
- ダークモード対応を考慮
- 注入方法（Environment等）はアプリ側で決定
