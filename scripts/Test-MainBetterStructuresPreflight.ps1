[CmdletBinding()]
param(
    [string]$WorkRoot = 'local/work/main-betterstructures-v006'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$tool = Join-Path $PSScriptRoot 'main_betterstructures_tools.py'

Push-Location $root
try {
    & python $tool 'verify' '--work-root' $WorkRoot
    if ($LASTEXITCODE -ne 0) {
        throw "Main BetterStructures preflight failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}
