#!/bin/bash
# SessionStart: タイムスタンプファイルを初期化（最新のassistantメッセージのタイムスタンプを記録）

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')

VIBESTUDIO_TMP="/tmp/vibestudio"
mkdir -p "$VIBESTUDIO_TMP"
LAST_TS_FILE="$VIBESTUDIO_TMP/last_timestamp_${SESSION_ID}"

# transcript_pathが無効でもタイムスタンプファイルは初期化する
if [ -z "$TRANSCRIPT_PATH" ] || [ "$TRANSCRIPT_PATH" = "null" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
  echo "1970-01-01T00:00:00.000Z" > "$LAST_TS_FILE"
  exit 0
fi

# 既にタイムスタンプファイルがあれば何もしない
if [ -f "$LAST_TS_FILE" ]; then
  exit 0
fi

# 最新のassistantメッセージのタイムスタンプを記録
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
else
  # 新規セッション（assistantメッセージがまだない）場合は現在時刻を設定
  date -u +"%Y-%m-%dT%H:%M:%S.000Z" > "$LAST_TS_FILE"
fi

exit 0
