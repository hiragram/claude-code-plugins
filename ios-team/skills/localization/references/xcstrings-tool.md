# xcstrings-tool リファレンス

## 目次

1. [概要](#概要)
2. [セットアップ](#セットアップ)
3. [生成されるコード](#生成されるコード)
4. [使用方法](#使用方法)
5. [フォーマット指定子](#フォーマット指定子)
6. [複数形・バリエーション](#複数形バリエーション)

---

## 概要

xcstrings-toolは、String Catalog (.xcstrings) からSwiftの型安全なAPIを自動生成するBuild Tool Plugin。

**メリット**:
- コンパイル時にキーの存在を検証
- パラメータの型チェック
- 自動補完が効く
- typoによる実行時エラーを防止

---

## セットアップ

### 1. パッケージ追加

Xcode > File > Add Package Dependencies:
```
https://github.com/liamnichols/xcstrings-tool
```

または Package.swift:
```swift
dependencies: [
    .package(url: "https://github.com/liamnichols/xcstrings-tool", from: "1.0.0")
]
```

### 2. Build Tool Pluginの有効化

**Xcodeプロジェクトの場合**:
1. ターゲットを選択
2. Build Phases タブ
3. "+" > "Run Build Tool Plug-ins"
4. "XCStringsToolPlugin" を追加

**Swift Packageの場合**:
```swift
.target(
    name: "MyTarget",
    dependencies: [],
    plugins: [
        .plugin(name: "XCStringsToolPlugin", package: "xcstrings-tool")
    ]
)
```

### 3. String Catalogの配置

```
MyApp/
├── Sources/
│   └── ...
└── Resources/
    └── Localizable.xcstrings
```

ターゲットのリソースとして含まれていることを確認。

---

## 生成されるコード

String Catalog の内容に基づいて、以下のようなSwiftコードが自動生成される。

### 基本的なキー

String Catalog:
```json
{
  "settings_title": {
    "localizations": {
      "en": { "stringUnit": { "value": "Settings" } },
      "ja": { "stringUnit": { "value": "設定" } }
    }
  }
}
```

生成コード:
```swift
extension LocalizedStringResource {
    static func localizable(_ key: Localizable) -> LocalizedStringResource { ... }
}

enum Localizable {
    case settingsTitle
    // ...
}
```

### パラメータ付きキー

String Catalog:
```json
{
  "welcome_message": {
    "localizations": {
      "en": { "stringUnit": { "value": "Hello, %@!" } },
      "ja": { "stringUnit": { "value": "こんにちは、%@さん！" } }
    }
  }
}
```

生成コード:
```swift
enum Localizable {
    case welcomeMessage(String)
}
```

---

## 使用方法

### Text

```swift
// 基本
Text(.localizable(.settingsTitle))

// パラメータ付き
Text(.localizable(.welcomeMessage(userName)))
```

### Button

```swift
Button(.localizable(.saveButton)) {
    save()
}
```

### NavigationTitle

```swift
.navigationTitle(.localizable(.settingsTitle))
```

### Label

```swift
Label(.localizable(.profileLabel), systemImage: "person")
```

### String として取得

```swift
let message = String(localized: .localizable(.errorMessage))
```

### AttributedString

```swift
let attributed = AttributedString(localized: .localizable(.formattedText))
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

"page_indicator" = "Page %1$lld of %2$lld"  // 英語
"page_indicator" = "%2$lldページ中%1$lldページ"  // 日本語
```

```swift
Text(.localizable(.pageIndicator(currentPage, totalPages)))
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
  "items_count": {
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
Text(.localizable(.itemsCount(count)))
```

### デバイス別バリエーション

String Catalogでデバイス（iPhone/iPad/Mac等）ごとに異なるテキストを設定可能。

---

## トラブルシューティング

### 生成されない場合

1. Build Phases に XCStringsToolPlugin が追加されているか確認
2. .xcstrings ファイルがターゲットのリソースに含まれているか確認
3. Clean Build (Cmd+Shift+K) 後に再ビルド

### キー名の変換ルール

| String Catalog キー | 生成されるenum case |
|--------------------|-------------------|
| `settings_title` | `settingsTitle` |
| `login-button` | `loginButton` |
| `SAVE_BUTTON` | `saveButton` |

スネークケース、ケバブケース、大文字はcamelCaseに変換される。

### 予約語との衝突

Swiftの予約語と衝突するキーはバッククォートで囲まれる：

```swift
case `default`
case `return`
```
