[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$BackupRelativePath,

    [string]$ConfirmationToken,

    [switch]$Execute
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$requiredToken = 'APPROVE-WAYFARER-MAIN-V006-FINAL-BASELINE'
$expectedSeed = '164225356311935743'
$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$backupRoot = (Resolve-Path -LiteralPath (Join-Path $root 'backups')).Path
$mainContainer = (Resolve-Path -LiteralPath (Join-Path $root 'servers/main/main')).Path
$expectedMainContainer = [IO.Path]::GetFullPath((Join-Path $root 'servers/main/main'))
$protectedPorts = @(25565, 25566, 25567, 25568, 25569)
$minimumSafetyBytes = 2GB

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

$persistentWorlds = @(
    [ordered]@{
        key = 'minecraft:overworld'
        bukkitName = 'main'
        relativePath = 'dimensions/minecraft/overworld'
        uuid = 'd868e7ff-6663-492d-a963-f95f00ce6c30'
        seed = $expectedSeed
        spawn = '320,70,128'
        expectedRegionCount = 17
    },
    [ordered]@{
        key = 'minecraft:the_nether'
        bukkitName = 'main_nether'
        relativePath = 'dimensions/minecraft/the_nether'
        uuid = '1225688f-7770-43ed-b1dd-71bd112de3b5'
        seed = $expectedSeed
        spawn = '20.5,60,-19.5'
        expectedRegionCount = 11
    },
    [ordered]@{
        key = 'minecraft:the_end'
        bukkitName = 'main_the_end'
        relativePath = 'dimensions/minecraft/the_end'
        uuid = '436843c4-2229-4c67-907c-b3a7d1530d71'
        seed = $expectedSeed
        spawn = '100.5,49,0.5'
        expectedRegionCount = 18
    }
)

$resourceWorlds = @(
    [ordered]@{
        key = 'minecraft:resource'
        bukkitName = 'resource'
        relativePath = 'dimensions/minecraft/resource'
        uuid = '32497466-e0eb-4992-806d-f58011cad5d8'
        seed = '619713275114720998'
        expectedRegionCount = 8
    },
    [ordered]@{
        key = 'minecraft:resource_nether'
        bukkitName = 'resource_nether'
        relativePath = 'dimensions/minecraft/resource_nether'
        uuid = '3b494c31-7c24-49a6-a6c0-2891643086a0'
        seed = '-7678977951546477015'
        expectedRegionCount = 4
    },
    [ordered]@{
        key = 'minecraft:resource_end'
        bukkitName = 'resource_end'
        relativePath = 'dimensions/minecraft/resource_end'
        uuid = '8c140721-4bbf-4fd3-8837-d250fd73bba3'
        seed = '-2348607286205551648'
        expectedRegionCount = 4
    }
)

$artifactLocks = [ordered]@{
    'servers/main/plugins/BetterStructures.jar' = 'AA63FEF786CD55663BFF832BBD60C01C55C6E3A18603201C6D48FBA025782038'
    'servers/main/plugins/worldedit-bukkit-7.4.4.jar' = '44C97EE6C1DF9AFA127DF3C5A2C6A7108F826FB44AB7B255A7EC4250FEB89B9D'
    'servers/main/plugins/FreeMinecraftModels.jar' = '3369C5EFE385B86460C2A596AB6284FF387874FB846669939B52486659327274'
    'servers/main/plugins/ResourcePackManager.jar' = '240809E885F37866EEB756854958B549C947CC7AEE078269DB0CDB18D97F1F64'
    'manual-downloads/betterstructures/content/bs-default-builds-default-structures.zip' = '118D873FDF87BF94EA6CA3036897B10790F5D73E62F8387E75C1AB6A4A360FE0'
    'manual-downloads/main-betterstructures-v006/bs-exploration-exploration-pack.zip' = '963CABA2D8BA31E8DA2E0E73D098A57B66E80D6ECF55BBC92CBD7D04F7F4BA4B'
    'manual-downloads/main-betterstructures-v006/bs-caves-and-lost-civilizations-free-caves-and-lost-civilizations-free.zip' = '27527F2713858EE47029C2AE9DE72D74C164FC52297672DBEEAA81BA62C25677'
    'manual-downloads/main-betterstructures-v006/bs-adventure-adventure-pack.zip' = '96061E1166767BEC12087D55C0A7353AE42B970EFE617ACF4B1AF550BDE6AB4C'
    'manual-downloads/main-betterstructures-v006/bs-echoes-of-the-past-echoes-of-the-past.zip' = 'B2F971EB0B27FA9BBDA6BD6503875718621146CEC7E671F0D05366E918CCB51F'
    'manual-downloads/main-betterstructures-v006/betterstructures-prop-pack-betterstructures-prop-pack.zip' = 'F39E9C7B5CACA49462A6CC2634F6C2D49DD0F7498744D7DE7960887CC694C04D'
    'local/work/main-betterstructures-v006/generated/betterstructures-imports/bs-default-builds-default-structures.zip' = 'A4373A2692590734D7D95051819722ED05985A49668BDADDF83B1999D2964463'
    'local/work/main-betterstructures-v006/generated/betterstructures-imports/bs-exploration-exploration-pack.zip' = 'CF9FB95A81ACA8993B1781FC784DB9D14B360E40C5B6C613D31019BC845A91E0'
    'local/work/main-betterstructures-v006/generated/betterstructures-imports/bs-caves-and-lost-civilizations-free-caves-and-lost-civilizations-free.zip' = 'CF3E34EEE926DFDD6C67703013298663227BA71AFFA398ED81DD9A6E421478D9'
    'local/work/main-betterstructures-v006/generated/betterstructures-imports/bs-adventure-adventure-pack.zip' = '13949D75D0E5A813EBE7CCBBF6D0D32D9243424BF183D5B2006FA22F339C1F8A'
    'local/work/main-betterstructures-v006/generated/betterstructures-imports/bs-echoes-of-the-past-echoes-of-the-past.zip' = '63D924CF4BFBA5305C8720418D1684AD809B0FAB0385B7439D2259681AE6E0A7'
}

$configLocks = [ordered]@{
    'config/main-betterstructures/selection.yml' = 'CD087809181C3B5AC0D0721F23596790DE6394A8A1CE2D9095E8D9BDACDEC774'
    'config/main-betterstructures/prop-id-mapping.yml' = '9880FFF02B28E1BBEDA523EDEFABBB35BB00BD098C1657AC6F410F3581386347'
    'config/main-betterstructures/entity-removals.yml' = 'D8D4B565448D425AE344D99BC49705DED59F6654D04E4082564AD5B4651964E7'
    'config/main-betterstructures/block-entity-removals.yml' = '324649CE4D18D4CFA822DE64FB68C8793E45CC36BEA878231428BE1CA1F8299B'
}

$generatedPackPaths = [ordered]@{
    main = 'servers/main/plugins/ResourcePackManager/output/ResourcePackManager_RSP.zip'
    fmm = 'servers/main/plugins/FreeMinecraftModels/output/FreeMinecraftModels.zip'
}

function Assert-PathBelowRoot {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Boundary
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
        [ordered]@{
            relativePath = $file.FullName.Substring($base.Length + 1).Replace('\', '/')
            bytes = [long]$file.Length
            sha256 = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
        }
    }

    [ordered]@{
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

    if ($Expected.fileCount -ne $Actual.fileCount) {
        throw "$Label file count mismatch: expected $($Expected.fileCount), actual $($Actual.fileCount)"
    }
    if ($Expected.byteTotal -ne $Actual.byteTotal) {
        throw "$Label byte total mismatch: expected $($Expected.byteTotal), actual $($Actual.byteTotal)"
    }

    $actualByPath = @{}
    foreach ($entry in $Actual.entries) {
        $actualByPath[$entry.relativePath] = $entry
    }
    foreach ($entry in $Expected.entries) {
        if (-not $actualByPath.ContainsKey($entry.relativePath)) {
            throw "$Label missing file: $($entry.relativePath)"
        }
        if ($actualByPath[$entry.relativePath].bytes -ne $entry.bytes) {
            throw "$Label byte mismatch: $($entry.relativePath)"
        }
        if ($actualByPath[$entry.relativePath].sha256 -ne $entry.sha256) {
            throw "$Label SHA-256 mismatch: $($entry.relativePath)"
        }
    }
}

function Get-RegionInventory {
    param([Parameter(Mandatory)][string]$WorldPath)

    $regionPath = Join-Path $WorldPath 'region'
    if (-not (Test-Path -LiteralPath $regionPath -PathType Container)) {
        throw "World region directory is missing: $regionPath"
    }
    $files = @(Get-ChildItem -LiteralPath $regionPath -File -Filter '*.mca' | Sort-Object Name)
    [ordered]@{
        count = $files.Count
        files = @($files | ForEach-Object {
            [ordered]@{
                name = $_.Name
                bytes = [long]$_.Length
                sha256 = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
            }
        })
    }
}

function Compare-RegionInventory {
    param(
        [Parameter(Mandatory)]$Expected,
        [Parameter(Mandatory)]$Actual,
        [Parameter(Mandatory)][string]$Label
    )

    if ($Expected.count -ne $Actual.count) {
        throw "$Label region count mismatch."
    }
    $actualByName = @{}
    foreach ($entry in $Actual.files) {
        $actualByName[$entry.name] = $entry
    }
    foreach ($entry in $Expected.files) {
        if (-not $actualByName.ContainsKey($entry.name)) {
            throw "$Label missing region file: $($entry.name)"
        }
        if ($actualByName[$entry.name].sha256 -ne $entry.sha256) {
            throw "$Label region SHA-256 mismatch: $($entry.name)"
        }
    }
}

function Get-FileHashRecord {
    param([Parameter(Mandatory)][string]$RelativePath)

    $path = Join-Path $root $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Required file is missing: $RelativePath"
    }
    $file = Get-Item -LiteralPath $path
    [ordered]@{
        relativePath = $RelativePath.Replace('\', '/')
        bytes = [long]$file.Length
        sha256 = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
    }
}

if ($mainContainer -ne $expectedMainContainer) {
    throw "Unexpected Main container: $mainContainer"
}
if ($BackupRelativePath -notmatch '^backups/main-v006-final-baseline-\d{8}-\d{6}\.incomplete$') {
    throw 'BackupRelativePath does not match the task-specific allowlist pattern.'
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
if ($Execute -and $ConfirmationToken -cne $requiredToken) {
    throw 'The exact case-sensitive final-baseline confirmation token was not supplied.'
}

$serverJavaProcesses = @(Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
    Where-Object {
        $_.Name -in @('java.exe', 'javaw.exe') -and
        (
            $_.CommandLine -match '(?i)(?:^|\s)-jar\s+(?:"[^"]*[\\/])?(?:paper|velocity)\.jar(?:\s|$)' -or
            $_.CommandLine -like "*$root*"
        )
    })
if ($serverJavaProcesses.Count -ne 0) {
    throw 'A Project Wayfarer server Java process is still running.'
}
$listeners = @(Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
    Where-Object { $_.LocalPort -in $protectedPorts })
if ($listeners.Count -ne 0) {
    throw 'A Minecraft or Resource Pack listener is still active on a protected port.'
}

$sessionLock = Join-Path $mainContainer 'session.lock'
if (-not (Test-Path -LiteralPath $sessionLock -PathType Leaf)) {
    throw "Main session.lock is missing: $sessionLock"
}
$lockStream = [IO.File]::Open(
    $sessionLock,
    [IO.FileMode]::Open,
    [IO.FileAccess]::Read,
    [IO.FileShare]::None
)
$lockStream.Dispose()

$serverProperties = Get-Content -LiteralPath (Join-Path $root 'servers/main/server.properties')
if ($serverProperties -notcontains "level-seed=$expectedSeed") {
    throw 'server.properties does not contain the expected Main seed.'
}
if ($serverProperties -notcontains 'level-name=main') {
    throw 'server.properties does not contain level-name=main.'
}

$betterStructuresConfig = Get-Content -LiteralPath (Join-Path $root 'servers/main/plugins/BetterStructures/config.yml')
foreach ($requiredLine in @(
    'setupDone: true',
    'spawnProtectionRadius: 100',
    '  autoDownloadPluginUpdates: false'
)) {
    if ($betterStructuresConfig -notcontains $requiredLine) {
        throw "BetterStructures Config invariant is missing: $requiredLine"
    }
}
$validWorldsConfig = Get-Content -LiteralPath (Join-Path $root 'servers/main/plugins/BetterStructures/ValidWorlds.yml')
foreach ($requiredLine in @(
    'New worlds spawn structures: false',
    '  main: true',
    '  main_nether: true',
    '  main_the_end: true',
    '  resource: false',
    '  resource_nether: false',
    '  resource_end: false'
)) {
    if ($validWorldsConfig -notcontains $requiredLine) {
        throw "BetterStructures world allowlist invariant is missing: $requiredLine"
    }
}

foreach ($relativePath in $configRelativePaths) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $relativePath) -PathType Leaf)) {
        throw "Required Config snapshot source is missing: $relativePath"
    }
}

