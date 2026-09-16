#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
source .venv/bin/activate
python -m src.pipeline --source both --input-dir data/incremental/day_2026-07-01 --refresh-mart
