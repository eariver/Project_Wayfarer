[CmdletBinding()]
param()

function ConvertFrom-WayfarerDotEnvValue {
    param(
        [Parameter(Mandatory)]
        [string] $RawValue,

        [Parameter(Mandatory)]
        [string] $Key
    )

    $value = $RawValue.Trim()
    if ($value.Length -eq 0) { return '' }

    $quote = $value[0]
    if ($quote -notin @([char]39, [char]34)) { return $value }
    if ($value.Length -lt 2 -or $value[$value.Length - 1] -ne $quote) {
        throw "Unterminated quoted value for .env key $Key."
    }

    $inner = $value.Substring(1, $value.Length - 2)
    if ($quote -eq [char]39) { return $inner.Replace("\'", "'") }

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

function Get-WayfarerDotEnvValues {
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw 'Missing Project secret source.'
    }

    $values = @{}
    $lineNumber = 0
    foreach ($line in [IO.File]::ReadAllLines($Path)) {
        $lineNumber++
        $trimmed = $line.Trim()
        if ($trimmed.Length -eq 0 -or $trimmed.StartsWith('#')) { continue }

        $separator = $line.IndexOf('=')
        if ($separator -lt 1) { throw "Invalid .env assignment at line $lineNumber." }
        $key = $line.Substring(0, $separator).Trim()
        if ($key -notmatch '^[A-Za-z_][A-Za-z0-9_]*$') {
            throw "Invalid .env key at line $lineNumber."
        }
        if ($values.ContainsKey($key)) { throw "Duplicate .env key: $key." }
        $values[$key] = ConvertFrom-WayfarerDotEnvValue -RawValue $line.Substring($separator + 1) -Key $key
    }
    return $values
}

function Assert-WayfarerCoreSecretValue {
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) { throw "$Name is missing or blank." }
    if ($Value -match '[\r\n]') { throw "$Name must not contain CR or LF." }
    if ($Value.Trim().ToLowerInvariant() -in @('change_me', 'change-me', 'changeme', 'default', 'example')) {
        throw "$Name contains a reserved placeholder."
    }
}

function ConvertTo-WayfarerRedisUriPassword {
    param(
        [Parameter(Mandatory)]
        [string] $Password
    )
    return [Uri]::EscapeDataString($Password)
}

function Set-WayfarerCoreEnvironmentFromConnection {
    param(
        [Parameter(Mandatory)] [string] $DatabaseHost,
        [Parameter(Mandatory)] [int] $DatabasePort,
        [Parameter(Mandatory)] [string] $DatabaseName,
        [Parameter(Mandatory)] [string] $DatabaseUsername,
        [Parameter(Mandatory)] [string] $DatabasePassword,
        [Parameter(Mandatory)] [string] $RedisHost,
        [Parameter(Mandatory)] [int] $RedisPort,
        [Parameter(Mandatory)] [string] $RedisPassword
    )

    foreach ($entry in @(
        @{ Name = 'DatabaseHost'; Value = $DatabaseHost },
        @{ Name = 'DatabaseName'; Value = $DatabaseName },
        @{ Name = 'DatabaseUsername'; Value = $DatabaseUsername },
        @{ Name = 'DatabasePassword'; Value = $DatabasePassword },
        @{ Name = 'RedisHost'; Value = $RedisHost },
        @{ Name = 'RedisPassword'; Value = $RedisPassword }
    )) {
        Assert-WayfarerCoreSecretValue -Name $entry.Name -Value ([string] $entry.Value)
    }
    if ($DatabasePort -lt 1 -or $DatabasePort -gt 65535) { throw 'DatabasePort is outside the valid range.' }
    if ($RedisPort -lt 1 -or $RedisPort -gt 65535) { throw 'RedisPort is outside the valid range.' }

    $env:WAYFARER_DB_URL = "jdbc:mariadb://$DatabaseHost`:$DatabasePort/$DatabaseName"
    $env:WAYFARER_DB_USERNAME = $DatabaseUsername
    $env:WAYFARER_DB_PASSWORD = $DatabasePassword
    $escapedRedisPassword = ConvertTo-WayfarerRedisUriPassword -Password $RedisPassword
    # No database index is selected here; the Release URI default is retained and
    # Core's wayfarer key prefix separates coordination/cache keys from Waymark.
    $env:WAYFARER_REDIS_URI = "redis://:$escapedRedisPassword@$RedisHost`:$RedisPort"
}

function Set-WayfarerCoreEnvironment {
    param(
        [Parameter(Mandatory)] [string] $DotEnvPath,
        [string] $DatabaseName = 'wayfarer_network',
        [string] $DatabaseHost = '127.0.0.2',
        [string] $RedisHost = '127.0.0.2'
    )

    $values = Get-WayfarerDotEnvValues -Path $DotEnvPath
    foreach ($key in @('MARIADB_WAYFARER_USER','MARIADB_WAYFARER_PASSWORD','MARIADB_HOST_PORT','REDIS_PASSWORD','REDIS_HOST_PORT')) {
        if (-not $values.ContainsKey($key)) { throw "Missing required Project secret-source key: $key." }
    }

    $databasePort = 0
    if (-not [int]::TryParse([string] $values['MARIADB_HOST_PORT'], [ref] $databasePort)) {
        throw 'MARIADB_HOST_PORT must be an integer.'
    }
    $redisPort = 0
    if (-not [int]::TryParse([string] $values['REDIS_HOST_PORT'], [ref] $redisPort)) {
        throw 'REDIS_HOST_PORT must be an integer.'
    }

    Set-WayfarerCoreEnvironmentFromConnection `
        -DatabaseHost $DatabaseHost `
        -DatabasePort $databasePort `
        -DatabaseName $DatabaseName `
        -DatabaseUsername ([string] $values['MARIADB_WAYFARER_USER']) `
        -DatabasePassword ([string] $values['MARIADB_WAYFARER_PASSWORD']) `
        -RedisHost $RedisHost `
        -RedisPort $redisPort `
        -RedisPassword ([string] $values['REDIS_PASSWORD'])
}

function Test-WayfarerCoreEnvironment {
    param()

    $required = @('WAYFARER_DB_URL','WAYFARER_DB_USERNAME','WAYFARER_DB_PASSWORD','WAYFARER_REDIS_URI')
    $summary = [Collections.Generic.List[object]]::new()
    foreach ($name in $required) {
        $value = [Environment]::GetEnvironmentVariable($name, 'Process')
        Assert-WayfarerCoreSecretValue -Name $name -Value $value
        if ($value -match '[\r\n]') { throw "$name must not contain CR or LF." }
        if ($name -eq 'WAYFARER_DB_URL') {
            if ($value -match '(?i)password|://[^/]+:[^/]+@') { throw 'WAYFARER_DB_URL must not contain credentials.' }
            if ($value -notmatch '^jdbc:mariadb://[^/]+:[0-9]+/[^/]+$') { throw 'WAYFARER_DB_URL has an unsupported shape.' }
        }
        if ($name -eq 'WAYFARER_REDIS_URI' -and $value -notmatch '^redis(s)?://') {
            throw 'WAYFARER_REDIS_URI has an unsupported scheme.'
        }
        $summary.Add([pscustomobject]@{ Name = $name; Status = 'SET'; Source = 'process-environment' })
    }
    return $summary
}
