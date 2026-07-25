[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$BackupRelativePath,

    [ValidateSet('CompleteReset')]
    [string]$PlayerDataPolicy = 'CompleteReset',

    [string]$ConfirmationToken,

    [switch]$Execute
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$requiredToken = 'APPROVE-WAYFARER-MAIN-V006-REPLACEMENT-GENERATION'
$expectedSeed = '164225356311935743'
$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$backupRoot = (Resolve-Path -LiteralPath (Join-Path $root 'backups')).Path
$mainContainer = (Resolve-Path -LiteralPath (Join-Path $root 'servers/main/main')).Path
$expectedMainContainer = [IO.Path]::GetFullPath((Join-Path $root 'servers/main/main'))
$resourceRelativePaths = @(
    'dimensions/minecraft/resource',
    'dimensions/minecraft/resource_nether',
    'dimensions/minecraft/resource_end'
)
$persistentRelativePaths = @(
    'dimensions/minecraft/overworld',
    'dimensions/minecraft/the_nether',
    'dimensions/minecraft/the_end'
)
$configRelativePaths = @(
    'servers/main/server.properties',
    'servers/main/bukkit.yml',
    'servers/main/spigot.yml',
    'servers/main/config/paper-global.yml',
    'servers/main/config/paper-world-defaults.yml',
    'servers/main/plugins/BetterStructures/config.yml',
    'servers/main/plugins/BetterStructures/ValidWorlds.yml',
    'servers/main/plugins/Multiverse-Core/worlds.yml',
    'servers/main/plugins/Multiverse-NetherPortals/config.yml',
    'servers/main/plugins/FreeMinecraftModels/config.yml',
    'servers/main/plugins/ResourcePackManager/config.yml',
    'config/main-betterstructures/selection.yml',
    'config/main-betterstructures/prop-id-mapping.yml',
    'config/main-betterstructures/entity-removals.yml',
    'config/main-betterstructures/block-entity-removals.yml',
    'versions.yml',
    'plugin-manifest.yml'
)
$contentLock = [ordered]@{
    selectedStructures = 278
    sourceStructures = 430
    selectionSha256 = 'CD087809181C3B5AC0D0721F23596790DE6394A8A1CE2D9095E8D9BDACDEC774'
    propMappingSha256 = '9880FFF02B28E1BBEDA523EDEFABBB35BB00BD098C1657AC6F410F3581386347'
    entityRemovalsSha256 = 'D8D4B565448D425AE344D99BC49705DED59F6654D04E4082564AD5B4651964E7'
    blockEntityRemovalsSha256 = '324649CE4D18D4CFA822DE64FB68C8793E45CC36BEA878231428BE1CA1F8299B'
    betterStructuresSha256 = 'AA63FEF786CD55663BFF832BBD60C01C55C6E3A18603201C6D48FBA025782038'
    worldEditSha256 = '44C97EE6C1DF9AFA127DF3C5A2C6A7108F826FB44AB7B255A7EC4250FEB89B9D'
    freeMinecraftModelsSha256 = '3369C5EFE385B86460C2A596AB6284FF387874FB846669939B52486659327274'
    resourcePackManagerSha256 = '240809E885F37866EEB756854958B549C947CC7AEE078269DB0CDB18D97F1F64'
    generatedMainPackSha256 = '67DEC72DC042D47E90DEC47D2C822624E4BBFFB96E3B586103B12DE37886DD89'
}
$contentLockPaths = [ordered]@{
    selectionSha256 = 'config/main-betterstructures/selection.yml'
    propMappingSha256 = 'config/main-betterstructures/prop-id-mapping.yml'
    entityRemovalsSha256 = 'config/main-betterstructures/entity-removals.yml'
    blockEntityRemovalsSha256 = 'config/main-betterstructures/block-entity-removals.yml'
    betterStructuresSha256 = 'servers/main/plugins/BetterStructures.jar'
    worldEditSha256 = 'servers/main/plugins/worldedit-bukkit-7.4.4.jar'
    freeMinecraftModelsSha256 = 'servers/main/plugins/FreeMinecraftModels.jar'
    resourcePackManagerSha256 = 'servers/main/plugins/ResourcePackManager.jar'
    generatedMainPackSha256 = 'servers/main/plugins/ResourcePackManager/output/ResourcePackManager_RSP.zip'
}

function Assert-PathBelowRoot {
    param(
        [Parameter(Mandatory)]
        [string]$Path,
        [Parameter(Mandatory)]
        [string]$Boundary
    )

    $fullPath = [IO.Path]::GetFullPath($Path)
    $fullBoundary = [IO.Path]::GetFullPath($Boundary).TrimEnd('\') + '\'
    if (-not $fullPath.StartsWith($fullBoundary, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Path escapes the allowed boundary: $fullPath"
    }
    return $fullPath
}

function Get-TreeInventory {
    param([Parameter(Mandatory)][string]$Path)

    $base = (Resolve-Path -LiteralPath $Path).Path
    $files = @(Get-ChildItem -LiteralPath $base -Recurse -File -Force | Sort-Object FullName)
    $entries = foreach ($file in $files) {
        [pscustomobject]@{
            relativePath = $file.FullName.Substring($base.Length + 1).Replace('\', '/')
            bytes = [long]$file.Length
            sha256 = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
        }
    }

    [pscustomobject]@{
        path = $base
        fileCount = $files.Count
        byteTotal = [long](($files | Measure-Object Length -Sum).Sum)
        entries = @($entries)
    }
}

function Compare-TreeInventory {
    param(
        [Parameter(Mandatory)]$Expected,
        [Parameter(Mandatory)]$Actual,
        [Parameter(Mandatory)][string]$Label
    )

    if ($Expected.fileCount -ne $Actual.fileCount -or $Expected.byteTotal -ne $Actual.byteTotal) {
        throw "$Label file count or byte total mismatch."
    }

    $actualByPath = @{}
    foreach ($entry in $Actual.entries) {
        $actualByPath[$entry.relativePath] = $entry
    }
    foreach ($entry in $Expected.entries) {
        if (-not $actualByPath.ContainsKey($entry.relativePath)) {
            throw "$Label missing file: $($entry.relativePath)"
        }
        if ($actualByPath[$entry.relativePath].sha256 -ne $entry.sha256) {
            throw "$Label SHA-256 mismatch: $($entry.relativePath)"
        }
    }
}

if ($mainContainer -ne $expectedMainContainer) {
    throw "Unexpected Main container: $mainContainer"
}

if ($BackupRelativePath -notmatch '^backups/main-v006-replacement-generation-\d{8}-\d{6}\.incomplete$') {
    throw "BackupRelativePath does not match the task-specific allowlist pattern."
}

$backupIncomplete = Assert-PathBelowRoot -Path (Join-Path $root $BackupRelativePath) -Boundary $backupRoot
if ((Split-Path -Parent $backupIncomplete) -ne $backupRoot) {
    throw "Backup destination must be a direct child of $backupRoot"
}
$backupFinal = $backupIncomplete.Substring(0, $backupIncomplete.Length - '.incomplete'.Length)
if (Test-Path -LiteralPath $backupIncomplete) {
    throw "Incomplete backup destination already exists: $backupIncomplete"
}
if (Test-Path -LiteralPath $backupFinal) {
    throw "Final backup destination already exists: $backupFinal"
}
if ([IO.Path]::GetPathRoot($mainContainer) -ne [IO.Path]::GetPathRoot($backupIncomplete)) {
    throw 'Main container and backup destination are not on the same volume.'
}

$serverPorts = @(25565, 25566, 25567, 25568, 25569)
$listeners = @(Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
    Where-Object { $_.LocalPort -in $serverPorts })
if ($listeners.Count -ne 0) {
    throw "A Minecraft or Resource Pack listener is still active on a protected port."
}

$lockPath = Join-Path $mainContainer 'session.lock'
$lockStream = [IO.File]::Open(
    $lockPath,
    [IO.FileMode]::Open,
    [IO.FileAccess]::Read,
    [IO.FileShare]::None
)
$lockStream.Dispose()

$properties = Get-Content -LiteralPath (Join-Path $root 'servers/main/server.properties')
if ($properties -notcontains "level-seed=$expectedSeed") {
    throw "server.properties does not contain the expected level-seed."
}
if ($properties -notcontains 'level-name=main') {
    throw "server.properties does not contain level-name=main."
}

foreach ($lockName in $contentLockPaths.Keys) {
    $lockPath = Join-Path $root $contentLockPaths[$lockName]
    if (-not (Test-Path -LiteralPath $lockPath -PathType Leaf)) {
        throw "Required Content lock file is missing: $($contentLockPaths[$lockName])"
    }
    if ((Get-FileHash -LiteralPath $lockPath -Algorithm SHA256).Hash -ne $contentLock[$lockName]) {
        throw "Content lock SHA-256 mismatch: $($contentLockPaths[$lockName])"
    }
}

$mainBefore = Get-TreeInventory -Path $mainContainer
$resourceBefore = @{}
foreach ($relativePath in $resourceRelativePaths) {
    $resourceBefore[$relativePath] = Get-TreeInventory -Path (Join-Path $mainContainer $relativePath)
}
foreach ($relativePath in $persistentRelativePaths) {
    $null = Resolve-Path -LiteralPath (Join-Path $mainContainer $relativePath)
}

$preflight = [ordered]@{
    status = if ($Execute) { 'execute-ready' } else { 'dry-run-pass' }
    repositoryRoot = $root
    mainContainer = $mainContainer
    backupIncomplete = $backupIncomplete
    backupFinal = $backupFinal
    sameVolume = $true
    mainFileCount = $mainBefore.fileCount
    mainByteTotal = $mainBefore.byteTotal
    resourceWorlds = @($resourceRelativePaths | ForEach-Object {
        [ordered]@{
            relativePath = $_
            fileCount = $resourceBefore[$_].fileCount
            byteTotal = $resourceBefore[$_].byteTotal
        }
    })
    playerDataPolicy = $PlayerDataPolicy
    expectedSeed = $expectedSeed
    requiredConfirmationToken = $requiredToken
}

if (-not $Execute) {
    $preflight | ConvertTo-Json -Depth 6
    return
}

if ($ConfirmationToken -cne $requiredToken) {
    throw 'The exact destructive confirmation token was not supplied.'
}

$payloadRoot = Join-Path $backupIncomplete 'payload'
$backupWorldContainer = Join-Path $payloadRoot 'world/main'
$backupConfigRoot = Join-Path $payloadRoot 'config'

New-Item -ItemType Directory -Path (Split-Path -Parent $backupWorldContainer) | Out-Null
Move-Item -LiteralPath $mainContainer -Destination $backupWorldContainer

New-Item -ItemType Directory -Path $mainContainer | Out-Null
foreach ($relativePath in $resourceRelativePaths) {
    $source = Join-Path $backupWorldContainer $relativePath
    $destination = Join-Path $mainContainer $relativePath
    New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
    Copy-Item -LiteralPath $source -Destination $destination -Recurse
    $restored = Get-TreeInventory -Path $destination
    Compare-TreeInventory -Expected $resourceBefore[$relativePath] -Actual $restored -Label $relativePath
}

foreach ($relativePath in $configRelativePaths) {
    $source = Join-Path $root $relativePath
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "Required backup Config is missing: $relativePath"
    }
    $destination = Join-Path $backupConfigRoot $relativePath
    New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
    Copy-Item -LiteralPath $source -Destination $destination
    if ((Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash -ne
        (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash) {
        throw "Config SHA-256 mismatch after copy: $relativePath"
    }
}

$rollbackText = @"
# Main V0.0.6 replacement rollback

1. Prevent new player connections and stop every Minecraft component normally.
2. Move the replacement Main container at `$mainContainer` to a new task-specific quarantine directory.
3. Move `$(Join-Path $backupFinal 'payload/world/main')` back to `$mainContainer`.
4. Restore the Config files below `$(Join-Path $backupFinal 'payload/config')` to their recorded repository-relative paths.
5. Verify file count, byte total, and every SHA-256 in `sha256.txt`.
6. Start Main and verify the old seed, World UUIDs, spawns, Resource family, and Multiverse links.
7. Preserve this backup and the quarantined replacement candidate.
"@

New-Item -ItemType Directory -Path $backupIncomplete -Force | Out-Null
Set-Content -LiteralPath (Join-Path $backupIncomplete 'preflight.txt') `
    -Value ($preflight | ConvertTo-Json -Depth 6) -Encoding utf8
Set-Content -LiteralPath (Join-Path $backupIncomplete 'rollback.md') `
    -Value $rollbackText -Encoding utf8

$hashFiles = @(Get-ChildItem -LiteralPath $payloadRoot -Recurse -File -Force | Sort-Object FullName)
$hashFiles += Get-Item -LiteralPath (Join-Path $backupIncomplete 'preflight.txt')
$hashFiles += Get-Item -LiteralPath (Join-Path $backupIncomplete 'rollback.md')
$hashLines = foreach ($file in ($hashFiles | Sort-Object FullName)) {
    $relativePath = $file.FullName.Substring($backupIncomplete.Length + 1).Replace('\', '/')
    "$(Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256 | Select-Object -ExpandProperty Hash)  $relativePath"
}
$shaPath = Join-Path $backupIncomplete 'sha256.txt'
Set-Content -LiteralPath $shaPath -Value $hashLines -Encoding utf8

$manifest = [ordered]@{
    schemaVersion = 1
    timestamp = (Get-Date).ToString('o')
    gitHead = (git -C $root rev-parse HEAD)
    userLocalCopyAttestation = 'LOCAL-COPY-COMPLETE'
    approval = $ConfirmationToken
    playerDataPolicy = $PlayerDataPolicy
    seed = $expectedSeed
    sourcePath = $mainContainer
    backupIncompletePath = $backupIncomplete
    backupConfirmedPath = $backupFinal
    method = 'Move complete Main container on the same volume; restore only the three Resource dimensions before first boot.'
    payloadFileCount = $hashFiles.Count
    payloadByteTotal = [long](($hashFiles | Measure-Object Length -Sum).Sum)
    sha256List = 'sha256.txt'
    sha256ListSha256 = (Get-FileHash -LiteralPath $shaPath -Algorithm SHA256).Hash
    oldPersistentWorlds = @(
        [ordered]@{
            key = 'minecraft:overworld'
            bukkitName = 'main'
            relativePath = 'payload/world/main/dimensions/minecraft/overworld'
            uuid = '1994ef0e-887d-45d2-8860-7c1bb8e0a085'
            spawn = '320,70,128'
        },
        [ordered]@{
            key = 'minecraft:the_nether'
            bukkitName = 'main_nether'
            relativePath = 'payload/world/main/dimensions/minecraft/the_nether'
            uuid = '78d1c82f-f67e-47d7-9af4-06aadc7684a6'
            spawn = '20.5,60,-19.5'
        },
        [ordered]@{
            key = 'minecraft:the_end'
            bukkitName = 'main_the_end'
            relativePath = 'payload/world/main/dimensions/minecraft/the_end'
            uuid = 'e97d228f-11c4-46e6-b7b8-28f458c7a778'
            spawn = '100.5,49,0.5'
        }
    )
    resources = @($resourceRelativePaths | ForEach-Object {
        $identity = switch ($_){
            'dimensions/minecraft/resource' {
                @{ uuid = '32497466-e0eb-4992-806d-f58011cad5d8'; seed = '619713275114720998' }
            }
            'dimensions/minecraft/resource_nether' {
                @{ uuid = '3b494c31-7c24-49a6-a6c0-2891643086a0'; seed = '-7678977951546477015' }
            }
            'dimensions/minecraft/resource_end' {
                @{ uuid = '8c140721-4bbf-4fd3-8837-d250fd73bba3'; seed = '-2348607286205551648' }
            }
        }
        [ordered]@{
            relativePath = $_
            uuid = $identity.uuid
            seed = $identity.seed
            fileCount = $resourceBefore[$_].fileCount
            byteTotal = $resourceBefore[$_].byteTotal
            regionFileCount = @($resourceBefore[$_].entries |
                Where-Object { $_.relativePath -like 'region/*.mca' }).Count
        }
    })
    configRelativePaths = $configRelativePaths
    contentLock = $contentLock
    mainContainerFileCount = $mainBefore.fileCount
    mainContainerByteTotal = $mainBefore.byteTotal
}
$manifestPath = Join-Path $backupIncomplete 'manifest.json'
Set-Content -LiteralPath $manifestPath -Value ($manifest | ConvertTo-Json -Depth 8) -Encoding utf8

$recordedLines = Get-Content -LiteralPath $shaPath
foreach ($line in $recordedLines) {
    if ($line -notmatch '^([0-9A-F]{64})  (.+)$') {
        throw "Invalid SHA-256 list entry: $line"
    }
    $expectedHash = $Matches[1]
    $filePath = Join-Path $backupIncomplete $Matches[2].Replace('/', '\')
    if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
        throw "Backup verification found a missing file: $($Matches[2])"
    }
    if ((Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash -ne $expectedHash) {
        throw "Backup verification found a SHA-256 mismatch: $($Matches[2])"
    }
}

Move-Item -LiteralPath $backupIncomplete -Destination $backupFinal

[pscustomobject]@{
    status = 'complete'
    backupPath = $backupFinal
    manifestSha256 = (Get-FileHash -LiteralPath (Join-Path $backupFinal 'manifest.json') -Algorithm SHA256).Hash
    sha256ListSha256 = (Get-FileHash -LiteralPath (Join-Path $backupFinal 'sha256.txt') -Algorithm SHA256).Hash
    payloadFileCount = $hashFiles.Count
    payloadByteTotal = [long](($hashFiles | Measure-Object Length -Sum).Sum)
} | ConvertTo-Json -Depth 4
