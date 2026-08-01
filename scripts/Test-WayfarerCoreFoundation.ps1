[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$PhaseRoot = Join-Path $Root '.ai-work/order09-core-v001-acceptance/phase-015-compatibility-foundation'
$TestRoot = Join-Path $PhaseRoot 'test/config-foundation'
New-Item -ItemType Directory -Force -Path $TestRoot | Out-Null

. (Join-Path $PSScriptRoot 'Wayfarer-CoreEnvironment.ps1')
$renderer = Join-Path $PSScriptRoot 'Render-WayfarerCoreConfig.ps1'
$secret = 'probe-' + ([Guid]::NewGuid().ToString('N'))
$dbUser = 'probe_user'
$dotEnv = Join-Path $TestRoot 'source.env'
$dotEnvLines = [Collections.Generic.List[string]]::new()
[void] $dotEnvLines.Add("MARIADB_WAYFARER_USER=$dbUser")
[void] $dotEnvLines.Add("MARIADB_WAYFARER_PASSWORD=$secret")
[void] $dotEnvLines.Add('MARIADB_HOST_PORT=13306')
[void] $dotEnvLines.Add("REDIS_PASSWORD=$secret")
[void] $dotEnvLines.Add('REDIS_HOST_PORT=16379')
[IO.File]::WriteAllText($dotEnv, ($dotEnvLines -join [Environment]::NewLine), [Text.UTF8Encoding]::new($false))

function Invoke-ExpectedRendererFailure {
    param([Parameter(Mandatory)] [hashtable] $Parameters)
    try {
        & $renderer @Parameters *> $null
        return $false
    }
    catch {
        return $true
    }
}

function Assert-Foundation {
    param([Parameter(Mandatory)] [bool] $Condition, [Parameter(Mandatory)] [string] $Message)
    if (-not $Condition) { throw $Message }
}

try {
    Set-WayfarerCoreEnvironment -DotEnvPath $dotEnv -DatabaseName 'wayfarer_o09_p015_core' -DatabaseHost '127.0.0.1' -RedisHost '127.0.0.1'
    $summary = Test-WayfarerCoreEnvironment
    Assert-Foundation ($summary.Count -eq 4 -and ($summary.Status | Where-Object { $_ -ne 'SET' }).Count -eq 0) 'Environment mapping did not produce the four sanitized SET entries.'
    Assert-Foundation ($env:WAYFARER_DB_URL -eq 'jdbc:mariadb://127.0.0.1:13306/wayfarer_o09_p015_core') 'Database URL mapping is not deterministic.'
    Assert-Foundation ($env:WAYFARER_REDIS_URI -match '^redis://:.*@127\.0\.0\.1:16379$') 'Redis URI mapping has an unexpected non-secret shape.'

    $mainPath = Join-Path $TestRoot 'main/config.yml'
    $frontierPath = Join-Path $TestRoot 'frontier/config.yml'
    $mainAgainPath = Join-Path $TestRoot 'main-again/config.yml'
    & $renderer -Target Main -OutputPath $mainPath *> $null
    & $renderer -Target Frontier -OutputPath $frontierPath *> $null
    & $renderer -Target Main -OutputPath $mainAgainPath *> $null
    Assert-Foundation (Test-Path -LiteralPath $mainPath) 'Main render did not create the task-only output.'
    Assert-Foundation (Test-Path -LiteralPath $frontierPath) 'Frontier render did not create the task-only output.'
    $mainContent = [IO.File]::ReadAllText($mainPath)
    $frontierContent = [IO.File]::ReadAllText($frontierPath)
    Assert-Foundation ($mainContent.Contains('server-id: main')) 'Main output has the wrong server-id.'
    Assert-Foundation ($frontierContent.Contains('server-id: frontier')) 'Frontier output has the wrong server-id.'
    Assert-Foundation (-not $mainContent.Contains($secret) -and -not $frontierContent.Contains($secret)) 'Secret materialized in sanitized Core output.'
    Assert-Foundation (-not $mainContent.Contains('jdbc:mariadb://') -and -not $frontierContent.Contains('redis://')) 'Connection value materialized in sanitized Core output.'
    Assert-Foundation ([IO.File]::ReadAllText($mainPath) -ceq [IO.File]::ReadAllText($mainAgainPath)) 'Repeated Main render is not deterministic.'
    $frontierHashBefore = (Get-FileHash -Algorithm SHA256 -LiteralPath $frontierPath).Hash
    & $renderer -Target Main -OutputPath $mainPath *> $null
    $frontierHashAfter = (Get-FileHash -Algorithm SHA256 -LiteralPath $frontierPath).Hash
    Assert-Foundation ($frontierHashBefore -eq $frontierHashAfter) 'Main render overwrote Frontier output.'

    $validateOnlyPath = Join-Path $TestRoot 'validate-only/config.yml'
    $validateOnlyFailed = Invoke-ExpectedRendererFailure -Parameters @{ Target = 'Main'; OutputPath = $validateOnlyPath; ValidateOnly = $true }
    Assert-Foundation ($validateOnlyFailed -eq $false) 'Validate-only invocation was unexpectedly rejected.'
    Assert-Foundation (-not (Test-Path -LiteralPath $validateOnlyPath)) 'Validate-only created a Runtime file.'

    $brokenPath = Join-Path $TestRoot 'broken-version.yml'
    $brokenContent = $mainContent.Replace('config-version: 1','config-version: 2')
    [IO.File]::WriteAllText($brokenPath, $brokenContent, [Text.UTF8Encoding]::new($false))
    Assert-Foundation (Invoke-ExpectedRendererFailure -Parameters @{ Target = 'Main'; InputPath = $brokenPath; ValidateOnly = $true }) 'Unsupported Config Version was accepted.'

    $saved = @{
        WAYFARER_DB_URL = $env:WAYFARER_DB_URL
        WAYFARER_DB_USERNAME = $env:WAYFARER_DB_USERNAME
        WAYFARER_DB_PASSWORD = $env:WAYFARER_DB_PASSWORD
        WAYFARER_REDIS_URI = $env:WAYFARER_REDIS_URI
    }
    try {
        $env:WAYFARER_DB_PASSWORD = $null
        Assert-Foundation (Invoke-ExpectedRendererFailure -Parameters @{ Target = 'Main'; OutputPath = (Join-Path $TestRoot 'missing/config.yml') }) 'Missing environment was accepted.'
        $env:WAYFARER_DB_PASSWORD = ' '
        Assert-Foundation (Invoke-ExpectedRendererFailure -Parameters @{ Target = 'Main'; OutputPath = (Join-Path $TestRoot 'blank/config.yml') }) 'Blank environment was accepted.'
        $env:WAYFARER_DB_PASSWORD = 'CHANGE_ME'
        Assert-Foundation (Invoke-ExpectedRendererFailure -Parameters @{ Target = 'Main'; OutputPath = (Join-Path $TestRoot 'placeholder/config.yml') }) 'Reserved placeholder was accepted.'
    }
    finally {
        foreach ($name in $saved.Keys) { [Environment]::SetEnvironmentVariable($name, $saved[$name], 'Process') }
    }

    $productionPath = Join-Path $Root 'servers/main/plugins/Wayfarer_Core/config.yml'
    Assert-Foundation (Invoke-ExpectedRendererFailure -Parameters @{ Target = 'Main'; OutputPath = $productionPath }) 'Production output was allowed without explicit permission.'
    $escapePath = Join-Path $Root '..\wayfarer-o09-p015-escape\config.yml'
    Assert-Foundation (Invoke-ExpectedRendererFailure -Parameters @{ Target = 'Main'; OutputPath = $escapePath }) 'Output path escape was accepted.'
    $trackedSecretSearch = & git -C $Root grep -I -F -- $secret -- '*.ps1' '*.yml' '*.md' 2>$null
    Assert-Foundation ($LASTEXITCODE -ne 0) 'The in-process test secret appeared in tracked files.'

    Write-Output 'Wayfarer_Core configuration foundation tests passed; secret values were not emitted.'
}
finally {
    [Environment]::SetEnvironmentVariable('WAYFARER_DB_URL', $null, 'Process')
    [Environment]::SetEnvironmentVariable('WAYFARER_DB_USERNAME', $null, 'Process')
    [Environment]::SetEnvironmentVariable('WAYFARER_DB_PASSWORD', $null, 'Process')
    [Environment]::SetEnvironmentVariable('WAYFARER_REDIS_URI', $null, 'Process')
}
