Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

python -m venv .venv
.venv\Scripts\Activate.ps1
.venv\Scripts\python -m pip install --upgrade pip
.venv\Scripts\python -m pip install -r requirements.txt
Write-Host "Setup complete. Activate with: . .venv\Scripts\Activate.ps1"
