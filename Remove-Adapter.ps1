param([string]$VMName = $(throw "Parameter missing: -VMName"),
    [string]$GPUName = $(throw "Parameter missing: -GPUName")
)

Import-Module $PSScriptRoot/Utility.psm1

$AdapterId = Get-AdapterId -VMName $VMName -GPUName $GPUName
Remove-VMGpuPartitionAdapter -VMName $VMName -AdapterId $AdapterId
