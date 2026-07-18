[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$secretPath = Join-Path $Root 'velocity/forwarding.secret'
$token = '__WAYFARER_' + 'FORWARDING_SECRET__'
$targets = @(
    @{
        Name = 'Lobby'
        Template = 'servers/lobby/config/paper-global.yml.template'
        Output = 'servers/lobby/config/paper-global.yml'
    }
    @{
        Name = 'Main'
        Template = 'servers/main/config/paper-global.yml.template'
        Output = 'servers/main/config/paper-global.yml'
    }
)

if (-not (Test-Path -LiteralPath $secretPath -PathType Leaf)) {
    throw 'Missing velocity/forwarding.secret.'
}
$secretText = [IO.File]::ReadAllText($secretPath)
$secret = $secretText.TrimEnd([char]13, [char]10)
if ([string]::IsNullOrEmpty($secret)) {
    throw 'Velocity forwarding secret is empty.'
}
if ($secret -match '\s') {
    throw 'Velocity forwarding secret must not contain whitespace.'
}
if ($secretText -notin @($secret, "$secret`n", "$secret`r`n")) {
    throw 'Velocity forwarding secret must contain exactly one line.'
}

$completed = [Collections.Generic.List[string]]::new()
foreach ($target in $targets) {
    try {
        $templatePath = Join-Path $Root $target.Template
        $outputPath = Join-Path $Root $target.Output
        if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
            throw "Missing $($target.Name) paper-global.yml.template."
        }

        $template = [IO.File]::ReadAllText($templatePath)
        $tokenCount = [regex]::Matches($template, [regex]::Escape($token)).Count
        if ($tokenCount -ne 1) {
            throw "Expected exactly one forwarding secret token in the $($target.Name) template; found $tokenCount."
        }

        $rendered = $template.Replace($token, $secret)
        if ($rendered.Contains($token)) {
            throw "Forwarding secret token remained in the $($target.Name) output."
        }

        [IO.File]::WriteAllText($outputPath, $rendered, [Text.UTF8Encoding]::new($false))

        & git -C $Root check-ignore -q --no-index -- $target.Output
        if ($LASTEXITCODE -ne 0) {
            throw "Rendered $($target.Name) paper-global.yml is not ignored by Git."
        }

        $completed.Add($target.Name)
        Write-Host "$($target.Name) network configuration rendered successfully."
    }
    catch {
        $completedSummary = if ($completed.Count -eq 0) {
            'No components completed before this failure.'
        }
        else {
            "Completed before failure: $($completed -join ', ')."
        }
        throw "$($target.Name) network configuration rendering failed. $completedSummary The failing component may have an incomplete output. $($_.Exception.Message)"
    }
}
