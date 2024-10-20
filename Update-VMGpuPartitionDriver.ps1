param (
    [string]$VMName = $(throw "Parameter missing: -VMName"),
    [string]$GPUName = $(throw "Parameter missing: -GPUName"),
    [string]$Hostname = $ENV:Computername,
    [string]$DriveLetter = ""
)

Import-Module $PSScriptRoot/Utility.psm1

Update-VMGpuPartitionDriver -VMName $VMName -GPUName $GPUName -Hostname $Hostname -DriveLetter $DriveLetter
