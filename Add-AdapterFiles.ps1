param([string]$VMName = $(throw "Parameter missing: -VMName"),
    [string]$GPUName = $(throw "Parameter missing: -GPUName"),
    [decimal]$GPUResourceAllocationPercentage = 100,
    [string]$Hostname = $ENV:Computername,
    [string]$DriveLetter = ""
)

Import-Module $PSScriptRoot/Utility.psm1

Add-Adapter -VMName $VMName -GPUName $GPUName -GPUResourceAllocationPercentage $GPUResourceAllocationPercentage
Update-VMGpuPartitionDriver -VMName $VMName -GPUName $GPUName -Hostname $Hostname -DriveLetter $DriveLetter