$artifactRecords = [ordered]@{}
foreach ($relativePath in $artifactLocks.Keys) {
    $record = Get-FileHashRecord -RelativePath $relativePath
    if ($record.sha256 -ne $artifactLocks[$relativePath]) {
        throw "Artifact lock mismatch: $relativePath"
    }
    $artifactRecords[$relativePath] = $record
}

foreach ($relativePath in $configLocks.Keys) {
    $record = Get-FileHashRecord -RelativePath $relativePath
    if ($record.sha256 -ne $configLocks[$relativePath]) {
        throw "Content Config lock mismatch: $relativePath"
    }
}

$generatedPackHashes = [ordered]@{}
foreach ($name in $generatedPackPaths.Keys) {
    $record = Get-FileHashRecord -RelativePath $generatedPackPaths[$name]
    $path = Join-Path $root $generatedPackPaths[$name]
    $record.sha1 = (Get-FileHash -LiteralPath $path -Algorithm SHA1).Hash
    $generatedPackHashes[$name] = $record
}

$mainSource = Get-TreeInventory -Path $mainContainer
$requiredFreeBytes = [long]($mainSource.byteTotal * 2 + $minimumSafetyBytes)
$drive = Get-PSDrive -Name ([IO.Path]::GetPathRoot($backupRoot).Substring(0, 1))
if ([long]$drive.Free -lt $requiredFreeBytes) {
    throw "Insufficient free disk space. Required: $requiredFreeBytes; available: $($drive.Free)"
}

