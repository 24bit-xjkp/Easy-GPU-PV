﻿Function Get-HyperVEnabled {
if (Get-WindowsOptionalFeature -Online | Where-Object FeatureName -Like 'Microsoft-Hyper-V-All'){
    Return $true
    }
Else {
    Write-Warning "You need to enable Virtualisation in your motherboard and then add the Hyper-V Windows Feature and reboot"
    Return $false
    }
}

Function Get-WSLEnabled {
    if ((wsl -l -v)[2].length -gt 1 ) {
        Write-Warning "WSL is Enabled. This may interferre with GPU-P and produce an error 43 in the VM"
        Return $true
        }
    Else {
        Return $false
        }
}

Function Get-VMGpuPartitionAdapterFriendlyName {
    $Devices = (Get-WmiObject -Class "Msvm_PartitionableGpu" -ComputerName $env:COMPUTERNAME -Namespace "ROOT\virtualization\v2").name
    Foreach ($GPU in $Devices) {
        $GPUParse = $GPU.Split('#')[1]
        Get-WmiObject Win32_PNPSignedDriver | where {($_.HardwareID -eq "PCI\$GPUParse")} | select DeviceName -ExpandProperty DeviceName
        }
}

If (Get-HyperVEnabled) {
"System Compatible"
"Printing a list of compatible GPUs...May take a second"
"Copy the name of the GPU you want to share..."
Get-VMGpuPartitionAdapterFriendlyName
Read-Host -Prompt "Press Enter to Exit"
}
else {
Read-Host -Prompt "Press Enter to Exit"
}
