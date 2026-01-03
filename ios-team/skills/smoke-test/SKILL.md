---
name: smoke-test
description: iOSアプリの基本機能をスモークテストで検証するスキル。iossim MCPを使ってUI操作を自動実行し、主要機能が動作することを確認する。使用シーン：(1)「動作確認して」「QAして」などの検証リクエスト (2)「スモークテストを実行して」などの明示的な指示 (3) 機能実装後の基本動作確認 (4) リリース前の最終確認
---

# Smoke Test

iOSアプリの基本機能が正常に動作することを自動検証するスキル。

## 概要

スモークテストは、アプリの主要機能が「煙を出さずに」動作することを確認する最小限のテスト。以下を検証する:

- 主要画面の表示
- 基本的なUI操作（タップ、画面遷移）
- 重要なボタン・要素の存在

## 前提条件

1. **シミュレータ**: 起動済み
2. **アプリ**: インストール・起動済み
3. **状態**: ホーム画面表示状態（グループが1つ以上存在）

## 実行手順

### 1. 環境確認

```
1. list_simulatorsでシミュレータ状態を確認
2. take_screenshotで現在の画面を確認
3. ホーム画面でない場合は、ユーザーに状態を報告
```

### 2. テスト実行

以下のシナリオを順番に実行:

#### シナリオ1: ホーム画面の基本操作

```json
{
  "actions": [
    {"type": "assertExists", "target": {"type": "identifier", "value": "home_button_enterSchedule"}},
    {"type": "assertExists", "target": {"type": "identifier", "value": "home_button_settings"}},
    {"type": "assertExists", "target": {"type": "identifier", "value": "home_menu_groupSelector"}}
  ]
}
```

**検証内容**: 予定入力ボタン、設定ボタン、グループセレクタが存在すること

#### シナリオ2: スケジュール入力フロー

```json
{
  "actions": [
    {"type": "tap", "target": {"type": "identifier", "value": "home_button_enterSchedule"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "weeklySchedule_button_submit"}, "timeout": 5},
    {"type": "assertExists", "target": {"type": "identifier", "value": "weeklySchedule_button_dropOff_day0"}},
    {"type": "tap", "target": {"type": "identifier", "value": "weeklySchedule_button_submit"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "home_button_enterSchedule"}, "timeout": 10}
  ]
}
```

**検証内容**: スケジュール画面を開いて閉じることができること

#### シナリオ3: 設定画面アクセス

```json
{
  "actions": [
    {"type": "tap", "target": {"type": "identifier", "value": "home_button_settings"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "settings_button_done"}, "timeout": 5},
    {"type": "assertExists", "target": {"type": "identifier", "value": "settings_button_weekdaySettings"}},
    {"type": "assertExists", "target": {"type": "identifier", "value": "settings_button_addLocation"}},
    {"type": "tap", "target": {"type": "identifier", "value": "settings_button_done"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "home_button_enterSchedule"}, "timeout": 5}
  ]
}
```

**検証内容**: 設定画面を開き、主要項目が存在し、閉じることができること

#### シナリオ4: グループセレクタ動作

```json
{
  "actions": [
    {"type": "tap", "target": {"type": "identifier", "value": "home_menu_groupSelector"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "home_menu_createGroup"}, "timeout": 3}
  ]
}
```

**検証内容**: グループセレクタをタップすると新規グループ作成オプションが表示されること

### 3. 結果報告

全シナリオ実行後、以下の形式で報告:

```
## スモークテスト結果

| シナリオ | 結果 |
|---------|------|
| ホーム画面の基本操作 | ✅ Pass / ❌ Fail |
| スケジュール入力フロー | ✅ Pass / ❌ Fail |
| 設定画面アクセス | ✅ Pass / ❌ Fail |
| グループセレクタ動作 | ✅ Pass / ❌ Fail |

**総合結果**: X/4 シナリオ成功
```

## 使用するMCPツール

| ツール | 用途 |
|-------|------|
| `mcp__plugin_ios-team_iossim__list_simulators` | シミュレータ状態確認 |
| `mcp__plugin_ios-team_iossim__take_screenshot` | 画面状態確認 |
| `mcp__plugin_ios-team_iossim__run_ui_script` | UIスクリプト実行 |

## bundleId

```
app.hiragram.Okumuka
```

## トラブルシューティング

### シミュレータが見つからない

```
list_simulatorsで起動中のシミュレータを確認。
Bootedのシミュレータがない場合は、boot_simulatorで起動。
```

### アプリが起動していない

```
launch_appでアプリを起動:
bundleId: app.hiragram.Okumuka
```

### 要素が見つからない

1. `take_screenshot`で現在の画面を確認
2. 想定と異なる画面の場合、ユーザーに報告
3. モーダルやアラートが表示されている場合は閉じてから再試行

## 詳細シナリオ

より詳細なテストシナリオは `references/test-scenarios.md` を参照。
