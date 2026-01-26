---
name: smoke-test
description: OkumukaUITestsを実行してアプリの基本機能を検証するスキル。xcodebuildでXCUITestを実行し、結果を報告する。使用シーン：(1)「動作確認して」「QAして」などの検証リクエスト (2)「スモークテストを実行して」などの明示的な指示 (3) 機能実装後の基本動作確認 (4) リリース前の最終確認
user-invocable: true
---

# Smoke Test

XCUITest（OkumukaUITests）を実行してアプリの基本機能を検証するスキル。

## 概要

xcodebuildを使ってOkumukaUITestsターゲットのテストを実行し、結果を報告する。

## 前提条件

1. **シミュレータ**: SmokeTest1という名前のシミュレータが存在すること
2. **iCloud**: シミュレータでiCloudにサインイン済みであること
3. **アプリ状態**: オンボーディング完了済み（グループが1つ以上存在）

## 実行手順

### 1. シミュレータ確認

```
list_simulatorsでSmokeTest1の存在とUDIDを確認。
見つからない場合はユーザーにエラー報告して終了。
```

### 2. UIテスト実行

```bash
xcodebuild test \
  -project Okumuka.xcodeproj \
  -scheme Okumuka \
  -destination "platform=iOS Simulator,id={SmokeTest1のUDID}" \
  -only-testing:OkumukaUITests \
  2>&1 | tail -100
```

**ポイント**:
- `-only-testing:OkumukaUITests` でUIテストターゲットのみを実行
- 出力が長いので `tail -100` で最後の100行を取得
- タイムアウトは十分に長く設定（5分程度）

### 3. 結果報告

xcodebuildの出力から結果をパースし、以下の形式で報告:

```
## UIテスト結果

**結果**: TEST SUCCEEDED / TEST FAILED

### 実行されたテスト
- OkumukaUITests.testOpenSettingsFromHome: Pass/Fail (X.XX秒)
- （他のテストがあれば追加）

### 詳細
（失敗時はエラー内容を記載）
```

## トラブルシューティング

### SmokeTest1が見つからない

ユーザーに以下を報告:
```
SmokeTest1シミュレータが見つかりません。
Xcodeでシミュレータを作成してください。
```

### テストが失敗する

1. iCloudにサインインしているか確認
2. アプリのオンボーディングが完了しているか確認
3. xcodebuildの詳細なエラーメッセージをユーザーに報告
