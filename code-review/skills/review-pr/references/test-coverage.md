# テストカバレッジレビュー観点

test-coverage-reviewer エージェントが確認する観点の詳細ドキュメント。

## レビュー対象

### 1. 新規コードのテスト有無

- 新規追加された関数/クラスにテストがあるか
- 重要なビジネスロジックがテストされているか
- テストファイルが適切な場所に配置されているか

**確認ポイント**:
- 新規の `.ts` / `.js` / `.py` 等のファイルに対応する `*.test.*` / `*.spec.*` があるか
- 既存テストファイルに新規テストケースが追加されているか

### 2. エッジケースのカバレッジ

- 空配列・空文字列・null/undefined の処理
- 境界値（0, -1, 最大値, 最小値）
- 異常な入力に対する動作

**テストすべきケース例**:
```javascript
describe('calculateDiscount', () => {
  // 正常系
  it('should apply 10% discount for orders over 100', () => { ... });

  // 境界値
  it('should not apply discount for order of exactly 100', () => { ... });
  it('should apply discount for order of 101', () => { ... });

  // エッジケース
  it('should handle zero amount', () => { ... });
  it('should handle negative amount', () => { ... });
  it('should handle null input', () => { ... });
});
```

### 3. テストの独立性と再現性

- テスト間で状態が共有されていないか
- テストの実行順序に依存していないか
- 外部サービスへの依存がモック化されているか
- ランダム性がシード値で制御されているか

**問題例**:
```javascript
// ❌ グローバル状態に依存
let counter = 0;
test('first test', () => {
  counter++;
  expect(counter).toBe(1);
});
test('second test', () => {
  expect(counter).toBe(1); // 前のテストに依存
});

// ✅ 独立したテスト
test('first test', () => {
  const counter = createCounter();
  counter.increment();
  expect(counter.value).toBe(1);
});
```

### 4. モック/スタブの適切な使用

- 外部依存（API, DB, ファイルシステム）がモック化されているか
- モックの振る舞いが実際の動作を適切に模倣しているか
- モックが過剰に使用されていないか（実装の詳細をテストしていないか）

**問題例**:
```javascript
// ❌ 実際のAPIを呼び出し
test('should fetch user data', async () => {
  const user = await fetchUser(123); // 本番APIを呼ぶ
  expect(user.name).toBe('John');
});

// ✅ モック化
test('should fetch user data', async () => {
  jest.spyOn(api, 'get').mockResolvedValue({ name: 'John' });
  const user = await fetchUser(123);
  expect(user.name).toBe('John');
});
```

### 5. テスト名の明確さ

- テスト名が何をテストしているか明確か
- `should` + 期待される動作 の形式が推奨
- Given-When-Then パターンの活用

**良いテスト名の例**:
```javascript
// ❌ 曖昧な名前
test('works', () => { ... });
test('test1', () => { ... });

// ✅ 明確な名前
test('should return empty array when no users match filter', () => { ... });
test('should throw ValidationError when email format is invalid', () => { ... });
```

### 6. Arrange-Act-Assert パターン

- テストが適切に構造化されているか
- 準備（Arrange）・実行（Act）・検証（Assert）が明確か

**パターン例**:
```javascript
test('should calculate total with tax', () => {
  // Arrange
  const items = [{ price: 100 }, { price: 200 }];
  const taxRate = 0.1;

  // Act
  const total = calculateTotalWithTax(items, taxRate);

  // Assert
  expect(total).toBe(330);
});
```

### 7. 異常系のテスト

- エラーが発生するケースがテストされているか
- エラーメッセージや例外の種類が検証されているか
- タイムアウトやネットワークエラーへの対応がテストされているか

**テストすべき異常系**:
```javascript
describe('fetchUser', () => {
  it('should throw NotFoundError when user does not exist', async () => {
    await expect(fetchUser(999)).rejects.toThrow(NotFoundError);
  });

  it('should throw NetworkError on connection failure', async () => {
    mockApi.simulateNetworkError();
    await expect(fetchUser(1)).rejects.toThrow(NetworkError);
  });

  it('should handle timeout gracefully', async () => {
    mockApi.simulateTimeout();
    await expect(fetchUser(1)).rejects.toThrow(TimeoutError);
  });
});
```

## 指摘しない項目

- 既存のテストがないレガシーコードへの完全なカバレッジ要求
- カバレッジ率の数値のみに基づく指摘（意味のないテストを促すため）
- プライベートメソッドへの直接的なテスト要求

## インラインコメント例

```markdown
## 🔍 テストカバレッジ

**問題**: 新規追加された `validateEmail` 関数にテストがありません。

**影響**: メールバリデーションロジックの変更時にリグレッションを検出できなくなります。

**提案**: 以下のケースを含むテストを追加することを推奨します:

```suggestion
describe('validateEmail', () => {
  it('should return true for valid email', () => {
    expect(validateEmail('user@example.com')).toBe(true);
  });

  it('should return false for email without @', () => {
    expect(validateEmail('userexample.com')).toBe(false);
  });

  it('should return false for empty string', () => {
    expect(validateEmail('')).toBe(false);
  });
});
```

---
_🤖 Claude Code Review - test-coverage-reviewer_
```
