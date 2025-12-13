# Testing Guide

Reducerテストの書き方。Swift Testingを使用。純粋関数なのでテストがシンプル。

## Swift Testing

XCTestではなく**Swift Testing**を使用する。

```swift
import Testing
@testable import MyApp
```

主な違い:
- `XCTestCase`クラス → 不要（structでもOK）
- `func test_xxx()` → `@Test func xxx()`
- `XCTAssertEqual` → `#expect(_ == _)`
- `XCTAssertTrue` → `#expect(_)`
- `XCTAssertNil` → `#expect(_ == nil)`

## Reducerテストの基本

Reducerは `(inout State, Action) -> Void` の純粋関数。副作用がないのでテストが簡単。

```swift
import Testing
@testable import MyApp

struct OrderReducerTests {

    @Test func loadOrders_setsLoadingTrue() {
        var state = OrderState()

        OrderReducer.reduce(state: &state, action: .loadOrders)

        #expect(state.isLoading)
        #expect(state.error == nil)
    }

    @Test func ordersLoaded_updatesOrdersAndSetsLoadingFalse() {
        var state = OrderState(isLoading: true)
        let orders = [Order.sample, Order.sample]

        OrderReducer.reduce(state: &state, action: .ordersLoaded(orders))

        #expect(state.orders == orders)
        #expect(!state.isLoading)
    }

    @Test func ordersFailed_setsError() {
        var state = OrderState(isLoading: true)
        let error = TestError.network

        OrderReducer.reduce(state: &state, action: .ordersFailed(error))

        #expect(state.error != nil)
        #expect(!state.isLoading)
    }
}
```

## テストパターン

### 状態遷移のテスト

```swift
@Test func completeFlow_loadToSuccess() {
    var state = OrderState()

    // 初期状態
    #expect(state.orders.isEmpty)
    #expect(!state.isLoading)

    // ロード開始
    OrderReducer.reduce(state: &state, action: .loadOrders)
    #expect(state.isLoading)

    // ロード完了
    let orders = [Order.sample]
    OrderReducer.reduce(state: &state, action: .ordersLoaded(orders))
    #expect(!state.isLoading)
    #expect(state.orders == orders)
}

@Test func completeFlow_loadToFailure() {
    var state = OrderState()

    OrderReducer.reduce(state: &state, action: .loadOrders)
    #expect(state.isLoading)

    OrderReducer.reduce(state: &state, action: .ordersFailed(TestError.network))
    #expect(!state.isLoading)
    #expect(state.error != nil)
    #expect(state.orders.isEmpty)
}
```

### エッジケースのテスト

```swift
@Test func loadOrders_clearsExistingError() {
    var state = OrderState(error: TestError.network)

    OrderReducer.reduce(state: &state, action: .loadOrders)

    #expect(state.error == nil)
}

@Test func selectOrder_updatesSelectedOrderId() {
    var state = OrderState()
    let order = Order.sample

    OrderReducer.reduce(state: &state, action: .selectOrder(order))

    #expect(state.selectedOrderId == order.id)
}
```

### パラメータ化テスト

```swift
@Test(arguments: [
    OrderAction.loadOrders,
    OrderAction.refresh
])
func loadingActions_setIsLoadingTrue(action: OrderAction) {
    var state = OrderState()

    OrderReducer.reduce(state: &state, action: action)

    #expect(state.isLoading)
}
```

## Storeのテスト（副作用を含む）

副作用のテストはStoreレベルで行う。Mockを使用。

```swift
import Testing
@testable import MyApp

@MainActor
struct AppStoreTests {
    let mockOrderService = MockOrderService()

    @Test func loadOrders_callsServiceAndUpdatesState() async {
        let store = AppStore(orderService: mockOrderService)
        let expectedOrders = [Order.sample]
        mockOrderService.fetchOrdersResult = .success(expectedOrders)

        store.send(.order(.loadOrders))

        // 非同期処理を待つ
        await Task.yield()
        await Task.yield()

        #expect(store.state.order.orders == expectedOrders)
        #expect(!store.state.order.isLoading)
        #expect(mockOrderService.fetchOrdersCallCount == 1)
    }

    @Test func loadOrders_failure_setsError() async {
        let store = AppStore(orderService: mockOrderService)
        mockOrderService.fetchOrdersResult = .failure(TestError.network)

        store.send(.order(.loadOrders))
        await Task.yield()
        await Task.yield()

        #expect(store.state.order.error != nil)
        #expect(store.state.order.orders.isEmpty)
    }
}
```

## Mock作成

```swift
final class MockOrderService: OrderServiceProtocol {
    var fetchOrdersCallCount = 0
    var fetchOrdersResult: Result<[Order], Error> = .success([])

    var placeOrderCallCount = 0
    var lastPlacedOrder: Order?
    var placeOrderResult: Result<OrderResult, Error> = .success(.init())

    func fetchOrders() async throws -> [Order] {
        fetchOrdersCallCount += 1
        return try fetchOrdersResult.get()
    }

    func placeOrder(_ order: Order) async throws -> OrderResult {
        placeOrderCallCount += 1
        lastPlacedOrder = order
        return try placeOrderResult.get()
    }
}

enum TestError: Error {
    case network
    case unauthorized
    case unknown
}
```

## テストデータ

```swift
extension Order {
    static var sample: Order {
        Order(
            id: UUID(),
            title: "Sample Order",
            items: [.sample],
            total: 1000,
            status: .pending,
            createdAt: Date()
        )
    }

    static func samples(count: Int) -> [Order] {
        (0..<count).map { _ in .sample }
    }
}

extension OrderState {
    static var loading: OrderState {
        OrderState(isLoading: true)
    }

    static func loaded(_ orders: [Order]) -> OrderState {
        OrderState(orders: orders, isLoading: false)
    }
}
```

## ファイル構成

```
Tests/
├── ReducerTests/
│   ├── OrderReducerTests.swift
│   ├── ProfileReducerTests.swift
│   └── NavigationReducerTests.swift
├── StoreTests/
│   └── AppStoreTests.swift
├── Mocks/
│   ├── MockOrderService.swift
│   └── MockUserService.swift
└── TestHelpers/
    ├── TestError.swift
    └── SampleData.swift
```

## テストのポイント

### Reducerテスト

- **純粋関数**: 入力（State + Action）に対して出力（State）が決定的
- **副作用なし**: async/await不要、即座に結果が得られる
- **網羅的に**: 各Actionケースをテスト

### Storeテスト

- **副作用を含む**: async/awaitが必要
- **Mockで依存を注入**: 外部サービスの振る舞いをコントロール
- **統合テスト的**: Reducer + 副作用の連携をテスト

### Viewテスト

Viewは基本的にテスト不要（ロジックがないため）。必要ならSnapshot Testを検討。
