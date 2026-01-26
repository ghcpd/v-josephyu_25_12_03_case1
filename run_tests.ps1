Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (Test-Path '.venv') {
    . .venv\Scripts\Activate.ps1
    .venv\Scripts\python -m pytest -q
} else {
    python -m venv .venv
    . .venv\Scripts\Activate.ps1
    .venv\Scripts\python -m pip install --upgrade pip
    .venv\Scripts\python -m pip install -r requirements.txt
    .venv\Scripts\python -m pytest -q
}
