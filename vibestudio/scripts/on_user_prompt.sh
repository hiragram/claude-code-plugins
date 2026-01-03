#!/bin/bash
# UserPromptSubmit: ユーザーの入力を発話サーバーに送信

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
PROMPT=$(echo "$INPUT" | jq -r '.prompt')

# promptが空なら終了
if [ -z "$PROMPT" ] || [ "$PROMPT" = "null" ]; then
  exit 0
fi

# 発話リクエスト送信（失敗しても無視）
curl -s -X POST http://localhost:3000/api/speak \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg text "$PROMPT" --arg sessionId "$SESSION_ID" \
    '{text: $text, speaker: "user", sessionId: $sessionId}')" \
  >/dev/null 2>&1 || true

exit 0
