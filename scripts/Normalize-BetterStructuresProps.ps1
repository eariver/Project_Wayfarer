[CmdletBinding()]
param(
    [string]$WorkRoot = 'local/work/main-betterstructures-v006',
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$tool = Join-Path $PSScriptRoot 'main_betterstructures_tools.py'
$arguments = @($tool, 'normalize', '--work-root', $WorkRoot)
if ($DryRun) { $arguments += '--dry-run' }

Push-Location $root
try {
    & python @arguments
    if ($LASTEXITCODE -ne 0) {
        throw "BetterStructures prop normalization failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}