$persistentRegionInventories = [ordered]@{}
foreach ($world in $persistentWorlds) {
    $worldPath = Join-Path $mainContainer $world.relativePath
    if (-not (Test-Path -LiteralPath $worldPath -PathType Container)) {
        throw "Persistent world is missing: $($world.relativePath)"
    }
    $regions = Get-RegionInventory -WorldPath $worldPath
    if ($regions.count -ne $world.expectedRegionCount) {
        throw "Persistent region count mismatch for $($world.bukkitName)."
    }
    $persistentRegionInventories[$world.bukkitName] = $regions
}

$resourceRegionInventories = [ordered]@{}
foreach ($world in $resourceWorlds) {
    $worldPath = Join-Path $mainContainer $world.relativePath
    if (-not (Test-Path -LiteralPath $worldPath -PathType Container)) {
        throw "Resource world is missing: $($world.relativePath)"
    }
    $regions = Get-RegionInventory -WorldPath $worldPath
    if ($regions.count -ne $world.expectedRegionCount) {
        throw "Resource region count mismatch for $($world.bukkitName)."
    }
    $resourceRegionInventories[$world.bukkitName] = $regions
}

$configSha256 = [ordered]@{}
foreach ($relativePath in $configRelativePaths) {
    $configSha256[$relativePath] = (Get-FileHash -LiteralPath (Join-Path $root $relativePath) -Algorithm SHA256).Hash
}

