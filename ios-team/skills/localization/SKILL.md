---
name: localization
description: iOSアプリのローカライズ（多言語対応）を支援するスキル。String Catalog (.xcstrings) とXcode 26の型安全なシンボル生成機能を使ったローカライズを実現。使用シーン：(1) プロトタイプから本番実装への書き換え時にテキストをローカライズする (2)「このテキストをローカライズして」などの明示的な指示 (3) 新しい画面や機能追加時にUIテキストのローカライズが必要な場合
---

# Localization

UIテキストを型安全にローカライズする。Xcode 26から追加されたString Catalogのシンボル生成機能を使用して、型安全なAPIを利用する。

## 前提条件

- Xcode 26以降
- String Catalog (.xcstrings) を使用
- ビルド設定で "Generate String Catalog Symbols" を有効化

## Xcode 26のシンボル生成機能

Xcode 26からString Catalogに型安全なSwiftシンボル生成機能が追加された。これにより、外部ツールなしで型安全なローカライズが実現できる。

### 有効化方法

**新規プロジェクト**: デフォルトで有効

**既存プロジェクト**:
1. Build Settings を開く
2. "Generate String Catalog Symbols" を検索
3. `Yes` に設定

## ワークフロー

```
UIテキストの実装
       │
       ▼
┌──────────────────┐
│ ハードコードされた │
│ テキストを発見    │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ String Catalogに │
│ キーと値を追加   │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ 生成されたシンボル│
│ で置き換え       │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ 各言語の翻訳を    │
│ String Catalogに │
│ 追加             │
└──────────────────┘
```

## 実装パターン

### 基本的な置き換え

```swift
// ❌ ハードコード（プロトタイプ）
Text("設定")
Button("保存") { ... }
.navigationTitle("プロフィール")

// ✅ ローカライズ済み（Xcode 26シンボル）
Text(.settings)
Button(.save) { ... }
.navigationTitle(.profileTitle)
```

### パラメータ付き文字列

String Catalogでプレースホルダを定義すると、関数として生成される：

```swift
// ❌ ハードコード
Text("\(count)件の通知")
Text("こんにちは、\(userName)さん")

// ✅ ローカライズ済み
// String Catalog: キー "notificationsCount", 値 "%lld件の通知"
Text(.notificationsCount(count))

// String Catalog: キー "greeting", 値 "こんにちは、%@さん"
Text(.greeting(userName))
```

### 複数形対応

String Catalogで複数形バリエーションを定義：

| Key | Plural | Value |
|-----|--------|-------|
| itemsCount | zero | アイテムがありません |
| itemsCount | one | %lld件のアイテム |
| itemsCount | other | %lld件のアイテム |

```swift
Text(.itemsCount(items.count))
```

### String として取得

```swift
let message = String(localized: .errorMessage)
```

### カスタムビューでの使用

```swift
struct CustomView: View {
    let title: LocalizedStringResource

    var body: some View {
        Text(title)
    }
}

// 使用側
CustomView(title: .customTitle)
```

## String Catalogの構造

`Localizable.xcstrings` の配置：
```
MyApp/
├── MyApp/
│   └── Resources/
│       └── Localizable.xcstrings
```

### キー命名規則

| パターン | 例 |
|---------|-----|
| 画面名_要素 | `settingsTitle`, `profileSaveButton` |
| 機能_アクション | `authLoginButton`, `cartCheckoutButton` |
| 共通_用途 | `commonOk`, `commonCancel`, `commonError` |

### 生成されるシンボル名

| String Catalog キー | 生成されるシンボル |
|--------------------|------------------|
| `settings_title` | `.settingsTitle` |
| `login-button` | `.loginButton` |
| `SAVE_BUTTON` | `.saveButton` |

スネークケース、ケバブケース、大文字はcamelCaseに変換される。

## #bundle マクロ（フレームワーク向け）

フレームワークやSwift Packageでリソースを参照する場合：

```swift
// 旧（Bundle.module）
Text("Hello", bundle: Bundle.module)

// 新（#bundle マクロ）
Text("Hello", bundle: #bundle)
```

`#bundle`マクロは実行コンテキストに応じて適切なバンドルを自動解決する。

## プロトタイプからの変換手順

### 手動変換

1. **テキスト抽出**: ハードコードされた日本語テキストを特定
2. **キー設計**: 適切なキー名を決定
3. **Catalog追加**: String Catalogにキーと翻訳を追加
4. **コード置換**: 生成されたシンボルで置き換え
5. **ビルド確認**: 正常にビルドできることを確認

### リファクタリング機能を使用

Xcode 26では、既存のハードコードされた文字列を一括でシンボルに変換できる：

1. 文字列を選択
2. 右クリック → **Refactor** → **Convert Strings to Symbols**
3. 自動的にString Catalogにエントリが追加され、コードがシンボル参照に変換される

```swift
// 変換前
Text("42件の新規投稿")

// 変換後（自動）
Text(.feedTitle(newPosts: 42))
```

### 変換例

変換前（プロトタイプ）:
```swift
struct SettingsView: View {
    var body: some View {
        List {
            Section("アカウント") {
                Text("プロフィール編集")
                Text("パスワード変更")
            }
            Section("アプリ設定") {
                Text("通知")
                Text("言語")
            }
        }
        .navigationTitle("設定")
    }
}
```

変換後:
```swift
struct SettingsView: View {
    var body: some View {
        List {
            Section(.settingsSectionAccount) {
                Text(.settingsEditProfile)
                Text(.settingsChangePassword)
            }
            Section(.settingsSectionApp) {
                Text(.settingsNotifications)
                Text(.settingsLanguage)
            }
        }
        .navigationTitle(.settingsTitle)
    }
}
```

## テーブル別の整理

大規模プロジェクトでは、機能ごとにString Catalogを分割できる：

```
Resources/
├── Localizable.xcstrings      # 共通
├── Settings.xcstrings         # 設定画面
└── Onboarding.xcstrings       # オンボーディング
```

非デフォルトテーブルのシンボルはネストされる：
```swift
Text(.Settings.title)
Text(.Onboarding.welcomeMessage)
```

## リファレンス

| ファイル | 内容 |
|---------|------|
| `references/symbol-generation.md` | シンボル生成機能の詳細 |

## 注意事項

- キーは英語のcamelCaseまたはスネークケースを推奨
- 同じテキストでも文脈が異なれば別キーにする
- パラメータの順序は言語によって変わる可能性があるため、位置指定子（`%1$@`）の使用を検討
- アクセシビリティラベルもローカライズ対象
- Xcode 25以前のプロジェクトでは、xcstrings-toolなどの外部ツールが必要

## 参考リンク

- [Explore localization with Xcode - WWDC25](https://developer.apple.com/videos/play/wwdc2025/225/)
- [What's new in Xcode 26 - WWDC25](https://developer.apple.com/videos/play/wwdc2025/247/)
