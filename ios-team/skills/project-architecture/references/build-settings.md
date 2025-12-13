# ビルド設定リファレンス

## 目次

1. [Swift設定](#swift設定)
2. [デプロイメント](#デプロイメント)
3. [コード署名](#コード署名)
4. [最適化](#最適化)
5. [デバッグ](#デバッグ)
6. [リンク](#リンク)
7. [構成別の推奨値](#構成別の推奨値)

---

## Swift設定

### SWIFT_VERSION

Swiftのバージョン。

| 値 | 説明 |
|----|------|
| `5.0` | Swift 5.0 |
| `6.0` | Swift 6.0（厳格な並行性チェック） |

### SWIFT_STRICT_CONCURRENCY

Swift Concurrencyの厳格さレベル。

| 値 | 説明 |
|----|------|
| `minimal` | 最小限のチェック |
| `targeted` | `@Sendable`等を明示した箇所のみ |
| `complete` | 完全なチェック（Swift 6デフォルト） |

### SWIFT_UPCOMING_FEATURE_*

将来のSwift機能を先行有効化。

```
SWIFT_UPCOMING_FEATURE_CONCISE_MAGIC_FILE = YES
SWIFT_UPCOMING_FEATURE_FORWARD_TRAILING_CLOSURES = YES
SWIFT_UPCOMING_FEATURE_IMPLICIT_OPEN_EXISTENTIALS = YES
```

### OTHER_SWIFT_FLAGS

追加のSwiftコンパイラフラグ。

```
OTHER_SWIFT_FLAGS = -warn-concurrency -enable-actor-data-race-checks
```

---

## デプロイメント

### IPHONEOS_DEPLOYMENT_TARGET

サポートする最小iOSバージョン。

| 値 | サポート終了の目安 |
|----|------------------|
| `15.0` | 広い互換性 |
| `16.0` | NavigationStack等 |
| `17.0` | Observable macro等 |
| `18.0` | 最新機能 |

### TARGETED_DEVICE_FAMILY

対象デバイス。

| 値 | 説明 |
|----|------|
| `1` | iPhone |
| `2` | iPad |
| `1,2` | iPhone + iPad |

### SUPPORTS_MACCATALYST

Mac Catalyst対応。

| 値 | 説明 |
|----|------|
| `YES` | Mac Catalyst有効 |
| `NO` | 無効 |

---

## コード署名

### CODE_SIGN_STYLE

署名方式。

| 値 | 説明 |
|----|------|
| `Automatic` | Xcodeが自動管理 |
| `Manual` | 手動で証明書を指定 |

### DEVELOPMENT_TEAM

開発チームID（10文字の英数字）。

### CODE_SIGN_IDENTITY

署名に使用する証明書。

| 値 | 説明 |
|----|------|
| `Apple Development` | 開発用 |
| `Apple Distribution` | 配布用 |
| `-` | 署名なし |

### PROVISIONING_PROFILE_SPECIFIER

プロビジョニングプロファイル名（Manual時）。

---

## 最適化

### SWIFT_OPTIMIZATION_LEVEL

Swiftコンパイラの最適化レベル。

| 値 | 説明 | 用途 |
|----|------|------|
| `-Onone` | 最適化なし | Debug |
| `-O` | 速度最適化 | Release |
| `-Osize` | サイズ最適化 | Release（サイズ重視） |

### SWIFT_COMPILATION_MODE

コンパイルモード。

| 値 | 説明 |
|----|------|
| `singlefile` | ファイルごとにコンパイル |
| `wholemodule` | モジュール全体を最適化 |

### GCC_OPTIMIZATION_LEVEL

C/Objective-Cの最適化レベル。

| 値 | 説明 |
|----|------|
| `0` | 最適化なし |
| `s` | サイズ最適化 |
| `fast` | 速度最適化 |

---

## デバッグ

### DEBUG_INFORMATION_FORMAT

デバッグ情報の形式。

| 値 | 説明 | 用途 |
|----|------|------|
| `dwarf` | DWARF形式 | Debug |
| `dwarf-with-dsym` | dSYMファイル生成 | Release（クラッシュ解析用） |

### ENABLE_TESTABILITY

テストからinternalメンバーにアクセス可能にする。

| 値 | 説明 |
|----|------|
| `YES` | `@testable import`が使用可能 |
| `NO` | 無効 |

### GCC_PREPROCESSOR_DEFINITIONS

プリプロセッサマクロ。

```
GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1   // Debug
GCC_PREPROCESSOR_DEFINITIONS = RELEASE=1 // Release
```

### SWIFT_ACTIVE_COMPILATION_CONDITIONS

Swiftの条件コンパイルフラグ。

```
SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG  // Debug
SWIFT_ACTIVE_COMPILATION_CONDITIONS =        // Release
```

---

## リンク

### OTHER_LDFLAGS

リンカフラグ。

```
OTHER_LDFLAGS = -ObjC                    // Objective-Cカテゴリのロード
OTHER_LDFLAGS = -all_load                // 全シンボルのロード
OTHER_LDFLAGS = -framework SomeFramework // フレームワークリンク
```

### DEAD_CODE_STRIPPING

未使用コードの削除。

| 値 | 説明 |
|----|------|
| `YES` | 削除する（サイズ削減） |
| `NO` | 削除しない |

### LD_RUNPATH_SEARCH_PATHS

動的ライブラリの検索パス。

```
LD_RUNPATH_SEARCH_PATHS = @executable_path/Frameworks
```

---

## 構成別の推奨値

### Debug構成

```
SWIFT_OPTIMIZATION_LEVEL = -Onone
SWIFT_COMPILATION_MODE = singlefile
DEBUG_INFORMATION_FORMAT = dwarf
ENABLE_TESTABILITY = YES
SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1
ONLY_ACTIVE_ARCH = YES
```

### Release構成

```
SWIFT_OPTIMIZATION_LEVEL = -O
SWIFT_COMPILATION_MODE = wholemodule
DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
ENABLE_TESTABILITY = NO
SWIFT_ACTIVE_COMPILATION_CONDITIONS =
GCC_PREPROCESSOR_DEFINITIONS = RELEASE=1
ONLY_ACTIVE_ARCH = NO
DEAD_CODE_STRIPPING = YES
```

---

## よくある変更パターン

### 最小iOSバージョンの引き上げ

```bash
# 全構成に適用
update_build_setting:
  setting_name: IPHONEOS_DEPLOYMENT_TARGET
  value: "17.0"
```

### Swift 6移行準備

```bash
# まず警告として確認
update_build_setting:
  setting_name: SWIFT_STRICT_CONCURRENCY
  value: complete
  configuration_name: Debug

# 問題なければRelease にも
update_build_setting:
  setting_name: SWIFT_STRICT_CONCURRENCY
  value: complete
  configuration_name: Release
```

### テスト用ビルド設定

```bash
# Debugでテスト可能性を有効化
update_build_setting:
  setting_name: ENABLE_TESTABILITY
  value: "YES"
  configuration_name: Debug
  target_name: MyApp
```
