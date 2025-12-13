---
name: project-architecture
description: Xcodeプロジェクトのアーキテクチャ設計・ビルド設定管理スキル。モジュール分割、ターゲット追加、依存関係整理、ビルド設定変更を支援。使用シーン：(1)「ビルド設定XXをYYに変更して」などのビルド設定変更リクエスト (2)「この機能を新しいモジュールに切り出して」などのモジュール分割リクエスト (3) 大きな機能追加時にモジュール構成やテスト可能性を検討する場合 (4)「Swift Packageを追加して」などの依存関係管理
---

# Project Architecture

Xcodeプロジェクトのアーキテクチャ設計とビルド設定を管理する。

## 利用可能なツール

pbxproj MCPサーバーが利用可能。プロジェクト操作は直接ツールを呼び出して実行する。

**情報取得**:
- `get_project_info` - プロジェクト概要
- `list_targets` - ターゲット一覧
- `get_target_info` - ターゲット詳細
- `list_files` / `list_groups` - ファイル・グループ構造
- `list_configurations` - ビルド構成一覧
- `get_build_settings` - ビルド設定取得
- `list_build_phases` - ビルドフェーズ一覧
- `list_packages` - Swift Package依存関係
- `list_schemes` / `get_scheme_info` - スキーム情報

**変更操作**:
- `update_build_setting` - ビルド設定変更
- `add_file` / `remove_file` - ファイル追加・削除
- `add_group` - グループ追加
- `add_target` / `add_target_dependency` - ターゲット追加・依存関係設定
- `add_swift_package` / `add_local_package` - パッケージ追加
- `add_run_script` / `update_run_script` - スクリプトフェーズ管理

## ワークフロー

```
リクエスト受信
      │
      ▼
┌─────────────────┐
│ リクエスト種別判定 │
└───────┬─────────┘
   ┌────┼────┬────────┐
   ▼    ▼    ▼        ▼
ビルド設定  モジュール  依存関係   アーキ
 変更      分割      追加     レビュー
   │       │        │        │
   ▼       ▼        ▼        ▼
現状確認   現状分析   互換性確認  構造分析
   │       │        │        │
   ▼       ▼        ▼        ▼
 変更実行  設計提案   追加実行   改善提案
           │
           ▼
        承認後実行
```

## ビルド設定変更

### 手順

1. `get_build_settings` で現在値を確認
2. `list_configurations` で対象構成を確認（Debug/Release等）
3. `update_build_setting` で変更実行

### よく使うビルド設定

| 設定名 | 説明 | 典型的な値 |
|-------|------|-----------|
| `SWIFT_VERSION` | Swiftバージョン | `5.0`, `6.0` |
| `IPHONEOS_DEPLOYMENT_TARGET` | 最小iOS | `15.0`, `17.0` |
| `PRODUCT_BUNDLE_IDENTIFIER` | Bundle ID | `com.example.app` |
| `CODE_SIGN_STYLE` | 署名方式 | `Automatic`, `Manual` |
| `SWIFT_STRICT_CONCURRENCY` | 並行性チェック | `minimal`, `targeted`, `complete` |
| `ENABLE_TESTABILITY` | テスト可能性 | `YES` (Debug), `NO` (Release) |
| `DEBUG_INFORMATION_FORMAT` | デバッグ情報 | `dwarf`, `dwarf-with-dsym` |
| `SWIFT_OPTIMIZATION_LEVEL` | 最適化レベル | `-Onone`, `-O`, `-Osize` |

詳細は `references/build-settings.md` を参照。

## モジュール分割

### 判断基準

モジュール分割を検討すべき状況：

1. **再利用性** - 複数ターゲットで共有したいコード
2. **テスト可能性** - 単体テストを書きたいビジネスロジック
3. **ビルド時間** - 変更の影響範囲を限定したい
4. **責務の分離** - 明確に異なる関心事を分離したい

### モジュール種別

| 種別 | 用途 | 作成方法 |
|-----|------|---------|
| Swift Package (ローカル) | 推奨。シンプルな依存管理 | ファイルシステムで作成後 `add_local_package` |
| Framework | 動的リンク、リソース含む | `add_target` (product_type: `framework`) |
| Static Library | 静的リンク | `add_target` (product_type: `staticLibrary`) |

### 推奨構成パターン

```
MyApp/
├── MyApp/                    # メインアプリターゲット
│   ├── App/                  # AppDelegate, SceneDelegate
│   ├── Features/             # 画面・機能別
│   └── Resources/            # Assets, Localizable
├── Packages/                 # ローカルSwift Packages
│   ├── Core/                 # 共通ユーティリティ
│   ├── Domain/               # ビジネスロジック
│   ├── Data/                 # リポジトリ、API
│   └── UI/                   # 共通UIコンポーネント
└── MyAppTests/               # テストターゲット
```

詳細は `references/module-patterns.md` を参照。

### 分割実行手順

1. **現状分析**: `list_targets`, `list_files` でプロジェクト構造把握
2. **設計提案**: 分割案をユーザーに提示し承認を得る
3. **Package/Target作成**: 新モジュールを作成
4. **コード移動**: ファイルを新モジュールに移動
5. **依存関係設定**: `add_target_dependency` または `add_local_package`
6. **import追加**: 移動したコードへのimport文を追加
7. **ビルド確認**: 正常にビルドできることを確認

## テスト可能なアーキテクチャ

### 原則

1. **依存性注入（DI）**: 外部依存はprotocolで抽象化し注入可能に
2. **Pure Functions**: 副作用のないロジックは関数として切り出す
3. **境界の明確化**: UI層とビジネスロジック層を分離

### パターン例

```swift
// ❌ テストしにくい
class OrderViewModel {
    func placeOrder() {
        let api = APIClient.shared  // ハードコードされた依存
        api.post("/orders", ...)
    }
}

// ✅ テストしやすい
protocol OrderServiceProtocol {
    func placeOrder(_ order: Order) async throws -> OrderResult
}

class OrderViewModel {
    private let orderService: OrderServiceProtocol

    init(orderService: OrderServiceProtocol) {
        self.orderService = orderService
    }

    func placeOrder() async throws {
        try await orderService.placeOrder(currentOrder)
    }
}

// テスト時
class MockOrderService: OrderServiceProtocol {
    var placeOrderResult: Result<OrderResult, Error> = .success(...)

    func placeOrder(_ order: Order) async throws -> OrderResult {
        try placeOrderResult.get()
    }
}
```

## Swift Package追加

### リモートパッケージ

```
add_swift_package:
  repository_url: "https://github.com/xxx/yyy"
  product_name: "ProductName"
  target_name: "MyApp"
  version: "1.0.0"
  version_rule: "upToNextMajor"  # or upToNextMinor, exact, branch, revision
```

### ローカルパッケージ

1. `Packages/MyModule/` にSwift Package構造を作成
2. `add_local_package` でプロジェクトに追加

## リファレンス

| ファイル | 内容 |
|---------|------|
| `references/build-settings.md` | ビルド設定の詳細リファレンス |
| `references/module-patterns.md` | モジュール分割パターンの詳細 |
