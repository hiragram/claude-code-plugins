# パフォーマンスレビュー観点

performance-reviewer エージェントが確認する観点の詳細ドキュメント。

## レビュー対象

### 1. アルゴリズム複雑度

- O(n²) 以上の計算量を持つ処理がないか
- より効率的なアルゴリズムへの置き換えが可能か
- 大量データを扱う処理での計算量に注意

**問題例**:
```javascript
// ❌ O(n²) - 大きな配列で非効率
function findDuplicates(arr) {
  const duplicates = [];
  for (let i = 0; i < arr.length; i++) {
    for (let j = i + 1; j < arr.length; j++) {
      if (arr[i] === arr[j]) duplicates.push(arr[i]);
    }
  }
  return duplicates;
}

// ✅ O(n) - Set を使用
function findDuplicates(arr) {
  const seen = new Set();
  const duplicates = new Set();
  for (const item of arr) {
    if (seen.has(item)) duplicates.add(item);
    seen.add(item);
  }
  return [...duplicates];
}
```

### 2. N+1問題

- ループ内でデータベースクエリを実行していないか
- ループ内でAPI呼び出しを行っていないか
- 関連データを事前に一括取得できないか

**問題例**:
```javascript
// ❌ N+1問題
const users = await User.findAll();
for (const user of users) {
  const orders = await Order.findByUserId(user.id); // N回クエリ
  user.orders = orders;
}

// ✅ 一括取得
const users = await User.findAll();
const userIds = users.map(u => u.id);
const orders = await Order.findByUserIds(userIds); // 1回クエリ
const ordersByUser = groupBy(orders, 'userId');
for (const user of users) {
  user.orders = ordersByUser[user.id] || [];
}
```

### 3. メモリリーク・循環参照

- イベントリスナーが適切に解除されているか
- タイマー/インターバルがクリアされているか
- クロージャが大きなオブジェクトを保持し続けていないか
- 循環参照が発生していないか

**問題例**:
```javascript
// ❌ メモリリーク
class Component {
  constructor() {
    window.addEventListener('resize', this.handleResize);
  }
  // リスナーが解除されない
}

// ✅ 適切なクリーンアップ
class Component {
  constructor() {
    this.handleResize = this.handleResize.bind(this);
    window.addEventListener('resize', this.handleResize);
  }
  destroy() {
    window.removeEventListener('resize', this.handleResize);
  }
}
```

### 4. 不要なオブジェクト生成

- ループ内で毎回オブジェクトを生成していないか
- 不変のオブジェクトをループ外で定義できないか
- 文字列連結が効率的に行われているか

**問題例**:
```javascript
// ❌ ループ内でオブジェクト生成
for (let i = 0; i < 10000; i++) {
  const config = { timeout: 5000, retry: 3 }; // 毎回生成
  processWithConfig(items[i], config);
}

// ✅ ループ外で定義
const config = { timeout: 5000, retry: 3 };
for (let i = 0; i < 10000; i++) {
  processWithConfig(items[i], config);
}
```

### 5. キャッシュの活用

- 計算コストの高い処理の結果をキャッシュできないか
- 同じAPIへの重複リクエストを防げないか
- メモ化が有効な場面がないか

**問題例**:
```javascript
// ❌ 毎回計算
function getFibonacci(n) {
  if (n <= 1) return n;
  return getFibonacci(n - 1) + getFibonacci(n - 2);
}

// ✅ メモ化
const cache = new Map();
function getFibonacci(n) {
  if (cache.has(n)) return cache.get(n);
  if (n <= 1) return n;
  const result = getFibonacci(n - 1) + getFibonacci(n - 2);
  cache.set(n, result);
  return result;
}
```

### 6. 非同期処理の最適化

- 並列実行可能な処理が直列になっていないか
- `Promise.all` / `Promise.allSettled` の活用
- 不要な await がないか

**問題例**:
```javascript
// ❌ 直列実行（遅い）
const user = await fetchUser(id);
const orders = await fetchOrders(id);
const reviews = await fetchReviews(id);

// ✅ 並列実行（速い）
const [user, orders, reviews] = await Promise.all([
  fetchUser(id),
  fetchOrders(id),
  fetchReviews(id),
]);
```

### 7. リソースの適切な解放

- ファイルハンドルが閉じられているか
- データベース接続が返却されているか
- ストリームが適切にクローズされているか

## 指摘しない項目

- マイクロ最適化（数ミリ秒単位の改善）
- プロファイリングなしでのボトルネック推測
- 可読性を著しく損なう最適化

## インラインコメント例

```markdown
## 🔍 パフォーマンス

**問題**: ループ内で `await fetchOrderDetails(orderId)` を呼び出しており、N+1問題が発生しています。100件の注文がある場合、100回のAPI呼び出しが発生します。

**影響**: レスポンス時間が注文数に比例して増加し、サーバー負荷も増大します。

**提案**: 注文IDを一括で取得するAPIを使用するか、`Promise.all` で並列化することを推奨します。

```suggestion
const orderIds = orders.map(o => o.id);
const orderDetails = await fetchOrderDetailsBatch(orderIds);
```

---
_🤖 Claude Code Review - performance-reviewer_
```