$preflight = [ordered]@{
    schemaVersion = 1
    status = if ($Execute) { 'execute-ready' } else { 'dry-run-pass' }
    repositoryRoot = $root
    gitHead = (git -C $root rev-parse HEAD).Trim()
    sourceMainContainer = $mainContainer
    backupIncompletePath = $backupIncomplete
    backupFinalPath = $backupFinal
    order6Decision = 'A - accept current Config as-is'
    requiredConfirmationToken = $requiredToken
    sourceFileCount = $mainSource.fileCount
    sourceByteTotal = $mainSource.byteTotal
    diskFreeBytes = [long]$drive.Free
    diskRequiredBytes = $requiredFreeBytes
    copyMethod = 'Stopped-state recursive file copy; source Main container remains unchanged.'
    persistentRegionCounts = [ordered]@{
        main = $persistentRegionInventories.main.count
        main_nether = $persistentRegionInventories.main_nether.count
        main_the_end = $persistentRegionInventories.main_the_end.count
    }
    resourceRegionCounts = [ordered]@{
        resource = $resourceRegionInventories.resource.count
        resource_nether = $resourceRegionInventories.resource_nether.count
        resource_end = $resourceRegionInventories.resource_end.count
    }
    resourceRegionHashStatus = 'all-current-region-files-recorded'
    seed = $expectedSeed
    persistentWorlds = $persistentWorlds
    resourceWorlds = $resourceWorlds
    selectionCounts = [ordered]@{ source = 430; enabled = 278; disabled = 152 }
    fmmModelCount = 55
    configSha256 = $configSha256
    artifactLocks = $artifactRecords
    generatedPackHashes = $generatedPackHashes
}

