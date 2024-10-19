param([string]$VMName = $(throw "Parameter missing: -VMName"),
    [string]$GPUName = $(throw "Parameter missing: -GPUName"),
    [decimal]$GPUResourceAllocationPercentage = 100,
    [string]$Hostname = $ENV:Computername
)

Import-Module $PSScriptRoot/Utility.psm1

"Add VM GPU partition adapter ..."
$PartitionableGPUList = Get-WmiObject -Class "Msvm_PartitionableGpu" -ComputerName $env:COMPUTERNAME -Namespace "ROOT\virtualization\v2"
if ($GPUName -eq "AUTO") {
    $DevicePathName = $PartitionableGPUList.Name[0]
    Add-VMGpuPartitionAdapter -VMName $VMName
}
else {
    $DeviceID = ((Get-WmiObject Win32_PNPSignedDriver | where { ($_.Devicename -eq "$GPUNAME") }).hardwareid).split('\')[1]
    $DevicePathName = ($PartitionableGPUList | Where-Object name -like "*$deviceid*").Name
    Add-VMGpuPartitionAdapter -VMName $VMName -InstancePath $DevicePathName
}

"Set VM GPU partition adapter ..."
[float]$devider = [math]::round($(100 / $GPUResourceAllocationPercentage), 2)
Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionVRAM ([math]::round($(1000000000 / $devider))) -MaxPartitionVRAM ([math]::round($(1000000000 / $devider))) -OptimalPartitionVRAM ([math]::round($(1000000000 / $devider)))
Set-VMGPUPartitionAdapter -VMName $VMName -MinPartitionEncode ([math]::round($(18446744073709551615 / $devider))) -MaxPartitionEncode ([math]::round($(18446744073709551615 / $devider))) -OptimalPartitionEncode ([math]::round($(18446744073709551615 / $devider)))
Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionDecode ([math]::round($(1000000000 / $devider))) -MaxPartitionDecode ([math]::round($(1000000000 / $devider))) -OptimalPartitionDecode ([math]::round($(1000000000 / $devider)))
Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionCompute ([math]::round($(1000000000 / $devider))) -MaxPartitionCompute ([math]::round($(1000000000 / $devider))) -OptimalPartitionCompute ([math]::round($(1000000000 / $devider)))

"Set VM GPU MMIO ..."
Set-VM -LowMemoryMappedIoSpace 1Gb -HighMemoryMappedIoSpace 32GB -GuestControlledCacheTypes $true -VMName $VMName
"GPU partition adapter configuration done ..."

Update-VMGpuPartitionDriver -VMName $VMName -GPUName $GPUName -Hostname $Hostname
