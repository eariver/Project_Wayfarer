[CmdletBinding()]
param(
    [switch]$SkipInfrastructure
)

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

if (-not $SkipInfrastructure) {
    & docker compose --env-file (Join-Path $Root '.env') -f (Join-Path $Root 'infrastructure/compose.yml') up -d
}

$order = @('lobby','main','frontier','velocity')
foreach ($name in $order) {
    $arg = "-NoExit -ExecutionPolicy Bypass -File `"$PSScriptRoot/Start-Component.ps1`" -Name $name"
    Start-Process powershell.exe -ArgumentList $arg -WorkingDirectory $Root
    Start-Sleep -Seconds 3
}

Write-Host 'Processes launched. Inspect each console and latest.log; launch is not proof of successful initialization.'
