# State Management

Single Root Stateパターンによる状態設計の詳細。

## 状態の階層構造

```swift
// ルート状態
struct AppState {
    var order = OrderState()
    var profile = ProfileState()
    var settings = SettingsState()
    var navigation = NavigationState()
}

// 機能別状態
struct OrderState {
    var orders: [Order] = []
    var selectedOrderId: Order.ID?
    var isLoading = false
    var error: Error?
}

struct NavigationState {
    var selectedTab: Tab = .home
    var orderDetailPath: [Order.ID] = []  // NavigationStack用
}
```

## 状態の分類

### Shared State（AppStateで管理）

複数画面で共有される状態:

```swift
struct AppState {
    var currentUser: User?           // ログインユーザー
    var orders: [Order] = []         // 注文一覧（複数画面で参照）
    var cart = CartState()           // カート（どこからでもアクセス）
}
```

### Navigation State

画面遷移の状態:

```swift
struct NavigationState {
    var selectedTab: Tab = .home

    // NavigationStack paths
    var homePath: [HomeDestination] = []
    var orderPath: [OrderDestination] = []

    // Modal presentations
    var presentedSheet: Sheet?
    var presentedAlert: AlertState?
}

enum HomeDestination: Hashable {
    case orderDetail(Order.ID)
    case profile
}
```

### Ephemeral State（Viewで管理）

一時的なUI状態は`@State`で管理してOK:

```swift
struct OrderListView: View {
    let orders: [Order]
    let onTap: (Order) -> Void

    // これらはViewローカルでOK
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool

    var filteredOrders: [Order] {
        orders.filter { ... }
    }

    var body: some View { ... }
}
```

**Ephemeral Stateの基準:**
- 他の画面に影響しない
- 画面を離れたら破棄してよい
- アプリ状態として保存不要

## 状態の肥大化への対処

### 機能モジュールごとに分割

```swift
// AppState.swift
struct AppState {
    var order = OrderState()
    var profile = ProfileState()
    var settings = SettingsState()
}

// 各ファイルに分離
// OrderState.swift
struct OrderState { ... }

// ProfileState.swift
struct ProfileState { ... }
```

### 大規模アプリでの構成

```
AppState
├── auth: AuthState              # 認証
├── user: UserState              # ユーザー情報
├── features/
│   ├── home: HomeState
│   ├── order: OrderState
│   ├── profile: ProfileState
│   └── settings: SettingsState
├── navigation: NavigationState  # 画面遷移
└── system: SystemState          # アプリ全体（ネットワーク状態等）
```

## パラメータ渡しのパターン

### 値を直接渡す

```swift
struct OrderDetailView: View {
    let order: Order
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack {
            Text(order.title)
            // ...
        }
    }
}

// 呼び出し側
OrderDetailView(
    order: store.state.order.selectedOrder!,
    onEdit: { store.send(.order(.editOrder)) },
    onDelete: { store.send(.order(.deleteOrder)) }
)
```

### IDで渡してViewで解決

```swift
struct OrderDetailContainer: View {
    @EnvironmentObject var store: AppStore
    let orderId: Order.ID

    var body: some View {
        if let order = store.state.order.orders.first(where: { $0.id == orderId }) {
            OrderDetailView(
                order: order,
                onEdit: { ... },
                onDelete: { ... }
            )
        } else {
            Text("Order not found")
        }
    }
}
```

## Loading / Error State

### LoadingState enum

```swift
enum LoadingState<T> {
    case idle
    case loading
    case loaded(T)
    case failed(Error)
}

struct OrderState {
    var orderList: LoadingState<[Order]> = .idle
}
```

### 使用例

```swift
// Reducer
case .loadOrders:
    state.orderList = .loading

case .ordersLoaded(let orders):
    state.orderList = .loaded(orders)

case .ordersFailed(let error):
    state.orderList = .failed(error)

// View
switch store.state.order.orderList {
case .idle:
    Color.clear.onAppear { store.send(.order(.loadOrders)) }
case .loading:
    ProgressView()
case .loaded(let orders):
    OrderListView(orders: orders, ...)
case .failed(let error):
    ErrorView(error: error, onRetry: { store.send(.order(.loadOrders)) })
}
```

## Pagination

```swift
struct FeedState {
    var posts: [Post] = []
    var currentPage = 0
    var hasMore = true
    var isLoadingMore = false
}

enum FeedAction {
    case loadInitial
    case loadMore
    case postsLoaded(page: Int, posts: [Post], hasMore: Bool)
}

// Reducer
case .loadMore:
    guard !state.isLoadingMore, state.hasMore else { return }
    state.isLoadingMore = true

case .postsLoaded(let page, let posts, let hasMore):
    if page == 0 {
        state.posts = posts
    } else {
        state.posts.append(contentsOf: posts)
    }
    state.currentPage = page
    state.hasMore = hasMore
    state.isLoadingMore = false
```

## Navigation with State

### NavigationStack連携

```swift
struct OrderNavigationView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        NavigationStack(path: Binding(
            get: { store.state.navigation.orderPath },
            set: { store.send(.navigation(.setOrderPath($0))) }
        )) {
            OrderListContainer()
                .navigationDestination(for: Order.ID.self) { orderId in
                    OrderDetailContainer(orderId: orderId)
                }
        }
    }
}
```

### Programmatic Navigation

```swift
// アクション
enum NavigationAction {
    case pushOrderDetail(Order.ID)
    case popToRoot
    case setOrderPath([Order.ID])
}

// Reducer
case .pushOrderDetail(let id):
    state.orderPath.append(id)

case .popToRoot:
    state.orderPath.removeAll()
```
