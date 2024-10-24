param([string]$VMName = $(throw "Parameter missing: -VMName"),
    [string]$GPUName = $(throw "Parameter missing: -GPUName"),
    [decimal]$GPUResourceAllocationPercentage = 100,
    [string]$DriveLetter = ""
)

Import-Module $PSScriptRoot/Utility.psm1

Add-Adapter -VMName $VMName -GPUName $GPUName -GPUResourceAllocationPercentage $GPUResourceAllocationPercentage
