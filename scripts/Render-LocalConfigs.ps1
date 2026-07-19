[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'Render-NetworkConfig.ps1')
& (Join-Path $PSScriptRoot 'Render-LuckPermsConfig.ps1')
& (Join-Path $PSScriptRoot 'Render-mcMMOConfig.ps1')
& (Join-Path $PSScriptRoot 'Render-RedisEconomyConfig.ps1')
