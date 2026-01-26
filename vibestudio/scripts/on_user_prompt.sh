#!/bin/bash
# UserPromptSubmit: 未発話メッセージを発話サーバーに送信
SCRIPT_DIR="$(dirname "$0")"
cat | "$SCRIPT_DIR/speak_assistant_messages.sh"
