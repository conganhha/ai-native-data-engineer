#!/usr/bin/env bash
set +e
echo "=== AI-Native DE macOS Preflight ==="
for cmd in brew git python3.11 docker code; do
  printf "%-12s" "$cmd"
  command -v "$cmd" >/dev/null && echo "OK: $($cmd --version 2>/dev/null | head -1)" || echo "MISSING"
done
docker compose version 2>/dev/null || true
echo "DBeaver: kiểm tra trong Applications hoặc chạy: brew list --cask dbeaver-community"
