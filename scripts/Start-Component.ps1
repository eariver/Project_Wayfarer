[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('velocity','lobby','main','frontier')]
    [string]$Name
)

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$PathsFile = Join-Path $Root 'local/paths.psd1'
if (-not (Test-Path $PathsFile)) {
    throw 'Missing local/paths.psd1. Copy and edit local/paths.psd1.example first.'
}
$Paths = Import-PowerShellDataFile $PathsFile

$components = @{
    velocity = @{ Dir = 'velocity'; Jar = 'velocity.jar'; Java = $Paths.Java25; Memory = @('-Xms256M','-Xmx512M') }
    lobby = @{ Dir = 'servers/lobby'; Jar = 'paper.jar'; Java = $Paths.Java25; Memory = @('-Xms512M','-Xmx2G') }
    main = @{ Dir = 'servers/main'; Jar = 'paper.jar'; Java = $Paths.Java25; Memory = @('-Xms2G','-Xmx6G') }
    frontier = @{ Dir = 'servers/frontier'; Jar = 'paper.jar'; Java = $Paths.Java21; Memory = @('-Xms2G','-Xmx6G') }
}

$c = $components[$Name]
$workDir = Join-Path $Root $c.Dir
$jarPath = Join-Path $workDir $c.Jar
if (-not (Test-Path $c.Java)) { throw "Java executable not found: $($c.Java)" }
if (-not (Test-Path $jarPath)) { throw "Server JAR not found: $jarPath" }

Push-Location $workDir
try {
    $launchArgs = @($c.Memory) + @('-jar', $c.Jar)
    if ($Name -ne 'velocity') {
        $launchArgs += '--nogui'
    }
    & $c.Java @launchArgs
}
finally {
    Pop-Location
}
