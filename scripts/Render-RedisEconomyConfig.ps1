[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$envPath = Join-Path $Root '.env'
$passwordToken = '__WAYFARER_' + 'REDIS_PASSWORD__'
$portToken = '__WAYFARER_' + 'REDIS_PORT__'
$targets = @(
    @{
        Name = 'Main'
        ClientName = 'main'
        Template = 'servers/main/plugins/RedisEconomy/config.yml.template'
        Output = 'servers/main/plugins/RedisEconomy/config.yml'
    }
    @{
        Name = 'Frontier'
        ClientName = 'frontier'
        Template = 'servers/frontier/plugins/RedisEconomy/config.yml.template'
        Output = 'servers/frontier/plugins/RedisEconomy/config.yml'
    }
)

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

    $rawValue = $line.Substring($separator + 1)
    $envValues[$key] = ConvertFrom-DotEnvValue -RawValue $rawValue -Key $key
}

foreach ($key in @('REDIS_PASSWORD', 'REDIS_HOST_PORT')) {
    if (-not $envValues.ContainsKey($key) -or [string]::IsNullOrEmpty($envValues[$key])) {
        throw "Missing or empty required .env key: $key."
    }
}

$redisPassword = [string] $envValues['REDIS_PASSWORD']
if ($redisPassword -match '[\r\n]') {
    throw 'REDIS_PASSWORD must not contain CR or LF characters.'
}

$portText = [string] $envValues['REDIS_HOST_PORT']
$redisPort = 0
if (-not [int]::TryParse($portText, [ref] $redisPort) -or $redisPort -lt 1 -or $redisPort -gt 65535) {
    throw 'REDIS_HOST_PORT must be an integer from 1 through 65535.'
}

$replacementValues = @{
    $passwordToken = $redisPassword.Replace("'", "''")
    $portToken = $redisPort.ToString([Globalization.CultureInfo]::InvariantCulture)
}

$renderPlans = [Collections.Generic.List[object]]::new()
foreach ($target in $targets) {
    $templatePath = Join-Path $Root $target.Template
    if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
        throw "Missing $($target.Name) RedisEconomy config template."
    }

    $rendered = [IO.File]::ReadAllText($templatePath)
    foreach ($token in @($passwordToken, $portToken)) {
        $tokenCount = [regex]::Matches($rendered, [regex]::Escape($token)).Count
        if ($tokenCount -ne 1) {
            throw "Expected exactly one $($target.Name) RedisEconomy token of each type; found $tokenCount."
        }
        $rendered = $rendered.Replace($token, $replacementValues[$token])
    }

    if ($rendered.Contains($passwordToken) -or $rendered.Contains($portToken)) {
        throw "A RedisEconomy token remained in the $($target.Name) output."
    }
    if ($rendered -notmatch '(?ms)^redis:\r?\n  host: 127\.0\.0\.2\r?\n  port: [0-9]+\r?\n  user: ''''\r?\n  password: ''[^\r\n]*''\r?\n  database: 0\r?$') {
        throw "$($target.Name) RedisEconomy endpoint validation failed."
    }
    if ($rendered -notmatch "(?m)^  clientName: $([regex]::Escape($target.ClientName))\r?$") {
        throw "$($target.Name) RedisEconomy client identifier validation failed."
    }
    if ($rendered -notmatch '(?m)^clusterId: waymark\r?$') {
        throw "$($target.Name) RedisEconomy shared namespace validation failed."
    }
    if ($rendered -notmatch '(?ms)^defaultCurrencyName: vault\r?\n.*?^currencies:\r?\n- currencyName: vault\r?\n.*?^  currencySingle: WM\r?\n  currencyPlural: WM\r?\n  decimalFormat: ''#,##0\.## ''\r?\n  languageTag: ja-JP\r?\n  startingBalance: 0\.0\r?$') {
        throw "$($target.Name) RedisEconomy currency validation failed."
    }
    if ([regex]::Matches($rendered, '(?m)^- currencyName:').Count -ne 1) {
        throw "$($target.Name) RedisEconomy must define exactly one currency."
    }
    foreach ($requiredSetting in @(
        'migrationEnabled: false',
        '  payTax: 0.0',
        '  saveTransactions: true',
        '  bankEnabled: false'
    )) {
        if (-not $rendered.Contains($requiredSetting)) {
            throw "$($target.Name) RedisEconomy policy validation failed."
        }
    }

    $renderPlans.Add([pscustomobject]@{
        Name = $target.Name
        Output = $target.Output
        OutputPath = Join-Path $Root $target.Output
        Content = $rendered
    })
}

$completed = [Collections.Generic.List[string]]::new()
foreach ($plan in $renderPlans) {
    try {
        [IO.File]::WriteAllText($plan.OutputPath, $plan.Content, [Text.UTF8Encoding]::new($false))

        & git -C $Root check-ignore -q --no-index -- $plan.Output
        if ($LASTEXITCODE -ne 0) {
            throw "Rendered $($plan.Name) RedisEconomy config is not ignored by Git."
        }

        $completed.Add($plan.Name)
        Write-Host "$($plan.Name) RedisEconomy configuration rendered successfully."
    }
    catch {
        $completedSummary = if ($completed.Count -eq 0) {
            'No components completed before this failure.'
        }
        else {
            "Completed before failure: $($completed -join ', ')."
        }
        throw "$($plan.Name) RedisEconomy configuration rendering failed. $completedSummary The failing component may have an incomplete output. $($_.Exception.Message)"
    }
}
