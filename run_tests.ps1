param(
    [string[]]$PytestArgs
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

$venv = Join-Path $root '.venv'
if (Test-Path $venv) {
    . (Join-Path $venv 'Scripts/Activate.ps1')
}

python -m pytest -q test_files @PytestArgs