if (-not $Execute) {
    $preflight | ConvertTo-Json -Depth 12
    return
}

$payloadRoot = Join-Path $backupIncomplete 'payload'
$backupWorldParent = Join-Path $payloadRoot 'world'
$backupWorldContainer = Join-Path $backupWorldParent 'main'
$backupConfigRoot = Join-Path $payloadRoot 'config'

New-Item -ItemType Directory -Path $backupWorldParent -Force | Out-Null
Copy-Item -LiteralPath $mainContainer -Destination $backupWorldParent -Recurse
if (-not (Test-Path -LiteralPath $backupWorldContainer -PathType Container)) {
    throw 'The complete Main container copy was not created at the expected path.'
}

foreach ($relativePath in $configRelativePaths) {
    $source = Join-Path $root $relativePath
    $destination = Join-Path $backupConfigRoot $relativePath
    New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
    Copy-Item -LiteralPath $source -Destination $destination
}

$mainPayload = Get-TreeInventory -Path $backupWorldContainer
Compare-TreeInventory -Expected $mainSource -Actual $mainPayload -Label 'Complete Main container'

foreach ($relativePath in $configRelativePaths) {
    $source = Join-Path $root $relativePath
    $destination = Join-Path $backupConfigRoot $relativePath
    $sourceHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
    $destinationHash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash
    if ($sourceHash -ne $destinationHash) {
        throw "Config Snapshot SHA-256 mismatch: $relativePath"
    }
}

