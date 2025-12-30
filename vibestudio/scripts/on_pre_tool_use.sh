#!/bin/bash
# PreToolUse: 共通スクリプトを呼び出して未発話のassistantメッセージを発話
SCRIPT_DIR="$(dirname "$0")"
cat | "$SCRIPT_DIR/speak_assistant_messages.sh"
