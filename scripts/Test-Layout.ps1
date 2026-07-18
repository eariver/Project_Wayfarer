[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$errors = New-Object System.Collections.Generic.List[string]

$required = @(
    'AGENTS.md','.gitignore','.env.example','versions.yml','plugin-manifest.yml',
    'velocity','servers/lobby','servers/main','servers/frontier','infrastructure','docs'
)
foreach ($relative in $required) {
    if (-not (Test-Path (Join-Path $Root $relative))) { $errors.Add("Missing: $relative") }
}

$forbidden = Get-ChildItem -Path $Root -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match 'ViaBackwards' }
if ($forbidden) { $errors.Add('ViaBackwards reference or file found: ' + ($forbidden.FullName -join ', ')) }

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}
Write-Host 'Repository layout checks passed.'
