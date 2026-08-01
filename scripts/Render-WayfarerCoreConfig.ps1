[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('Main','Frontier')]
    [string] $Target,

    [string] $OutputPath,

    [string] $InputPath,

    [ValidatePattern('^[A-Za-z0-9._-]{1,64}$')]
    [string] $ServerId,

    [string] $DotEnvPath,

    [switch] $ValidateOnly,

    [switch] $AllowProductionOutput
)

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
. (Join-Path $PSScriptRoot 'Wayfarer-CoreEnvironment.ps1')

$expectedServerId = if ($Target -eq 'Main') { 'main' } else { 'frontier' }
if ([string]::IsNullOrEmpty($ServerId)) { $ServerId = $expectedServerId }
if ($ServerId.ToLowerInvariant() -in @('change_me','change-me','changeme','default','example')) {
    throw 'The Core server-id is a reserved placeholder.'
}

if ($DotEnvPath) {
    Set-WayfarerCoreEnvironment -DotEnvPath $DotEnvPath
}
[void] (Test-WayfarerCoreEnvironment)

if ($InputPath -and $OutputPath) { throw 'InputPath and OutputPath are mutually exclusive.' }

$templateRelative = if ($Target -eq 'Main') {
    'servers/main/plugins/Wayfarer_Core/config.yml.template'
}
else {
    'servers/frontier/plugins/Wayfarer_Core/config.yml.template'
}
$templatePath = Join-Path $Root $templateRelative
if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
    throw "Missing tracked Core Config template for $Target."
}

function Resolve-WayfarerCorePathWithinRoot {
    param([Parameter(Mandatory)] [string] $Path)
    $full = [IO.Path]::GetFullPath($Path)
    $prefix = $Root.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    if (-not $full.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Core Config path escapes the Project root.'
    }
    return $full
}

function Test-WayfarerCoreConfigContent {
    param(
        [Parameter(Mandatory)] [string] $Content,
        [Parameter(Mandatory)] [string] $ExpectedServerId
    )

    if ($Content.Contains('__WAYFARER_')) { throw 'Core Config contains an unresolved token.' }
    if ($Content -match '(?im)^server-id:\s*(change_me|change-me|changeme|default|example)\s*$') {
        throw 'Core Config contains a reserved server-id.'
    }
    $requiredLines = @(
        'config-version: 1',
        "server-id: $ExpectedServerId",
        '  enabled: true',
        '  jdbc-url-env: WAYFARER_DB_URL',
        '  username-env: WAYFARER_DB_USERNAME',
        '  password-env: WAYFARER_DB_PASSWORD',
        '  uri-env: WAYFARER_REDIS_URI',
        '  key-prefix: wayfarer',
        '    - db/migration/core',
        '  provider-mode: vault',
        '  expected-provider: RedisEconomy'
    )
    foreach ($line in $requiredLines) {
        if (-not [regex]::IsMatch($Content, '(?m)^' + [regex]::Escape($line) + '\s*$')) {
            throw "Core Config is missing the Release-contract setting: $line."
        }
    }
    foreach ($envName in @('WAYFARER_DB_URL','WAYFARER_DB_USERNAME','WAYFARER_DB_PASSWORD','WAYFARER_REDIS_URI')) {
        if ([regex]::Matches($Content, [regex]::Escape($envName)).Count -ne 1) {
            throw "Core Config must reference $envName exactly once."
        }
    }
    if ([regex]::Matches($Content, '(?m)^audit:\r?\n  enabled: true\r?$').Count -ne 1) {
        throw 'Project Core audit policy is not enabled in the sanitized template.'
    }
}

$content = if ($InputPath) {
    $resolvedInput = Resolve-WayfarerCorePathWithinRoot -Path $InputPath
    if (-not (Test-Path -LiteralPath $resolvedInput -PathType Leaf)) { throw 'Input Core Config does not exist.' }
    [IO.File]::ReadAllText($resolvedInput)
}
else {
    [IO.File]::ReadAllText($templatePath)
}

if (-not $InputPath -and $ServerId -ne $expectedServerId) {
    $serverLine = "server-id: $expectedServerId"
    if ([regex]::Matches($content, '(?m)^' + [regex]::Escape($serverLine) + '\s*$').Count -ne 1) {
        throw 'The tracked Core template has an unexpected server-id line.'
    }
    $serverPattern = '(?m)^' + [regex]::Escape($serverLine) + '\s*$'
    $content = $content -replace $serverPattern, "server-id: $ServerId"
}
Test-WayfarerCoreConfigContent -Content $content -ExpectedServerId $ServerId

$productionRelative = if ($Target -eq 'Main') {
    'servers/main/plugins/Wayfarer_Core/config.yml'
}
else {
    'servers/frontier/plugins/Wayfarer_Core/config.yml'
}
$productionPath = Join-Path $Root $productionRelative

if ($OutputPath) {
    $resolvedOutput = Resolve-WayfarerCorePathWithinRoot -Path $OutputPath
    if ($resolvedOutput -eq [IO.Path]::GetFullPath($templatePath)) {
        throw 'The tracked sanitized template cannot be overwritten.'
    }
    if ($resolvedOutput -eq [IO.Path]::GetFullPath($productionPath) -and -not $AllowProductionOutput) {
        throw 'Production Core Config output requires -AllowProductionOutput.'
    }
}
else {
    $resolvedOutput = [IO.Path]::GetFullPath($productionPath)
    if (-not $ValidateOnly -and -not $AllowProductionOutput) {
        throw 'Production Core Config output requires -AllowProductionOutput.'
    }
}

if (-not $ValidateOnly -and -not $InputPath) {
    $parent = Split-Path -Parent $resolvedOutput
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    [IO.File]::WriteAllText($resolvedOutput, $content, [Text.UTF8Encoding]::new($false))

    $relative = $resolvedOutput.Substring($Root.Length + 1).Replace('\','/')
    & git -C $Root check-ignore -q --no-index -- $relative
    if ($LASTEXITCODE -ne 0) { throw 'Rendered Core Config is not ignored by Git.' }
}

$mode = if ($ValidateOnly -or $InputPath) { 'VALIDATED' } else { 'RENDERED' }
$outputSummary = if ($OutputPath) { $resolvedOutput } else { 'production-default' }
Write-Output "Wayfarer_Core $Target $mode; server-id=$ServerId; output=$outputSummary; environment=SET; secrets=NOT_EMITTED"