foreach ($world in $persistentWorlds) {
    $payloadRegions = Get-RegionInventory -WorldPath (Join-Path $backupWorldContainer $world.relativePath)
    Compare-RegionInventory -Expected $persistentRegionInventories[$world.bukkitName] `
        -Actual $payloadRegions -Label $world.bukkitName
}
foreach ($world in $resourceWorlds) {
    $payloadRegions = Get-RegionInventory -WorldPath (Join-Path $backupWorldContainer $world.relativePath)
    Compare-RegionInventory -Expected $resourceRegionInventories[$world.bukkitName] `
        -Actual $payloadRegions -Label $world.bukkitName
}

$restoreText = @"
# Project Wayfarer Main V0.0.6 Final Baseline restore

1. Reject new connections and stop Velocity and all Paper backends normally.
2. Confirm that no Java process or protected listener remains.
3. Move the current `$mainContainer` to a new, task-specific quarantine path.
4. Copy `$backupFinal\payload\world\main` to `$mainContainer`; do not move or delete this backup.
5. Restore each repository-relative Config from `$backupFinal\payload\config`.
6. Verify the source file count, byte total, relative path set, and every SHA-256 in `sha256.txt`.
7. Verify seed `$expectedSeed`, persistent UUIDs and spawns, and region counts 17 / 11 / 18.
8. Verify Resource UUIDs and seeds, region counts 8 / 4 / 4, and every recorded Resource region SHA-256.
9. Verify Multiverse registration and the persistent/resource portal-family boundaries.
10. Start Main and verify Plugin/Pack loading and one accepted BetterStructures structure.
11. Preserve both this Final Baseline backup and the quarantined runtime until a separate restore task closes.

This script does not execute restore operations.
"@

$validation = [ordered]@{
    schemaVersion = 1
    timestamp = (Get-Date).ToString('o')
    status = 'pass'
    sourceUnchangedByMethod = $true
    sourcePayloadFileCountMatch = $true
    sourcePayloadByteTotalMatch = $true
    sourcePayloadRelativePathSetMatch = $true
    sourcePayloadAllSha256Match = $true
    configSnapshotAllSha256Match = $true
    persistentRegionCountMatch = $true
    resourceRegionCountMatch = $true
    resourceRegionAllSha256Match = $true
    incompletePreservedOnFailure = $true
    finalRenameAllowed = $true
}

Set-Content -LiteralPath (Join-Path $backupIncomplete 'preflight.json') `
    -Value ($preflight | ConvertTo-Json -Depth 12) -Encoding utf8
Set-Content -LiteralPath (Join-Path $backupIncomplete 'restore.md') `
    -Value $restoreText -Encoding utf8
