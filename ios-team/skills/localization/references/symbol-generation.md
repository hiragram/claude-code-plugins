# String Catalog シンボル生成機能 リファレンス

## 目次

1. [概要](#概要)
2. [セットアップ](#セットアップ)
3. [生成されるシンボル](#生成されるシンボル)
4. [使用方法](#使用方法)
5. [フォーマット指定子](#フォーマット指定子)
6. [複数形・バリエーション](#複数形バリエーション)
7. [リファクタリング機能](#リファクタリング機能)

---

## 概要

Xcode 26から、String Catalog (.xcstrings) からSwiftの型安全なシンボルを自動生成する機能が追加された。

**メリット**:
- コンパイル時にキーの存在を検証
- パラメータの型チェック
- 自動補完が効く
- typoによる実行時エラーを防止
- 外部ツール不要

---

## セットアップ

### ビルド設定

**Xcode 26以降の新規プロジェクト**: デフォルトで有効

**既存プロジェクト**:
1. ターゲットを選択
2. Build Settings タブを開く
3. "Generate String Catalog Symbols" を検索
4. `Yes` に設定

### String Catalogの配置

```
MyApp/
├── Sources/
│   └── ...
└── Resources/
    └── Localizable.xcstrings
```

ターゲットのリソースとして含まれていることを確認。

---

## 生成されるシンボル

String Catalog の内容に基づいて、Swiftシンボルが自動生成される。

### 基本的なキー（プレースホルダなし）

静的プロパティとして生成される：

String Catalog:
```json
{
  "settingsTitle": {
    "localizations": {
      "en": { "stringUnit": { "value": "Settings" } },
      "ja": { "stringUnit": { "value": "設定" } }
    }
  }
}
```

使用方法:
```swift
Text(.settingsTitle)
```

### パラメータ付きキー（プレースホルダあり）

関数として生成され、プレースホルダ名が引数ラベルになる：

String Catalog:
```json
{
  "welcomeMessage": {
    "localizations": {
      "en": { "stringUnit": { "value": "Hello, %@!" } },
      "ja": { "stringUnit": { "value": "こんにちは、%@さん！" } }
    }
  }
}
```

使用方法:
```swift
Text(.welcomeMessage(userName))
```

### テーブル別のシンボル

デフォルトの `Localizable.xcstrings` 以外のテーブルは、ネストされた形で生成される：

```swift
// Localizable.xcstrings
Text(.settingsTitle)

// Settings.xcstrings
Text(.Settings.title)

// Onboarding.xcstrings
Text(.Onboarding.welcomeMessage)
```

---

## 使用方法

### SwiftUI View

```swift
// Text
Text(.settingsTitle)

// パラメータ付き
Text(.welcomeMessage(userName))

// Button
Button(.saveButton) {
    save()
}

// NavigationTitle
.navigationTitle(.settingsTitle)

// Label
Label(.profileLabel, systemImage: "person")
```

### Foundation String

```swift
let message = String(localized: .errorMessage)
```

### AttributedString

```swift
let attributed = AttributedString(localized: .formattedText)
```

### カスタムコンポーネント

```swift
struct CollectionDetailEditingView: View {
    let title: LocalizedStringResource

    init(title: LocalizedStringResource) {
        self.title = title
    }

    var body: some View {
        Text(title)
    }
}

// 使用側
CollectionDetailEditingView(title: .editingTitle)
```

---

## フォーマット指定子

| 指定子 | Swift型 | 説明 |
|--------|---------|------|
| `%@` | String | 文字列 |
| `%lld` | Int | 整数（64bit） |
| `%d` | Int32 | 整数（32bit） |
| `%.2f` | Double | 小数点以下2桁 |
| `%1$@` | String | 位置指定（1番目） |
| `%2$lld` | Int | 位置指定（2番目） |

### 位置指定子の使用

言語によって語順が変わる場合に使用：

```
// 英語: "Page 1 of 10"
// 日本語: "10ページ中1ページ"

"pageIndicator" = "Page %1$lld of %2$lld"  // 英語
"pageIndicator" = "%2$lldページ中%1$lldページ"  // 日本語
```

```swift
Text(.pageIndicator(currentPage, totalPages))
```

---

## 複数形・バリエーション

### 複数形 (Plural)

String Catalogで設定：

| Plural Category | 例（英語） |
|-----------------|----------|
| zero | 0 items |
| one | 1 item |
| two | 2 items |
| few | 3 items |
| many | 10 items |
| other | %lld items |

```json
{
  "itemsCount": {
    "localizations": {
      "en": {
        "variations": {
          "plural": {
            "one": { "stringUnit": { "value": "%lld item" } },
            "other": { "stringUnit": { "value": "%lld items" } }
          }
        }
      },
      "ja": {
        "stringUnit": { "value": "%lld件のアイテム" }
      }
    }
  }
}
```

```swift
Text(.itemsCount(count))
```

### デバイス別バリエーション

String Catalogでデバイス（iPhone/iPad/Mac等）ごとに異なるテキストを設定可能。

---

## リファクタリング機能

### Convert Strings to Symbols

既存のハードコードされた文字列をシンボルに一括変換できる：

1. 文字列を選択（複数選択可）
2. 右クリック → **Refactor** → **Convert Strings to Symbols**
3. 自動的に:
   - String Catalogにエントリが追加される
   - コードがシンボル参照に変換される

```swift
// 変換前
Text("42件の新規投稿")

// 変換後
Text(.feedTitle(newPosts: 42))
```

### テーブル単位の一括変換

大量の文字列を一括で変換する場合は、テーブル全体を選択して変換可能。

---

## #bundle マクロ

フレームワークやSwift Packageでリソースを参照する場合、`#bundle`マクロを使用：

```swift
// 旧来の方法（Bundle.module）
Text("Hello", bundle: Bundle.module)

// Xcode 26以降（#bundle マクロ）
Text("Hello", bundle: #bundle)
```

`#bundle`マクロの利点:
- 実行コンテキストに応じて適切なバンドルを自動解決
- メインアプリ、フレームワーク、Swift Package で共通のコードが使える
- `Bundle.module`よりも堅牢

---

## 自動コメント生成

Xcode 26では、String Catalogに追加された文字列に対して、オンデバイスモデルを使用して翻訳者向けのコメントを自動生成できる。

自動生成されたコメントはXLIFFエクスポート時に `<note from="auto-generated">` としてマークされる。

---

## トラブルシューティング

### シンボルが生成されない場合

1. Build Settings で "Generate String Catalog Symbols" が `Yes` になっているか確認
2. .xcstrings ファイルがターゲットのリソースに含まれているか確認
3. Clean Build (Cmd+Shift+K) 後に再ビルド

### シンボル名の変換ルール

| String Catalog キー | 生成されるシンボル |
|--------------------|-------------------|
| `settings_title` | `.settingsTitle` |
| `login-button` | `.loginButton` |
| `SAVE_BUTTON` | `.saveButton` |

スネークケース、ケバブケース、大文字はcamelCaseに変換される。

### 予約語との衝突

Swiftの予約語と衝突するキーはバッククォートで囲まれる：

```swift
Text(.`default`)
Text(.`return`)
```

---

## 参考リンク

- [Explore localization with Xcode - WWDC25](https://developer.apple.com/videos/play/wwdc2025/225/)
- [What's new in Xcode 26 - WWDC25](https://developer.apple.com/videos/play/wwdc2025/247/)
- [Localizing and varying text with a string catalog - Apple Developer](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog)
