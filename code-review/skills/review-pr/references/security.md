# セキュリティレビュー観点

security-code-reviewer エージェントが確認する観点の詳細ドキュメント。

## レビュー対象

### 1. OWASP Top 10 脆弱性

#### A01: アクセス制御の不備
- 認可チェックが適切に行われているか
- 他ユーザーのリソースにアクセスできないか（IDOR）
- 管理者機能が適切に保護されているか

**問題例**:
```javascript
// ❌ 認可チェックなし
app.get('/api/users/:id', (req, res) => {
  const user = await User.findById(req.params.id);
  res.json(user); // 誰でも任意のユーザー情報を取得可能
});

// ✅ 認可チェックあり
app.get('/api/users/:id', authenticate, (req, res) => {
  if (req.user.id !== req.params.id && !req.user.isAdmin) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  const user = await User.findById(req.params.id);
  res.json(user);
});
```

#### A02: 暗号化の失敗
- 機密データが適切に暗号化されているか
- 安全でないハッシュアルゴリズム（MD5, SHA1）を使用していないか
- 暗号鍵がハードコードされていないか

#### A03: インジェクション
- SQLインジェクション対策がされているか
- コマンドインジェクション対策がされているか
- NoSQLインジェクション対策がされているか

**問題例**:
```javascript
// ❌ SQLインジェクション脆弱性
const query = `SELECT * FROM users WHERE id = '${userId}'`;
db.query(query);

// ✅ プリペアドステートメント
db.query('SELECT * FROM users WHERE id = ?', [userId]);
```

### 2. 入力検証

- すべてのユーザー入力が検証されているか
- サーバーサイドでの検証が行われているか（クライアントサイドのみは不可）
- ホワイトリスト方式で検証しているか

**検証すべき項目**:
- 文字列の長さ
- 文字種（英数字のみ、など）
- 形式（メールアドレス、URL、など）
- 範囲（数値の最小値・最大値）

**問題例**:
```javascript
// ❌ 検証なし
app.post('/api/users', (req, res) => {
  const user = new User(req.body); // 任意のフィールドを設定可能
  await user.save();
});

// ✅ 入力検証あり
app.post('/api/users', (req, res) => {
  const { name, email } = req.body;

  if (!name || name.length > 100) {
    return res.status(400).json({ error: 'Invalid name' });
  }
  if (!isValidEmail(email)) {
    return res.status(400).json({ error: 'Invalid email' });
  }

  const user = new User({ name, email });
  await user.save();
});
```

### 3. 認証・認可

- パスワードが適切にハッシュ化されているか（bcrypt, Argon2）
- セッション管理が安全か
- JWTが適切に使用されているか
- 多要素認証が必要な機能で実装されているか

**問題例**:
```javascript
// ❌ パスワードを平文で保存
user.password = req.body.password;

// ✅ bcryptでハッシュ化
user.password = await bcrypt.hash(req.body.password, 12);
```

### 4. 機密情報のハードコード

- APIキーがコードにハードコードされていないか
- パスワードがコードに含まれていないか
- 秘密鍵がコミットされていないか

**問題例**:
```javascript
// ❌ ハードコードされたシークレット
const API_KEY = 'sk-1234567890abcdef';
const DATABASE_URL = 'postgres://user:password@host:5432/db';

// ✅ 環境変数から取得
const API_KEY = process.env.API_KEY;
const DATABASE_URL = process.env.DATABASE_URL;
```

### 5. XSS (クロスサイトスクリプティング)

- ユーザー入力がHTMLとして出力される際にエスケープされているか
- `dangerouslySetInnerHTML` (React) の使用が適切か
- Content-Security-Policy が設定されているか

**問題例**:
```javascript
// ❌ XSS脆弱性
app.get('/search', (req, res) => {
  res.send(`<h1>Results for: ${req.query.q}</h1>`);
});

// ✅ エスケープ処理
app.get('/search', (req, res) => {
  const escaped = escapeHtml(req.query.q);
  res.send(`<h1>Results for: ${escaped}</h1>`);
});
```

### 6. ログへの機密情報出力

- パスワードがログに出力されていないか
- クレジットカード番号がログに含まれていないか
- 個人情報（PII）がログに出力されていないか

**問題例**:
```javascript
// ❌ パスワードをログ出力
logger.info('User login attempt', { email, password });

// ✅ 機密情報を除外
logger.info('User login attempt', { email });
```

### 7. 依存ライブラリの脆弱性

- 既知の脆弱性を持つライブラリを使用していないか
- `npm audit` / `pip audit` 等の結果を確認
- 古いバージョンのライブラリを使用していないか

### 8. CSRF対策

- 状態変更を伴うリクエストにCSRFトークンがあるか
- SameSite Cookie属性が設定されているか

### 9. ファイルアップロードの安全性

- ファイルタイプが適切に検証されているか
- ファイルサイズの制限があるか
- アップロードファイルが実行されないか

## 重大度の分類

| 重大度 | 例 |
|--------|---|
| Critical | RCE（リモートコード実行）、SQLインジェクション |
| High | 認証バイパス、機密情報漏洩 |
| Medium | XSS、CSRF、セッション固定 |
| Low | 情報漏洩（エラーメッセージ等） |

## 指摘しない項目

- 推測に基づくセキュリティ懸念（証拠なし）
- 既存コードのセキュリティ問題（PRで変更されていない部分）
- セキュリティと関係のないコード品質の問題

## インラインコメント例

```markdown
## 🔍 セキュリティ

**問題**: ユーザー入力 `req.body.email` がサニタイズなしでデータベースクエリに使用されています。これはNoSQLインジェクションの脆弱性につながる可能性があります。

**影響**: 攻撃者が `{"$gt": ""}` のような値を送信することで、認証をバイパスしたり、不正なデータアクセスが可能になります。

**提案**: 入力を文字列型に強制するか、バリデーションライブラリを使用してください。

```suggestion
const email = String(req.body.email);
if (!isValidEmail(email)) {
  return res.status(400).json({ error: 'Invalid email format' });
}
const user = await User.findOne({ email });
```

---
_🤖 Claude Code Review - security-code-reviewer_
```
