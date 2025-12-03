param(
    [switch]$NoPipUpgrade
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

$venv = Join-Path $root '.venv'
if (-not (Test-Path $venv)) {
    python -m venv $venv
}

$activate = Join-Path $venv 'Scripts/Activate.ps1'
. $activate

if (-not $NoPipUpgrade) {
    python -m pip install --upgrade pip
}
python -m pip install -r requirements.txt

Write-Host "Environment ready. Activate with: .\\.venv\\Scripts\\Activate.ps1"
