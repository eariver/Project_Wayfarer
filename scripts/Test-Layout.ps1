[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$errors = New-Object System.Collections.Generic.List[string]

$required = @(
    'AGENTS.md','.gitignore','.env.example','versions.yml','plugin-manifest.yml',
    'velocity','servers/lobby','servers/main','servers/frontier','infrastructure','docs',
    'scripts/Render-mcMMOConfig.ps1',
    'servers/main/plugins/mcMMO/config.yml.template',
    'servers/frontier/plugins/mcMMO/config.yml.template'
)
foreach ($relative in $required) {
    if (-not (Test-Path (Join-Path $Root $relative))) { $errors.Add("Missing: $relative") }
}

$forbidden = Get-ChildItem -Path $Root -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match 'ViaBackwards' }
if ($forbidden) { $errors.Add('ViaBackwards reference or file found: ' + ($forbidden.FullName -join ', ')) }

$mcmmoTemplates = @(
    'servers/main/plugins/mcMMO/config.yml.template',
    'servers/frontier/plugins/mcMMO/config.yml.template'
)
$mcmmoTokens = @(
    '__WAYFARER_MARIADB_USER__',
    '__WAYFARER_MARIADB_PASSWORD__',
    '__WAYFARER_MARIADB_PORT__'
)
foreach ($relative in $mcmmoTemplates) {
    $path = Join-Path $Root $relative
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { continue }

    $content = [IO.File]::ReadAllText($path)
    foreach ($token in $mcmmoTokens) {
        $count = [regex]::Matches($content, [regex]::Escape($token)).Count
        if ($count -ne 1) { $errors.Add("Expected one $token in $relative; found $count.") }
    }
    if ($content -notmatch '(?ms)^MySQL:\r?\n    Enabled: true\r?\n.*?^        Name: wayfarer_mcmmo\r?$') {
        $errors.Add("mcMMO database selection is invalid in $relative.")
    }
    if ($content -notmatch '(?m)^        TablePrefix: mcmmo_\r?$') {
        $errors.Add("mcMMO table prefix is invalid in $relative.")
    }
    if ($content -notmatch '(?ms)^    Server:\r?\n        SSL: true\r?\n        Port: __WAYFARER_MARIADB_PORT__\r?\n        Address: 127\.0\.0\.2\r?$') {
        $errors.Add("mcMMO TLS endpoint is invalid in $relative.")
    }
    if ($content -notmatch '(?ms)^Scoreboard:\r?\n.*?^    UseScoreboards: false\r?$') {
        $errors.Add("mcMMO scoreboard policy is invalid in $relative.")
    }

    $runtimeRelative = $relative.Substring(0, $relative.Length - '.template'.Length)
    & git -C $Root check-ignore -q --no-index -- $runtimeRelative
    if ($LASTEXITCODE -ne 0) { $errors.Add("mcMMO runtime Config is not ignored: $runtimeRelative") }
}

$expectedMcMmoHash = '03ABEEB48E33733C14859B4CAC6DC1104D19F15E4E81D9EB6B79D666F0E8A1B9'
$mcmmoJars = @(
    'servers/main/plugins/mcmmo.jar',
    'servers/frontier/plugins/mcmmo.jar'
)
foreach ($relative in $mcmmoJars) {
    $path = Join-Path $Root $relative
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { continue }
    if ((Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash -ne $expectedMcMmoHash) {
        $errors.Add("Unexpected mcMMO JAR hash: $relative")
    }
    & git -C $Root check-ignore -q --no-index -- $relative
    if ($LASTEXITCODE -ne 0) { $errors.Add("mcMMO JAR is not ignored: $relative") }
}

foreach ($relative in @('servers/lobby/plugins', 'velocity/plugins')) {
    $path = Join-Path $Root $relative
    $unexpected = Get-ChildItem -LiteralPath $path -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '(?i)^mcmmo.*\.jar$' }
    if ($unexpected) { $errors.Add("mcMMO must not be placed in $relative.") }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}
Write-Host 'Repository layout checks passed.'
