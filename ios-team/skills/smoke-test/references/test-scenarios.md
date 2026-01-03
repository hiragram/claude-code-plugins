# テストシナリオ詳細

スモークテストで使用するUIスクリプトの詳細定義。

## アクションタイプ

| タイプ | 説明 | パラメータ |
|-------|------|-----------|
| `tap` | タップ | target |
| `doubleTap` | ダブルタップ | target |
| `typeText` | テキスト入力 | target, text |
| `swipe` | スワイプ | target, direction |
| `longPress` | 長押し | target, duration |
| `waitForElement` | 要素待機 | target, timeout |
| `assertExists` | 存在確認 | target |
| `getElementValue` | 値取得 | target |

## target指定方法

```json
// accessibilityIdentifierで指定（推奨）
{ "type": "identifier", "value": "home_button_settings" }

// ラベルで指定
{ "type": "label", "value": "設定" }
```

## フルスモークテスト

全シナリオを一括実行するスクリプト:

```json
{
  "actions": [
    {"type": "assertExists", "target": {"type": "identifier", "value": "home_button_enterSchedule"}},
    {"type": "assertExists", "target": {"type": "identifier", "value": "home_button_settings"}},
    {"type": "tap", "target": {"type": "identifier", "value": "home_button_enterSchedule"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "weeklySchedule_button_submit"}, "timeout": 5},
    {"type": "tap", "target": {"type": "identifier", "value": "weeklySchedule_button_submit"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "home_button_enterSchedule"}, "timeout": 10},
    {"type": "tap", "target": {"type": "identifier", "value": "home_button_settings"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "settings_button_done"}, "timeout": 5},
    {"type": "tap", "target": {"type": "identifier", "value": "settings_button_done"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "home_button_enterSchedule"}, "timeout": 5}
  ]
}
```

## 主要なaccessibility identifier

### ホーム画面

| identifier | 説明 |
|-----------|------|
| `home_button_enterSchedule` | 予定入力ボタン |
| `home_button_settings` | 設定ボタン |
| `home_menu_groupSelector` | グループセレクタ |
| `home_menu_createGroup` | 新グループ作成 |

### スケジュール入力

| identifier | 説明 |
|-----------|------|
| `weeklySchedule_button_dropOff_day{0-6}` | 送りボタン（日別） |
| `weeklySchedule_button_pickUp_day{0-6}` | 迎えボタン（日別） |
| `weeklySchedule_button_submit` | 提出ボタン |

### 設定画面

| identifier | 説明 |
|-----------|------|
| `settings_button_done` | 完了 |
| `settings_button_weekdaySettings` | 曜日設定 |
| `settings_button_addLocation` | 地点追加 |
| `settings_button_inviteMember` | メンバー招待 |
| `settings_button_memberList` | メンバー一覧 |

## 拡張シナリオ（オプション）

### スケジュール入力操作

```json
{
  "description": "1日目の送り・迎えをOKに変更",
  "actions": [
    {"type": "tap", "target": {"type": "identifier", "value": "home_button_enterSchedule"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "weeklySchedule_button_submit"}, "timeout": 5},
    {"type": "tap", "target": {"type": "identifier", "value": "weeklySchedule_button_dropOff_day0"}},
    {"type": "tap", "target": {"type": "identifier", "value": "weeklySchedule_button_pickUp_day0"}},
    {"type": "tap", "target": {"type": "identifier", "value": "weeklySchedule_button_submit"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "home_button_enterSchedule"}, "timeout": 10}
  ]
}
```

### 天気地点追加画面

```json
{
  "description": "天気地点追加画面を開いて閉じる",
  "actions": [
    {"type": "tap", "target": {"type": "identifier", "value": "home_button_settings"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "settings_button_done"}, "timeout": 5},
    {"type": "tap", "target": {"type": "identifier", "value": "settings_button_addLocation"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "weatherLocationEdit_button_save"}, "timeout": 5},
    {"type": "tap", "target": {"type": "identifier", "value": "weatherLocationEdit_button_cancel"}},
    {"type": "tap", "target": {"type": "identifier", "value": "settings_button_done"}},
    {"type": "waitForElement", "target": {"type": "identifier", "value": "home_button_enterSchedule"}, "timeout": 5}
  ]
}
```