Set-Content -LiteralPath (Join-Path $backupIncomplete 'validation.json') `
    -Value ($validation | ConvertTo-Json -Depth 6) -Encoding utf8

$shaFiles = @(Get-ChildItem -LiteralPath $backupIncomplete -Recurse -File -Force |
    Where-Object { $_.Name -notin @('manifest.json', 'sha256.txt') } |
    Sort-Object FullName)
$shaLines = foreach ($file in $shaFiles) {
    $relativePath = $file.FullName.Substring($backupIncomplete.Length + 1).Replace('\', '/')
    "$((Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash)  $relativePath"
}
$shaPath = Join-Path $backupIncomplete 'sha256.txt'
Set-Content -LiteralPath $shaPath -Value $shaLines -Encoding utf8
$shaListSha256 = (Get-FileHash -LiteralPath $shaPath -Algorithm SHA256).Hash

$manifest = [ordered]@{
    schemaVersion = 1
    timestamp = (Get-Date).ToString('o')
    gitHead = (git -C $root rev-parse HEAD).Trim()
    approvalToken = $ConfirmationToken
    order6Decision = 'A'
    proposalId = $null
    sourceMainContainer = $mainContainer
    backupIncompletePath = $backupIncomplete
    backupFinalPath = $backupFinal
    copyMethod = 'Stopped-state recursive file copy; source Main container remains unchanged.'
    sourceFileCount = $mainSource.fileCount
    sourceByteTotal = $mainSource.byteTotal
    payloadFileCount = $mainPayload.fileCount
    payloadByteTotal = $mainPayload.byteTotal
    sha256ListSha256 = $shaListSha256
    seed = $expectedSeed
    persistentWorlds = $persistentWorlds
    resourceWorlds = $resourceWorlds
    regionCounts = [ordered]@{
        persistent = [ordered]@{
            main = $persistentRegionInventories.main.count
            main_nether = $persistentRegionInventories.main_nether.count
            main_the_end = $persistentRegionInventories.main_the_end.count
        }
        resource = [ordered]@{
            resource = $resourceRegionInventories.resource.count
            resource_nether = $resourceRegionInventories.resource_nether.count
            resource_end = $resourceRegionInventories.resource_end.count
        }
    }
    resourceRegionHashes = [ordered]@{
        resource = $resourceRegionInventories.resource.files
        resource_nether = $resourceRegionInventories.resource_nether.files
        resource_end = $resourceRegionInventories.resource_end.files
    }
    spawn = [ordered]@{
        main = '320,70,128'
        main_nether = '20.5,60,-19.5'
        main_the_end = '100.5,49,0.5'
    }
    worldUUIDs = [ordered]@{
        main = 'd868e7ff-6663-492d-a963-f95f00ce6c30'
        main_nether = '1225688f-7770-43ed-b1dd-71bd112de3b5'
        main_the_end = '436843c4-2229-4c67-907c-b3a7d1530d71'
        resource = '32497466-e0eb-4992-806d-f58011cad5d8'
        resource_nether = '3b494c31-7c24-49a6-a6c0-2891643086a0'
        resource_end = '8c140721-4bbf-4fd3-8837-d250fd73bba3'
    }
    configRelativePaths = $configRelativePaths
    configSha256 = $configSha256
    artifactLocks = $artifactRecords
    generatedPackHashes = $generatedPackHashes
    selectionCounts = [ordered]@{ source = 430; enabled = 278; disabled = 152 }
    acceptedPacks = @(
        '103 Default Structures v5',
        'Exploration Pack v6',
        'Caves and Lost Civilizations Free v2',
        'Adventure Pack v1',
        'Echoes of the Past v3'
    )
    acceptedStructures = @(
        'Default Mine Storage',
        'Caves Circle Dungeon',
        'Echoes Nether Wall',
        'Echoes End Shrine',
        'Exploration Bridge Cave'
    )
    restoreProcedure = 'restore.md'
}
$manifestPath = Join-Path $backupIncomplete 'manifest.json'
Set-Content -LiteralPath $manifestPath -Value ($manifest | ConvertTo-Json -Depth 14) -Encoding utf8

foreach ($line in (Get-Content -LiteralPath $shaPath)) {
    if ($line -notmatch '^([0-9A-F]{64})  (.+)$') {
        throw "Invalid SHA-256 list entry: $line"
    }
    $expectedHash = $Matches[1]
    $relativePath = $Matches[2]
    $filePath = Join-Path $backupIncomplete $relativePath.Replace('/', '\')
    if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
        throw "Backup verification found a missing file: $relativePath"
    }
    if ((Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash -ne $expectedHash) {
        throw "Backup verification found a SHA-256 mismatch: $relativePath"
    }
}

$manifestSha256 = (Get-FileHash -LiteralPath $manifestPath -Algorithm SHA256).Hash
Move-Item -LiteralPath $backupIncomplete -Destination $backupFinal

[ordered]@{
    status = 'complete'
    backupPath = $backupFinal
    manifestSha256 = $manifestSha256
    sha256ListSha256 = $shaListSha256
    payloadFileCount = $mainPayload.fileCount
    payloadByteTotal = $mainPayload.byteTotal
    sourcePayloadAllSha256Match = $true
} | ConvertTo-Json -Depth 4
