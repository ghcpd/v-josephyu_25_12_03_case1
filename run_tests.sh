#!/usr/bin/env bash
set -euo pipefail

if [ -d .venv ]; then
  . .venv/bin/activate
  python -m pytest -q
else
  echo ".venv not found — creating one now"
  python3 -m venv .venv
  . .venv/bin/activate
  python -m pip install --upgrade pip
  pip install -r requirements.txt
  python -m pytest -q
fi
