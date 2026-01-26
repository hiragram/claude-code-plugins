# ドキュメント正確性レビュー観点

documentation-accuracy-reviewer エージェントが確認する観点の詳細ドキュメント。

## レビュー対象

### 1. コードとコメントの整合性

- コメントが実際のコードの動作と一致しているか
- 変更されたコードに対応するコメントも更新されているか
- 古い情報を含むコメントが残っていないか

**問題例**:
```javascript
// ❌ コメントとコードが不一致
// ユーザーIDで検索してユーザーを返す
function findUserByEmail(email) {  // 実際はemailで検索
  return users.find(u => u.email === email);
}

// ✅ 正確なコメント
// メールアドレスで検索してユーザーを返す
function findUserByEmail(email) {
  return users.find(u => u.email === email);
}
```

### 2. 公開APIのドキュメント

- 公開関数/クラスにJSDoc/docstring/コメントがあるか
- パラメータと戻り値が正確に文書化されているか
- 使用例が含まれているか（複雑なAPIの場合）

**良いドキュメントの例**:
```javascript
/**
 * ユーザーの注文履歴を取得する
 *
 * @param {string} userId - 対象ユーザーのID
 * @param {Object} options - 取得オプション
 * @param {number} [options.limit=10] - 取得件数の上限
 * @param {Date} [options.since] - この日時以降の注文のみ取得
 * @returns {Promise<Order[]>} 注文オブジェクトの配列
 * @throws {NotFoundError} ユーザーが存在しない場合
 *
 * @example
 * const orders = await getOrderHistory('user123', { limit: 5 });
 */
async function getOrderHistory(userId, options = {}) {
  // ...
}
```

### 3. README / CHANGELOG の更新

- 新機能追加時にREADMEが更新されているか
- 破壊的変更がCHANGELOGに記録されているか
- インストール手順や使用方法が最新か

**確認ポイント**:
- 新しいAPIエンドポイント → READMEのAPI仕様
- 新しい設定項目 → 設定ドキュメント
- 新しい依存関係 → インストール手順

### 4. 複雑なロジックへの説明

- 非自明なアルゴリズムに説明があるか
- ビジネスルールの根拠が記載されているか
- 「なぜ」そうしているかが分かるか

**良い説明の例**:
```javascript
// RFC 5322に準拠したメールアドレスの正規表現
// 参考: https://emailregex.com/
// Note: 完全なRFC準拠ではなく、一般的なケースをカバー
const EMAIL_REGEX = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

// 注文金額の10%を割引として適用
// ビジネス要件: JIRA-1234 で定義された2024年プロモーション施策
const DISCOUNT_RATE = 0.1;
```

### 5. TODO / FIXME コメントの妥当性

- TODO/FIXMEが放置されていないか
- 新規追加のTODOに期限やチケット番号があるか
- 解決済みのTODOが残っていないか

**良いTODOの例**:
```javascript
// TODO(JIRA-5678): 2024-03-01までにキャッシュ機構を実装
// 現状はDBに直接アクセスしているが、パフォーマンス要件を満たすためにキャッシュが必要

// FIXME: この実装は一時的。issue #123 で本対応予定
```

### 6. 型定義・インターフェースの説明

- 複雑な型の各プロパティに説明があるか
- ユニオン型や条件型の意図が明確か
- ジェネリクスの使用方法が文書化されているか

**良い型定義の例**:
```typescript
/**
 * ユーザーの購読状態を表す
 */
interface Subscription {
  /** 購読プランのID */
  planId: string;

  /** 購読開始日時 */
  startedAt: Date;

  /** 購読終了日時（nullの場合は無期限） */
  expiresAt: Date | null;

  /**
   * 購読の状態
   * - active: 有効
   * - cancelled: キャンセル済み（期限まで有効）
   * - expired: 期限切れ
   */
  status: 'active' | 'cancelled' | 'expired';
}
```

### 7. 非自明な設計判断の記録

- なぜその技術/ライブラリを選択したか
- なぜその設計パターンを採用したか
- トレードオフの検討結果

**例: ADR (Architecture Decision Records) 形式**:
```markdown
## ADR-001: 状態管理にReduxを採用

### ステータス
採用

### コンテキスト
複雑なUIの状態を複数コンポーネント間で共有する必要がある。

### 決定
Reduxを採用する。

### 理由
- デバッグツールが充実
- 予測可能な状態更新
- チームに経験者が多い

### 代替案
- Context API: シンプルだがパフォーマンス懸念
- Zustand: 軽量だが採用実績が少ない
```

## 指摘しない項目

- 自明なコードへのコメント要求（`i++` に「iを1増やす」など）
- ドキュメント形式の好みの押し付け
- 変更されていない既存コードのドキュメント不足

## インラインコメント例

```markdown
## 🔍 ドキュメント正確性

**問題**: `calculateShippingCost` 関数のJSDocに `@returns` が記載されていますが、実際の戻り値の型と一致していません。ドキュメントでは `number` となっていますが、実装は `{ cost: number, estimatedDays: number }` を返しています。

**影響**: APIを使用する開発者が誤った型を期待し、バグの原因となる可能性があります。

**提案**:

```suggestion
/**
 * 配送料金と推定配送日数を計算する
 * @param {Address} destination - 配送先住所
 * @param {number} weight - 荷物の重量（kg）
 * @returns {{ cost: number, estimatedDays: number }} 配送料金と推定日数
 */
```

---
_🤖 Claude Code Review - documentation-accuracy-reviewer_
```
