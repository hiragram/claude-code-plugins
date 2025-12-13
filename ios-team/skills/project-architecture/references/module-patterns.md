# モジュール分割パターン

## 目次

1. [レイヤードアーキテクチャ](#レイヤードアーキテクチャ)
2. [Feature-based分割](#feature-based分割)
3. [ハイブリッドアプローチ](#ハイブリッドアプローチ)
4. [Swift Package構成](#swift-package構成)
5. [依存関係ルール](#依存関係ルール)

---

## レイヤードアーキテクチャ

責務ごとに水平分割するパターン。

```
┌─────────────────────────────────┐
│         Presentation            │  UI, ViewModels
├─────────────────────────────────┤
│           Domain                │  UseCases, Entities
├─────────────────────────────────┤
│            Data                 │  Repositories, API, DB
├─────────────────────────────────┤
│            Core                 │  Extensions, Utilities
└─────────────────────────────────┘
```

### モジュール構成例

```
Packages/
├── Core/           # 共通ユーティリティ、Extension
├── Domain/         # Entity, UseCase (protocol)
├── Data/           # Repository実装, APIClient, DB
└── Presentation/   # 共通UIコンポーネント
```

### 依存方向

```
App → Presentation → Domain ← Data
                        ↓
                      Core
```

Domain層はData層に依存しない（Dependency Inversion）。

---

## Feature-based分割

機能ごとに垂直分割するパターン。

```
┌────────┬────────┬────────┬────────┐
│  Auth  │  Home  │ Search │ Profile│
├────────┴────────┴────────┴────────┤
│              Shared               │
└───────────────────────────────────┘
```

### モジュール構成例

```
Packages/
├── Shared/         # 共通コード
├── AuthFeature/    # 認証機能
├── HomeFeature/    # ホーム画面
├── SearchFeature/  # 検索機能
└── ProfileFeature/ # プロフィール機能
```

### 各Featureの内部構造

```
AuthFeature/
├── Sources/
│   └── AuthFeature/
│       ├── Views/
│       ├── ViewModels/
│       ├── Models/
│       └── Services/
└── Tests/
```

---

## ハイブリッドアプローチ

レイヤーとFeatureを組み合わせた実践的パターン。

```
Packages/
├── Core/               # 最下層：純粋なユーティリティ
│   └── Extensions, Logger, etc.
│
├── Domain/             # ドメイン層：ビジネスルール
│   ├── Entities/
│   └── UseCases/
│
├── Data/               # データ層：外部システム連携
│   ├── Network/
│   ├── Persistence/
│   └── Repositories/
│
├── SharedUI/           # 共通UI
│   └── Components/
│
└── Features/           # 機能別（必要に応じて分割）
    ├── Auth/
    └── Settings/
```

---

## Swift Package構成

### Package.swift テンプレート

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Domain", targets: ["Domain"])
    ],
    dependencies: [
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
                .product(name: "Core", package: "Core")
            ]
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"]
        )
    ]
)
```

### ディレクトリ構造

```
Domain/
├── Package.swift
├── Sources/
│   └── Domain/
│       ├── Entities/
│       │   └── User.swift
│       └── UseCases/
│           └── FetchUserUseCase.swift
└── Tests/
    └── DomainTests/
        └── FetchUserUseCaseTests.swift
```

---

## 依存関係ルール

### 基本原則

1. **単方向依存**: 循環依存を避ける
2. **安定方向への依存**: 変更の少ないモジュールに依存
3. **抽象への依存**: 具象クラスではなくprotocolに依存

### 依存グラフの確認

依存関係が正しいか確認するチェックリスト：

- [ ] Core は他のモジュールに依存していない
- [ ] Domain は Data に依存していない
- [ ] Feature間に直接の依存がない
- [ ] 循環依存がない

### 依存の注入パターン

```swift
// Domain層: protocolを定義
public protocol UserRepository {
    func fetch(id: String) async throws -> User
}

// Data層: 実装を提供
public struct UserRepositoryImpl: UserRepository {
    public func fetch(id: String) async throws -> User {
        // API呼び出し
    }
}

// App層: 組み立て
let repository = UserRepositoryImpl()
let useCase = FetchUserUseCase(repository: repository)
let viewModel = UserViewModel(useCase: useCase)
```

---

## 分割の判断フローチャート

```
コードを分割すべきか？
        │
        ▼
┌───────────────────┐
│ 複数ターゲットで   │──Yes──→ 分割する
│ 共有する？         │
└─────────┬─────────┘
          │No
          ▼
┌───────────────────┐
│ 単体テストを      │──Yes──→ 分割を検討
│ 書きたい？        │
└─────────┬─────────┘
          │No
          ▼
┌───────────────────┐
│ ビルド時間が      │──Yes──→ 分割を検討
│ 問題？            │
└─────────┬─────────┘
          │No
          ▼
┌───────────────────┐
│ チームで並行開発？ │──Yes──→ 分割を検討
└─────────┬─────────┘
          │No
          ▼
    分割しない（フォルダ整理で十分）
```

---

## アンチパターン

### 過度な分割

```
❌ 避けるべき
Packages/
├── StringExtensions/    # 細かすぎる
├── DateExtensions/      # 細かすぎる
├── ArrayExtensions/     # 細かすぎる
└── ...

✅ 適切な粒度
Packages/
└── Core/
    └── Extensions/
        ├── String+.swift
        ├── Date+.swift
        └── Array+.swift
```

### 双方向依存

```
❌ 循環依存
ModuleA ←→ ModuleB

✅ 共通モジュールの抽出
ModuleA → Shared ← ModuleB
```
