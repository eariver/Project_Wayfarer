[CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
param(
    [Parameter(Mandatory)]
    [string]$World,

    [Parameter(Mandatory)]
    [switch]$MainServerIsStopped,

    [Parameter(Mandatory)]
    [string]$BackupDirectory,

    [Parameter(Mandatory)]
    [string]$ConfirmationText
)

$ErrorActionPreference = 'Stop'
if (-not $MainServerIsStopped) { throw 'Main server must be stopped.' }
if ($ConfirmationText -ne 'RESET-WAYFARER-RESOURCE') { throw 'Incorrect confirmation text.' }

$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$MainDir = (Resolve-Path (Join-Path $Root 'servers/main')).Path
$BackupRoot = [IO.Path]::GetFullPath((Join-Path $Root 'backups'))
$BackupDir = [IO.Path]::GetFullPath($BackupDirectory)
$separator = [IO.Path]::DirectorySeparatorChar

$worldTargets = [ordered]@{
    resource = @{
        RuntimeKey = 'minecraft:resource'
        RelativePath = 'main/dimensions/minecraft/resource'
    }
    resource_nether = @{
        RuntimeKey = 'minecraft:resource_nether'
        RelativePath = 'main/dimensions/minecraft/resource_nether'
    }
    resource_end = @{
        RuntimeKey = 'minecraft:resource_end'
        RelativePath = 'main/dimensions/minecraft/resource_end'
    }
}

$persistentNames = @(
    'main', 'main_nether', 'main_end', 'main_the_end', 'lobby', 'frontier_gate',
    'minecraft:overworld', 'minecraft:the_nether', 'minecraft:the_end'
)
if ($World -in $persistentNames) { throw "Persistent or entry world reset is forbidden: $World" }
if ($World -cne 'all' -and -not ($worldTargets.Keys -ccontains $World)) {
    throw "World is not on the exact resource reset allowlist: $World"
}

if (-not ($BackupDir.StartsWith($BackupRoot + $separator, [StringComparison]::OrdinalIgnoreCase))) {
    throw "Backup directory must be a child of $BackupRoot"
}
if ($BackupDir.StartsWith($MainDir + $separator, [StringComparison]::OrdinalIgnoreCase) -or
    $MainDir.StartsWith($BackupDir + $separator, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Backup directory and Main server directory must not contain one another.'
}
if (Test-Path -LiteralPath $BackupDir) { throw "Backup directory already exists: $BackupDir" }

$selected = if ($World -ceq 'all') { @($worldTargets.Keys) } else { @($World) }
$operations = foreach ($name in $selected) {
    $definition = $worldTargets[$name]
    $target = [IO.Path]::GetFullPath((Join-Path $MainDir $definition.RelativePath))
    $expected = [IO.Path]::GetFullPath((Join-Path $MainDir $definition.RelativePath))
    if ($target -ne $expected -or -not $target.StartsWith($MainDir + $separator, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Unsafe target path: $target"
    }

    $backupTarget = [IO.Path]::GetFullPath((Join-Path $BackupDir $name))
    if ($backupTarget -eq $target -or
        $backupTarget.StartsWith($target + $separator, [StringComparison]::OrdinalIgnoreCase) -or
        $target.StartsWith($backupTarget + $separator, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Source and backup paths must not be equal or nested: $target / $backupTarget"
    }

    [pscustomobject]@{
        Name = $name
        RuntimeKey = $definition.RuntimeKey
        Target = $target
        BackupTarget = $backupTarget
    }
}

foreach ($operation in $operations) {
    if (Test-Path -LiteralPath $operation.Target) {
        if ($PSCmdlet.ShouldProcess($operation.Target, "Back up $($operation.RuntimeKey), then delete disposable resource world")) {
            New-Item -ItemType Directory -Path (Split-Path -Parent $operation.BackupTarget) -Force | Out-Null
            Copy-Item -LiteralPath $operation.Target -Destination $operation.BackupTarget -Recurse

            $sourceFiles = Get-ChildItem -LiteralPath $operation.Target -Recurse -File -Force
            $backupFiles = Get-ChildItem -LiteralPath $operation.BackupTarget -Recurse -File -Force
            $sourceBytes = ($sourceFiles | Measure-Object Length -Sum).Sum
            $backupBytes = ($backupFiles | Measure-Object Length -Sum).Sum
            if ($sourceFiles.Count -ne $backupFiles.Count -or $sourceBytes -ne $backupBytes) {
                throw "Backup verification failed for $($operation.RuntimeKey)."
            }

            Remove-Item -LiteralPath $operation.Target -Recurse -Force
            Write-Host "Backed up $($operation.RuntimeKey) to $($operation.BackupTarget) and deleted $($operation.Target)"
        }
    } else {
        Write-Warning "World does not exist: $($operation.Target)"
    }
}

Write-Host 'Restart Main and recreate/import the resource worlds using the approved Multiverse procedure.'
