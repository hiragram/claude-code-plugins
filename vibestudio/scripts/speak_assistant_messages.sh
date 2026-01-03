#!/bin/bash
# 共通: 未発話のassistantメッセージを発話サーバーに送信
# 最後に発話したタイムスタンプ以降のassistantメッセージをすべて発話する

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')

# transcript_pathが無効なら終了
if [ -z "$TRANSCRIPT_PATH" ] || [ "$TRANSCRIPT_PATH" = "null" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
  exit 0
fi

# タイムスタンプ管理用ディレクトリとファイル
VIBESTUDIO_TMP="/tmp/vibestudio"
mkdir -p "$VIBESTUDIO_TMP"
LAST_TS_FILE="$VIBESTUDIO_TMP/last_timestamp_${SESSION_ID}"
LOCK_DIR="$VIBESTUDIO_TMP/lock_${SESSION_ID}.d"

# 排他制御: 既に別のプロセスが処理中なら即終了
if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  exit 0
fi
trap 'rmdir "$LOCK_DIR" 2>/dev/null' EXIT

# 前回発話したタイムスタンプを取得（なければ現在時刻を記録して終了）
if [ ! -f "$LAST_TS_FILE" ]; then
  # 初回は最新のassistantメッセージのタイムスタンプを記録するだけ
  LATEST_TS=$(tail -r "$TRANSCRIPT_PATH" | while IFS= read -r line; do
    ROLE=$(echo "$line" | jq -r '.message.role // empty' 2>/dev/null)
    if [ "$ROLE" = "assistant" ]; then
      TS=$(echo "$line" | jq -r '.timestamp // empty' 2>/dev/null)
      if [ -n "$TS" ]; then
        echo "$TS"
        break
      fi
    fi
  done)
  if [ -n "$LATEST_TS" ]; then
    echo "$LATEST_TS" > "$LAST_TS_FILE"
  fi
  exit 0
fi

LAST_TS=$(cat "$LAST_TS_FILE")

# assistantメッセージを抽出し、LAST_TS以降のものを取得
# 各行を処理して、発話すべきメッセージを収集
LATEST_TS=""
while IFS= read -r line; do
  ROLE=$(echo "$line" | jq -r '.message.role // empty' 2>/dev/null)
  if [ "$ROLE" != "assistant" ]; then
    continue
  fi

  TS=$(echo "$line" | jq -r '.timestamp // empty' 2>/dev/null)
  if [ -z "$TS" ]; then
    continue
  fi

  # LAST_TSより新しいかチェック（文字列比較でISO8601は正しく比較できる）
  if [ -n "$LAST_TS" ] && [ "$TS" \< "$LAST_TS" ] || [ "$TS" = "$LAST_TS" ]; then
    continue
  fi

  # syntheticメッセージ（システム生成）はスキップ
  MODEL=$(echo "$line" | jq -r '.message.model // empty' 2>/dev/null)
  if [ "$MODEL" = "<synthetic>" ]; then
    continue
  fi

  # テキストを取得
  TEXT=$(echo "$line" | jq -r '.message.content[]? | select(.type == "text") | .text' 2>/dev/null)
  if [ -z "$TEXT" ]; then
    continue
  fi

  # 発話リクエスト送信
  curl -s -X POST http://localhost:3000/api/speak \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg text "$TEXT" --arg sessionId "$SESSION_ID" \
      '{text: $text, speaker: "assistant", sessionId: $sessionId}')" \
    >/dev/null 2>&1 || true

  # 最新のタイムスタンプを更新
  LATEST_TS="$TS"
done < "$TRANSCRIPT_PATH"

# 最新のタイムスタンプを記録
if [ -n "$LATEST_TS" ]; then
  echo "$LATEST_TS" > "$LAST_TS_FILE"
fi

exit 0
