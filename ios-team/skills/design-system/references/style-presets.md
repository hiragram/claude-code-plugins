# スタイルプリセット

アプリの世界観・コンセプトに合わせたデザインシステムを構築するためのプリセット集。

## 目次

1. [ミニマル/モダン](#ミニマルモダン)
2. [ポップ/カジュアル](#ポップカジュアル)
3. [高級/プレミアム](#高級プレミアム)
4. [ナチュラル/オーガニック](#ナチュラルオーガニック)
5. [ダーク/テック](#ダークテック)
6. [フレンドリー/ソフト](#フレンドリーソフト)
7. [ビジネス/プロフェッショナル](#ビジネスプロフェッショナル)
8. [レトロ/ヴィンテージ](#レトロヴィンテージ)

---

## ミニマル/モダン

**キーワード**: シンプル、洗練、余白、クリーン

### カラーパレット
```swift
// Brand
static let primaryBrand = Color(hex: "000000")      // ピュアブラック
static let secondaryBrand = Color(hex: "6B6B6B")    // ミディアムグレー

// Background
static let backgroundPrimary = Color(hex: "FFFFFF")
static let backgroundSecondary = Color(hex: "F8F8F8")
static let backgroundTertiary = Color(hex: "F0F0F0")

// Accent（ワンポイント）
static let accent = Color(hex: "0066FF")            // ブルー or
static let accent = Color(hex: "FF3366")            // レッド
```

### タイポグラフィ
- **フォント**: SF Pro（システム）、Helvetica Neue
- **特徴**: 細いウェイト（Light/Regular）を多用、大きな余白

### 特徴
- 角丸: 小さめ (4-8pt) または 0
- シャドウ: 控えめまたはなし
- アイコン: 線画（アウトライン）スタイル

---

## ポップ/カジュアル

**キーワード**: 楽しい、明るい、親しみやすい、カラフル

### カラーパレット
```swift
// Brand
static let primaryBrand = Color(hex: "FF6B6B")      // コーラルレッド
static let secondaryBrand = Color(hex: "4ECDC4")    // ターコイズ

// Background
static let backgroundPrimary = Color(hex: "FFFFFF")
static let backgroundSecondary = Color(hex: "FFF9F0") // ウォームホワイト
static let backgroundTertiary = Color(hex: "F0F7FF")  // クールホワイト

// Accent Colors（複数使用OK）
static let accentYellow = Color(hex: "FFE66D")
static let accentPurple = Color(hex: "9B5DE5")
static let accentGreen = Color(hex: "00F5D4")
```

### タイポグラフィ
- **フォント**: SF Pro Rounded、Nunito、Quicksand
- **特徴**: Rounded体、Bold多用、遊び心のあるサイズ変化

### 特徴
- 角丸: 大きめ (12-24pt)
- シャドウ: カラフルなドロップシャドウも可
- アイコン: 塗りつぶし、イラスト風

---

## 高級/プレミアム

**キーワード**: エレガント、洗練、上質、重厚感

### カラーパレット
```swift
// Brand
static let primaryBrand = Color(hex: "1A1A2E")      // ディープネイビー
static let secondaryBrand = Color(hex: "C9A962")    // ゴールド

// Background
static let backgroundPrimary = Color(hex: "FAFAFA")
static let backgroundSecondary = Color(hex: "F5F5F5")
static let backgroundTertiary = Color(hex: "EFEFEF")

// Dark Mode (プレミアム感を出しやすい)
static let backgroundPrimaryDark = Color(hex: "0D0D0D")
static let backgroundSecondaryDark = Color(hex: "1A1A1A")
```

### タイポグラフィ
- **フォント**: SF Pro、Playfair Display（見出し）、Didot
- **特徴**: セリフ体を見出しに、細いウェイト、レタースペーシング広め

### 特徴
- 角丸: 小さめ (4-8pt) または 0（シャープ）
- シャドウ: 繊細で深い影
- アイコン: 細い線、優雅な曲線

---

## ナチュラル/オーガニック

**キーワード**: 自然、健康、温かみ、サステナブル

### カラーパレット
```swift
// Brand
static let primaryBrand = Color(hex: "2D5A27")      // フォレストグリーン
static let secondaryBrand = Color(hex: "8B7355")    // アースブラウン

// Background
static let backgroundPrimary = Color(hex: "FFFEF7") // クリームホワイト
static let backgroundSecondary = Color(hex: "F5F1E8") // ベージュ
static let backgroundTertiary = Color(hex: "EBE5D9")

// Accent
static let accentTerracotta = Color(hex: "C67B5C")  // テラコッタ
static let accentSage = Color(hex: "9CAF88")        // セージグリーン
```

### タイポグラフィ
- **フォント**: SF Pro、Lora（見出し）、Source Serif
- **特徴**: 温かみのあるセリフ体、自然な行間

### 特徴
- 角丸: 中程度 (8-12pt)、有機的な形状
- シャドウ: ソフトで温かい影
- アイコン: 手描き風、自然モチーフ

---

## ダーク/テック

**キーワード**: 先進的、クール、サイバー、プロフェッショナル

### カラーパレット
```swift
// Brand
static let primaryBrand = Color(hex: "00D9FF")      // サイバーシアン
static let secondaryBrand = Color(hex: "BD00FF")    // ネオンパープル

// Background
static let backgroundPrimary = Color(hex: "0A0A0F")
static let backgroundSecondary = Color(hex: "12121A")
static let backgroundTertiary = Color(hex: "1A1A25")

// Accent
static let accentGreen = Color(hex: "00FF88")       // マトリックスグリーン
static let accentOrange = Color(hex: "FF6B00")      // テックオレンジ
```

### タイポグラフィ
- **フォント**: SF Mono、Inter、JetBrains Mono
- **特徴**: モノスペース、シャープ、未来的

### 特徴
- 角丸: 小さめ (4-6pt)
- シャドウ: グロー効果（ネオン風）
- アイコン: シャープ、幾何学的

---

## フレンドリー/ソフト

**キーワード**: 優しい、安心、親近感、ヘルスケア

### カラーパレット
```swift
// Brand
static let primaryBrand = Color(hex: "6B8EAE")      // ソフトブルー
static let secondaryBrand = Color(hex: "A8D5BA")    // ミントグリーン

// Background
static let backgroundPrimary = Color(hex: "FFFFFF")
static let backgroundSecondary = Color(hex: "F7FAFC")
static let backgroundTertiary = Color(hex: "EDF2F7")

// Accent
static let accentPeach = Color(hex: "FFDAB9")
static let accentLavender = Color(hex: "E6E6FA")
```

### タイポグラフィ
- **フォント**: SF Pro Rounded、Poppins、Nunito
- **特徴**: 丸みのある書体、適度なウェイト

### 特徴
- 角丸: 大きめ (12-20pt)
- シャドウ: 非常にソフト
- アイコン: 丸みを帯びた、フレンドリーな形状

---

## ビジネス/プロフェッショナル

**キーワード**: 信頼、堅実、効率、B2B

### カラーパレット
```swift
// Brand
static let primaryBrand = Color(hex: "1E3A5F")      // ネイビーブルー
static let secondaryBrand = Color(hex: "3D7EA6")    // コーポレートブルー

// Background
static let backgroundPrimary = Color(hex: "FFFFFF")
static let backgroundSecondary = Color(hex: "F4F6F8")
static let backgroundTertiary = Color(hex: "E8ECEF")

// Accent
static let accentSuccess = Color(hex: "28A745")
static let accentWarning = Color(hex: "FFC107")
```

### タイポグラフィ
- **フォント**: SF Pro、Inter、Roboto
- **特徴**: クリーン、可読性重視、適度なコントラスト

### 特徴
- 角丸: 控えめ (6-8pt)
- シャドウ: 機能的、控えめ
- アイコン: 明確、普遍的なシンボル

---

## レトロ/ヴィンテージ

**キーワード**: ノスタルジック、クラシック、温故知新

### カラーパレット
```swift
// Brand
static let primaryBrand = Color(hex: "D35400")      // レトロオレンジ
static let secondaryBrand = Color(hex: "2C3E50")    // ヴィンテージネイビー

// Background
static let backgroundPrimary = Color(hex: "FDF6E3") // セピア調ホワイト
static let backgroundSecondary = Color(hex: "F5E6D3")
static let backgroundTertiary = Color(hex: "EED9C4")

// Accent
static let accentMustard = Color(hex: "C9A227")
static let accentTeal = Color(hex: "008080")
```

### タイポグラフィ
- **フォント**: SF Pro、Courier、American Typewriter
- **特徴**: セリフ体、タイプライター風、クラシックな書体

### 特徴
- 角丸: 小さめまたはなし
- シャドウ: 控えめ、クラシックなドロップシャドウ
- アイコン: レトロ、手描き風

---

## プリセット選択ガイド

| アプリの種類 | 推奨プリセット |
|-------------|---------------|
| タスク管理、生産性 | ミニマル/モダン、ビジネス |
| SNS、エンタメ | ポップ/カジュアル、フレンドリー |
| EC（高級品） | 高級/プレミアム |
| 健康、フィットネス | ナチュラル、フレンドリー |
| フィンテック | ビジネス、ダーク/テック |
| ゲーム、テック系 | ダーク/テック、ポップ |
| 食品、オーガニック | ナチュラル/オーガニック |
| カフェ、ライフスタイル | レトロ、ナチュラル |

---

## カスタマイズのヒント

プリセットはあくまで出発点。以下の調整でオリジナリティを出す：

1. **プライマリカラーの微調整**: 色相を±10°動かすだけで印象が変わる
2. **アクセントカラーの追加**: ブランドカラーに合わせた差し色
3. **背景色の温度調整**: 暖色寄り（#FFFAF0）か寒色寄り（#F0F8FF）か
4. **フォントの組み合わせ**: 見出しと本文で異なるフォントファミリーを使用
