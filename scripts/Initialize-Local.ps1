[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

$directories = @(
    'velocity/plugins',
    'servers/lobby/plugins',
    'servers/main/plugins',
    'servers/frontier/plugins',
    'infrastructure/data/mariadb',
    'infrastructure/data/redis',
    'backups',
    'local'
)

foreach ($relative in $directories) {
    $path = Join-Path $Root $relative
    New-Item -ItemType Directory -Force -Path $path | Out-Null
}

if (-not (Test-Path (Join-Path $Root '.env'))) {
    Write-Warning 'Copy .env.example to .env and replace all CHANGE_ME values.'
}
if (-not (Test-Path (Join-Path $Root 'local/paths.psd1'))) {
    Write-Warning 'Copy local/paths.psd1.example to local/paths.psd1 and set Java paths.'
}

Write-Host "Local directory layout initialized under $Root"
