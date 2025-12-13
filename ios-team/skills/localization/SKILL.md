---
name: localization
description: iOSアプリのローカライズ（多言語対応）を支援するスキル。String Catalog (.xcstrings) とxcstrings-toolを使った型安全なローカライズを実現。使用シーン：(1) プロトタイプから本番実装への書き換え時にテキストをローカライズする (2)「このテキストをローカライズして」などの明示的な指示 (3) 新しい画面や機能追加時にUIテキストのローカライズが必要な場合
---

# Localization

UIテキストを型安全にローカライズする。xcstrings-toolを使用してString Catalogから生成されたSwiftコードを利用する。

## 前提条件

- Xcode 15以降
- String Catalog (.xcstrings) を使用
- xcstrings-tool がプロジェクトに導入済み

## xcstrings-tool

[liamnichols/xcstrings-tool](https://github.com/liamnichols/xcstrings-tool) はString CatalogからSwift定数を生成するSwift Package Plugin。

### 導入方法

```swift
// Package.swift または Xcode の Package Dependencies
.package(url: "https://github.com/liamnichols/xcstrings-tool", from: "1.0.0")
```

Build Phasesでプラグインを有効化すると、ビルド時にSwiftコードが自動生成される。

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
│ キーを追加       │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ 生成されたコードで │
│ 置き換え          │
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

// ✅ ローカライズ済み
Text(.localizable(.settings))
Button(.localizable(.save)) { ... }
.navigationTitle(.localizable(.profileTitle))
```

### パラメータ付き文字列

```swift
// ❌ ハードコード
Text("\(count)件の通知")
Text("こんにちは、\(userName)さん")

// ✅ ローカライズ済み
// String Catalog: "notifications_count" = "%lld件の通知"
Text(.localizable(.notificationsCount(count)))

// String Catalog: "greeting" = "こんにちは、%@さん"
Text(.localizable(.greeting(userName)))
```

### 複数形対応

String Catalogで複数形バリエーションを定義：

| Key | Plural | Value |
|-----|--------|-------|
| items_count | zero | アイテムがありません |
| items_count | one | %lld件のアイテム |
| items_count | other | %lld件のアイテム |

```swift
Text(.localizable(.itemsCount(items.count)))
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
| 画面名_要素 | `settings_title`, `profile_saveButton` |
| 機能_アクション | `auth_loginButton`, `cart_checkoutButton` |
| 共通_用途 | `common_ok`, `common_cancel`, `common_error` |

## プロトタイプからの変換手順

1. **テキスト抽出**: ハードコードされた日本語テキストを特定
2. **キー設計**: 適切なキー名を決定
3. **Catalog追加**: String Catalogにキーと翻訳を追加
4. **コード置換**: 生成された型安全なAPIで置き換え
5. **ビルド確認**: 正常にビルドできることを確認

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
            Section(.localizable(.settingsSectionAccount)) {
                Text(.localizable(.settingsEditProfile))
                Text(.localizable(.settingsChangePassword))
            }
            Section(.localizable(.settingsSectionApp)) {
                Text(.localizable(.settingsNotifications))
                Text(.localizable(.settingsLanguage))
            }
        }
        .navigationTitle(.localizable(.settingsTitle))
    }
}
```

## リファレンス

| ファイル | 内容 |
|---------|------|
| `references/xcstrings-tool.md` | xcstrings-toolの詳細な使い方 |

## 注意事項

- キーは英語のスネークケース（`login_button`）を推奨
- 同じテキストでも文脈が異なれば別キーにする
- パラメータの順序は言語によって変わる可能性があるため、位置指定子（`%1$@`）の使用を検討
- アクセシビリティラベルもローカライズ対象
