[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$secretPath = Join-Path $Root 'velocity/forwarding.secret'
$templatePath = Join-Path $Root 'servers/lobby/config/paper-global.yml.template'
$outputPath = Join-Path $Root 'servers/lobby/config/paper-global.yml'
$outputRelativePath = 'servers/lobby/config/paper-global.yml'
$token = '__WAYFARER_' + 'FORWARDING_SECRET__'

if (-not (Test-Path -LiteralPath $secretPath -PathType Leaf)) {
    throw 'Missing velocity/forwarding.secret.'
}
if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
    throw 'Missing Lobby paper-global.yml.template.'
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

$template = [IO.File]::ReadAllText($templatePath)
$tokenCount = [regex]::Matches($template, [regex]::Escape($token)).Count
if ($tokenCount -ne 1) {
    throw "Expected exactly one forwarding secret token in the template; found $tokenCount."
}

$rendered = $template.Replace($token, $secret)
if ($rendered.Contains($token)) {
    throw 'Forwarding secret token remained after rendering.'
}

[IO.File]::WriteAllText($outputPath, $rendered, [Text.UTF8Encoding]::new($false))

& git -C $Root check-ignore -q --no-index -- $outputRelativePath
if ($LASTEXITCODE -ne 0) {
    throw 'Rendered Lobby paper-global.yml is not ignored by Git.'
}

Write-Host 'Lobby network configuration rendered successfully.'
