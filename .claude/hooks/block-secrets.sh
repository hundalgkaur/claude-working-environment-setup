#!/bin/bash
INPUT=$(cat)
if printf '%s' "$INPUT" | grep -qE '(-----BEGIN [A-Z ]*PRIVATE KEY-----|AKIA[0-9A-Z]{16}|(API_KEY|SECRET|TOKEN|PASSWORD)[[:space:]]*[:=][[:space:]]*"?[A-Za-z0-9_-]{16,})'; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"AIOS: payload looks like a secret. Use .env (gitignored) instead."}}'
  exit 2
fi
exit 0
