[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
& docker compose --env-file (Join-Path $Root '.env') -f (Join-Path $Root 'infrastructure/compose.yml') config --quiet
& docker compose --env-file (Join-Path $Root '.env') -f (Join-Path $Root 'infrastructure/compose.yml') ps
