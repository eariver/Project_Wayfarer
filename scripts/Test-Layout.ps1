[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$errors = New-Object System.Collections.Generic.List[string]

$required = @(
    'AGENTS.md','.gitignore','.env.example','versions.yml','plugin-manifest.yml',
    'velocity','servers/lobby','servers/main','servers/frontier','infrastructure','docs',
    'scripts/Render-mcMMOConfig.ps1',
    'scripts/Render-EvenMoreFishConfig.ps1',
    'servers/main/plugins/mcMMO/config.yml.template',
    'servers/frontier/plugins/mcMMO/config.yml.template',
    'servers/main/plugins/EvenMoreFish/config.yml.template',
    'servers/main/plugins/EvenMoreFish/messages.yml',
    'servers/main/plugins/EvenMoreFish/gui/main.yml',
    'servers/main/plugins/EvenMoreFish/competitions/main.yml',
    'servers/main/plugins/EvenMoreFish/competitions/sunday.yml',
    'servers/main/plugins/EvenMoreFish/competitions/weekend.yml',
    'servers/main/plugins/EvenMoreFish/rarities/junk.yml',
    'servers/main/plugins/EvenMoreFish/rarities/common.yml',
    'servers/main/plugins/EvenMoreFish/rarities/rare.yml',
    'servers/main/plugins/EvenMoreFish/rarities/epic.yml',
    'servers/main/plugins/EvenMoreFish/rarities/legendary.yml'
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

$emfTemplateRelative = 'servers/main/plugins/EvenMoreFish/config.yml.template'
$emfTemplatePath = Join-Path $Root $emfTemplateRelative
if (Test-Path -LiteralPath $emfTemplatePath -PathType Leaf) {
    $content = [IO.File]::ReadAllText($emfTemplatePath)
    foreach ($token in @(
        '__WAYFARER_EMF_DB_USER__',
        '__WAYFARER_EMF_DB_PASSWORD__',
        '__WAYFARER_MARIADB_PORT__'
    )) {
        $count = [regex]::Matches($content, [regex]::Escape($token)).Count
        if ($count -ne 1) { $errors.Add("Expected one $token in $emfTemplateRelative; found $count.") }
    }
    foreach ($requiredSetting in @(
        'locale: ja',
        '  only-fish: true',
        '  database: wayfarer_evenmorefish',
        '  table-prefix: emf_',
        'disable-mcmmo-loot: true'
    )) {
        if (-not $content.Contains($requiredSetting)) {
            $errors.Add("EvenMoreFish policy is missing from $emfTemplateRelative`: $requiredSetting")
        }
    }
    if ($content -notmatch '(?m)^database:\r?\n  enabled: true\r?$' -or
        $content -notmatch '(?m)^  type: mysql\r?$' -or
        $content -notmatch '(?m)^  address: ''127\.0\.0\.2:__WAYFARER_MARIADB_PORT__''\r?$') {
        $errors.Add('EvenMoreFish MariaDB selection is invalid.')
    }
    if ($content -notmatch '(?ms)^economy:\r?\n.*?^  vault:\r?\n    enabled: true\r?\n    multiplier: 1\.0\r?\n.*?^  playerpoints:\r?\n    enabled: false\r?\n.*?^  griefprevention:\r?\n    enabled: false\r?$') {
        $errors.Add('EvenMoreFish economy policy is invalid.')
    }
    if ($content -notmatch '(?ms)^allowed-worlds:\r?\n- main\r?\n- resource\r?$') {
        $errors.Add('EvenMoreFish allowed-world policy is invalid.')
    }
    if ($content -notmatch '(?ms)^dimension-fishing:\r?\n.*?^  lava:\r?\n    enabled: false\r?\n.*?^  void:\r?\n    enabled: false\r?$') {
        $errors.Add('EvenMoreFish dimension-fishing policy is invalid.')
    }

    & git -C $Root check-ignore -q --no-index -- 'servers/main/plugins/EvenMoreFish/config.yml'
    if ($LASTEXITCODE -ne 0) { $errors.Add('EvenMoreFish runtime Config is not ignored.') }
}

foreach ($relative in @(
    'servers/main/plugins/EvenMoreFish/competitions/main.yml',
    'servers/main/plugins/EvenMoreFish/competitions/sunday.yml',
    'servers/main/plugins/EvenMoreFish/competitions/weekend.yml'
)) {
    $path = Join-Path $Root $relative
    if ((Test-Path -LiteralPath $path -PathType Leaf) -and
        ([IO.File]::ReadAllText($path) -notmatch '(?m)^disabled: true\r?$')) {
        $errors.Add("EvenMoreFish competition is not disabled: $relative")
    }
}

$emfGuiPath = Join-Path $Root 'servers/main/plugins/EvenMoreFish/gui/main.yml'
if (Test-Path -LiteralPath $emfGuiPath -PathType Leaf) {
    $emfGui = [IO.File]::ReadAllText($emfGuiPath)
    if ($emfGui -notmatch '(?m)^open-shop:' -or $emfGui -notmatch '(?m)^  click-action: open-shop$') {
        $errors.Add('EvenMoreFish main GUI does not expose the adopted fish shop.')
    }
}

$emfRarityWorth = [ordered]@{
    'junk.yml' = '0.0'
    'common.yml' = '1.0'
    'rare.yml' = '0.5'
    'epic.yml' = '0.3'
    'legendary.yml' = '0.2'
}
foreach ($entry in $emfRarityWorth.GetEnumerator()) {
    $path = Join-Path $Root "servers/main/plugins/EvenMoreFish/rarities/$($entry.Key)"
    if (Test-Path -LiteralPath $path -PathType Leaf) {
        $rarity = [IO.File]::ReadAllText($path)
        if ($rarity -notmatch "(?m)^worth-multiplier: $([regex]::Escape($entry.Value))\r?$") {
            $errors.Add("Unexpected EvenMoreFish worth multiplier: $($entry.Key)")
        }
        if ($rarity -match '(?i)\bMONEY\b') {
            $errors.Add("Direct MONEY reward remains in adopted EvenMoreFish rarity: $($entry.Key)")
        }
    }
}

$expectedEmfHash = '0F131FE8F7EC68DF2C14D09D2A4E39B9E481257F106A12B06B5BD6513B30BC05'
$emfJarRelative = 'servers/main/plugins/EvenMoreFish-2.4.3.jar'
$emfJarPath = Join-Path $Root $emfJarRelative
if (Test-Path -LiteralPath $emfJarPath -PathType Leaf) {
    if ((Get-FileHash -LiteralPath $emfJarPath -Algorithm SHA256).Hash -ne $expectedEmfHash) {
        $errors.Add('Unexpected EvenMoreFish JAR hash on Main.')
    }
    & git -C $Root check-ignore -q --no-index -- $emfJarRelative
    if ($LASTEXITCODE -ne 0) { $errors.Add('EvenMoreFish JAR is not ignored.') }
}

foreach ($relative in @('velocity/plugins', 'servers/lobby/plugins', 'servers/frontier/plugins')) {
    $path = Join-Path $Root $relative
    $unexpected = Get-ChildItem -LiteralPath $path -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '(?i)^EvenMoreFish.*\.jar$' }
    if ($unexpected) { $errors.Add("EvenMoreFish must not be placed in $relative.") }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}
Write-Host 'Repository layout checks passed.'
