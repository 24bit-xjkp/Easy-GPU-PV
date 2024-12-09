param([string]$VMName = $(throw "Parameter missing: -VMName"),
    [string]$GPUName = $(throw "Parameter missing: -GPUName")
)

Import-Module $PSScriptRoot/Utility.psm1

If ($GPUName -ne "All") {
    $AdapterId = Get-AdapterId -VMName $VMName -GPUName $GPUName
    Remove-VMGpuPartitionAdapter -VMName $VMName -AdapterId $AdapterId
}
Else {
    # 移除所有gpu分区
    Remove-VMGpuPartitionAdapter -VMName $VMName
}
