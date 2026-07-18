[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$envPath = Join-Path $Root '.env'
$addressToken = '__WAYFARER_' + 'MARIADB_ADDRESS__'
$userToken = '__WAYFARER_' + 'MARIADB_USER__'
$passwordToken = '__WAYFARER_' + 'MARIADB_PASSWORD__'
$targets = @(
    @{
        Name = 'Velocity'
        Context = 'velocity'
        Template = 'velocity/plugins/luckperms/config.yml.template'
        Output = 'velocity/plugins/luckperms/config.yml'
    }
    @{
        Name = 'Lobby'
        Context = 'lobby'
        Template = 'servers/lobby/plugins/LuckPerms/config.yml.template'
        Output = 'servers/lobby/plugins/LuckPerms/config.yml'
    }
    @{
        Name = 'Main'
        Context = 'main'
        Template = 'servers/main/plugins/LuckPerms/config.yml.template'
        Output = 'servers/main/plugins/LuckPerms/config.yml'
    }
    @{
        Name = 'Frontier'
        Context = 'frontier'
        Template = 'servers/frontier/plugins/LuckPerms/config.yml.template'
        Output = 'servers/frontier/plugins/LuckPerms/config.yml'
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

$requiredKeys = @(
    'MARIADB_WAYFARER_USER'
    'MARIADB_WAYFARER_PASSWORD'
    'MARIADB_HOST_PORT'
)
foreach ($key in $requiredKeys) {
    if (-not $envValues.ContainsKey($key) -or [string]::IsNullOrEmpty($envValues[$key])) {
        throw "Missing or empty required .env key: $key."
    }
}

$databaseUser = [string] $envValues['MARIADB_WAYFARER_USER']
$databasePassword = [string] $envValues['MARIADB_WAYFARER_PASSWORD']
$portText = [string] $envValues['MARIADB_HOST_PORT']
if ($databaseUser -match '[\r\n]' -or $databasePassword -match '[\r\n]') {
    throw 'MariaDB credentials must not contain CR or LF characters.'
}

$databasePort = 0
if (-not [int]::TryParse($portText, [ref] $databasePort) -or $databasePort -lt 1 -or $databasePort -gt 65535) {
    throw 'MARIADB_HOST_PORT must be an integer from 1 through 65535.'
}

$databaseAddress = "127.0.0.2:$databasePort"
$replacementValues = @{
    $addressToken = $databaseAddress.Replace("'", "''")
    $userToken = $databaseUser.Replace("'", "''")
    $passwordToken = $databasePassword.Replace("'", "''")
}

$renderPlans = [Collections.Generic.List[object]]::new()
foreach ($target in $targets) {
    $templatePath = Join-Path $Root $target.Template
    if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
        throw "Missing $($target.Name) LuckPerms config template."
    }

    $rendered = [IO.File]::ReadAllText($templatePath)
    foreach ($token in @($addressToken, $userToken, $passwordToken)) {
        $tokenCount = [regex]::Matches($rendered, [regex]::Escape($token)).Count
        if ($tokenCount -ne 1) {
            throw "Expected exactly one $($target.Name) LuckPerms token of each type; found $tokenCount."
        }
        $rendered = $rendered.Replace($token, $replacementValues[$token])
    }

    if ($rendered.Contains($addressToken) -or $rendered.Contains($userToken) -or $rendered.Contains($passwordToken)) {
        throw "A LuckPerms token remained in the $($target.Name) output."
    }
    if ($rendered -notmatch "(?m)^server:\s*$([regex]::Escape($target.Context))\s*$") {
        throw "$($target.Name) LuckPerms server context validation failed."
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
            throw "Rendered $($plan.Name) LuckPerms config is not ignored by Git."
        }

        $completed.Add($plan.Name)
        Write-Host "$($plan.Name) LuckPerms configuration rendered successfully."
    }
    catch {
        $completedSummary = if ($completed.Count -eq 0) {
            'No components completed before this failure.'
        }
        else {
            "Completed before failure: $($completed -join ', ')."
        }
        throw "$($plan.Name) LuckPerms configuration rendering failed. $completedSummary The failing component may have an incomplete output. $($_.Exception.Message)"
    }
}
