#!/bin/bash
# Stop: 未発話のメッセージを発話（最終発話なのでロック待機あり）

# デバッグログ
DEBUG_LOG="/tmp/vibestudio/debug_stop.log"
mkdir -p /tmp/vibestudio
echo "=== on_stop.sh called at $(date) ===" >> "$DEBUG_LOG"

INPUT=$(cat)
echo "INPUT: $INPUT" >> "$DEBUG_LOG"
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')
echo "SESSION_ID: $SESSION_ID, TRANSCRIPT_PATH: $TRANSCRIPT_PATH" >> "$DEBUG_LOG"

# transcript_pathが無効なら終了
if [ -z "$TRANSCRIPT_PATH" ] || [ "$TRANSCRIPT_PATH" = "null" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
  echo "EXIT: invalid transcript_path" >> "$DEBUG_LOG"
  exit 0
fi

VIBESTUDIO_TMP="/tmp/vibestudio"
mkdir -p "$VIBESTUDIO_TMP"
LOCK_DIR="$VIBESTUDIO_TMP/lock_${SESSION_ID}.d"
LAST_TS_FILE="$VIBESTUDIO_TMP/last_timestamp_${SESSION_ID}"

# Stopは最終発話なので、ロックを待機して確実に実行する（最大3秒、100ms間隔でリトライ）
RETRY=0
while ! mkdir "$LOCK_DIR" 2>/dev/null; do
  RETRY=$((RETRY + 1))
  if [ $RETRY -gt 30 ]; then
    echo "EXIT: failed to acquire lock after 30 retries" >> "$DEBUG_LOG"
    exit 0
  fi
  sleep 0.1
done
trap 'rmdir "$LOCK_DIR" 2>/dev/null' EXIT
echo "Lock acquired after $RETRY retries" >> "$DEBUG_LOG"

# 以下、speak_assistant_messages.shと同じロジック（ロック取得済み前提）

# 前回発話したタイムスタンプを取得（なければ終了）
if [ ! -f "$LAST_TS_FILE" ]; then
  echo "EXIT: no last_ts_file" >> "$DEBUG_LOG"
  exit 0
fi

LAST_TS=$(cat "$LAST_TS_FILE")
echo "LAST_TS: $LAST_TS" >> "$DEBUG_LOG"

# assistantメッセージを抽出し、LAST_TS以降のものを取得
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

  # LAST_TSより新しいかチェック
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
  echo "Speaking: $TEXT" >> "$DEBUG_LOG"
  curl -s -X POST http://localhost:3000/api/speak \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg text "$TEXT" --arg sessionId "$SESSION_ID" \
      '{text: $text, speaker: "assistant", sessionId: $sessionId}')" \
    >/dev/null 2>&1 || true

  LATEST_TS="$TS"
done < "$TRANSCRIPT_PATH"

echo "Finished loop. LATEST_TS: $LATEST_TS" >> "$DEBUG_LOG"

# 最新のタイムスタンプを記録
if [ -n "$LATEST_TS" ]; then
  echo "$LATEST_TS" > "$LAST_TS_FILE"
fi

echo "=== on_stop.sh done ===" >> "$DEBUG_LOG"
exit 0
