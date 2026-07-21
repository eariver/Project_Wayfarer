[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$envPath = Join-Path $root '.env'
$template = 'servers/main/plugins/EvenMoreFish/config.yml.template'
$output = 'servers/main/plugins/EvenMoreFish/config.yml'
$userToken = '__WAYFARER_EMF_DB_USER__'
$passwordToken = '__WAYFARER_EMF_DB_PASSWORD__'
$portToken = '__WAYFARER_MARIADB_PORT__'

function ConvertFrom-DotEnvValue {
    param(
        [Parameter(Mandatory)]
        [string] $RawValue,

        [Parameter(Mandatory)]
        [string] $Key
    )

    $value = $RawValue.Trim()
    if ($value.Length -eq 0) {
        return ''
    }

    $quote = $value[0]
    if ($quote -notin @([char]39, [char]34)) {
        return $value
    }
    if ($value.Length -lt 2 -or $value[$value.Length - 1] -ne $quote) {
        throw "Unterminated quoted value for .env key $Key."
    }

    $inner = $value.Substring(1, $value.Length - 2)
    if ($quote -eq [char]39) {
        return $inner.Replace("\'", "'")
    }

    $builder = [Text.StringBuilder]::new()
    for ($index = 0; $index -lt $inner.Length; $index++) {
        $character = $inner[$index]
        if ($character -ne [char]92 -or $index + 1 -ge $inner.Length) {
            [void] $builder.Append($character)
            continue
        }

        $index++
        $escaped = $inner[$index]
        switch ($escaped) {
            'n' { [void] $builder.Append("`n") }
            'r' { [void] $builder.Append("`r") }
            't' { [void] $builder.Append("`t") }
            default { [void] $builder.Append($escaped) }
        }
    }
    return $builder.ToString()
}

if (-not (Test-Path -LiteralPath $envPath -PathType Leaf)) {
    throw 'Missing repository root .env file.'
}

$envValues = @{}
$lineNumber = 0
foreach ($line in [IO.File]::ReadAllLines($envPath)) {
    $lineNumber++
    $trimmed = $line.Trim()
    if ($trimmed.Length -eq 0 -or $trimmed.StartsWith('#')) {
        continue
    }

    $separator = $line.IndexOf('=')
    if ($separator -lt 1) {
        throw "Invalid .env assignment at line $lineNumber."
    }

    $key = $line.Substring(0, $separator).Trim()
    if ($key -notmatch '^[A-Za-z_][A-Za-z0-9_]*$') {
        throw "Invalid .env key at line $lineNumber."
    }
    if ($envValues.ContainsKey($key)) {
        throw "Duplicate .env key: $key."
    }

    $envValues[$key] = ConvertFrom-DotEnvValue -RawValue $line.Substring($separator + 1) -Key $key
}

$requiredKeys = @(
    'MARIADB_EVENMOREFISH_USER'
    'MARIADB_EVENMOREFISH_PASSWORD'
    'MARIADB_HOST_PORT'
)
foreach ($key in $requiredKeys) {
    if (-not $envValues.ContainsKey($key) -or [string]::IsNullOrEmpty($envValues[$key])) {
        throw "Missing or empty required .env key: $key."
    }
}

$databaseUser = [string] $envValues['MARIADB_EVENMOREFISH_USER']
$databasePassword = [string] $envValues['MARIADB_EVENMOREFISH_PASSWORD']
if ($databaseUser -match '[\r\n]' -or $databasePassword -match '[\r\n]') {
    throw 'EvenMoreFish database credentials must not contain CR or LF characters.'
}

$databasePort = 0
if (-not [int]::TryParse([string] $envValues['MARIADB_HOST_PORT'], [ref] $databasePort) -or
    $databasePort -lt 1 -or $databasePort -gt 65535) {
    throw 'MARIADB_HOST_PORT must be an integer from 1 through 65535.'
}

$templatePath = Join-Path $root $template
if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
    throw 'Missing Main EvenMoreFish config template.'
}

$rendered = [IO.File]::ReadAllText($templatePath)
$replacementValues = @{
    $userToken = $databaseUser.Replace("'", "''")
    $passwordToken = $databasePassword.Replace("'", "''")
    $portToken = $databasePort.ToString([Globalization.CultureInfo]::InvariantCulture)
}
foreach ($token in @($userToken, $passwordToken, $portToken)) {
    $tokenCount = [regex]::Matches($rendered, [regex]::Escape($token)).Count
    if ($tokenCount -ne 1) {
        throw "Expected exactly one EvenMoreFish $token token; found $tokenCount."
    }
    $rendered = $rendered.Replace($token, $replacementValues[$token])
}

if ($rendered.Contains('__WAYFARER_')) {
    throw 'An unresolved Project Wayfarer token remained in the EvenMoreFish output.'
}
if ($rendered -notmatch '(?m)^database:\r?\n  enabled: true\r?$' -or
    $rendered -notmatch '(?m)^  type: mysql\r?$' -or
    $rendered -notmatch '(?m)^  address: ''127\.0\.0\.2:[0-9]+''\r?$' -or
    $rendered -notmatch '(?m)^  database: wayfarer_evenmorefish\r?$' -or
    $rendered -notmatch '(?m)^  table-prefix: emf_\r?$') {
    throw 'EvenMoreFish database selection validation failed.'
}
if ($rendered -notmatch '(?ms)^  username: ''[^\r\n]+''\r?\n  password: ''[^\r\n]+''\r?$') {
    throw 'EvenMoreFish credential rendering validation failed.'
}
foreach ($requiredSetting in @(
    '    jooq-execute-logging: false'
    '    jooq-render-formatted: false'
    'locale: ja'
    '  only-fish: true'
    'disable-mcmmo-loot: true'
)) {
    if (-not $rendered.Contains($requiredSetting)) {
        throw "EvenMoreFish policy validation failed: $requiredSetting"
    }
}
if ($rendered -notmatch '(?ms)^economy:\r?\n.*?^  vault:\r?\n    enabled: false\r?\n.*?^  playerpoints:\r?\n    enabled: false\r?\n.*?^  griefprevention:\r?\n    enabled: false\r?$') {
    throw 'EvenMoreFish economy-disable validation failed.'
}
if ($rendered -notmatch '(?ms)^dimension-fishing:\r?\n.*?^  lava:\r?\n    enabled: false\r?\n.*?^  void:\r?\n    enabled: false\r?$') {
    throw 'EvenMoreFish dimension-fishing validation failed.'
}
if ($rendered -notmatch '(?ms)^allowed-worlds:\r?\n- main\r?\n- resource\r?$') {
    throw 'EvenMoreFish allowed-world validation failed.'
}

$outputPath = Join-Path $root $output
[IO.File]::WriteAllText($outputPath, $rendered, [Text.UTF8Encoding]::new($false))

& git -C $root check-ignore -q --no-index -- $output
if ($LASTEXITCODE -ne 0) {
    throw 'Rendered Main EvenMoreFish config is not ignored by Git.'
}

Write-Host 'Main EvenMoreFish configuration rendered successfully.'
