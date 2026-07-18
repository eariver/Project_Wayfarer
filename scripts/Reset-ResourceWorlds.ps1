[CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
param(
    [Parameter(Mandatory)]
    [ValidateSet('resource','resource_nether','resource_end','all')]
    [string]$World,

    [Parameter(Mandatory)]
    [switch]$MainServerIsStopped,

    [Parameter(Mandatory)]
    [string]$ConfirmationText
)

$ErrorActionPreference = 'Stop'
if (-not $MainServerIsStopped) { throw 'Main server must be stopped.' }
if ($ConfirmationText -ne 'RESET-WAYFARER-RESOURCE') { throw 'Incorrect confirmation text.' }

$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$MainDir = (Resolve-Path (Join-Path $Root 'servers/main')).Path
$allow = if ($World -eq 'all') { @('resource','resource_nether','resource_end') } else { @($World) }

foreach ($name in $allow) {
    $target = Join-Path $MainDir $name
    $resolvedParent = (Resolve-Path (Split-Path $target -Parent)).Path
    if ($resolvedParent -ne $MainDir) { throw "Unsafe target parent: $resolvedParent" }
    if ($name -notin @('resource','resource_nether','resource_end')) { throw "World not allowlisted: $name" }
    if (Test-Path $target) {
        if ($PSCmdlet.ShouldProcess($target, 'Delete disposable resource world')) {
            Remove-Item -Recurse -Force $target
            Write-Host "Deleted $target"
        }
    } else {
        Write-Warning "World does not exist: $target"
    }
}

Write-Host 'Restart Main and recreate/import the resource worlds using the approved Multiverse procedure.'
