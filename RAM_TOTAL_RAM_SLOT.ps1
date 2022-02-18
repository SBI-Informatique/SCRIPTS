$TYPE_OS = (get-wmiobject -computer LocalHost win32_computersystem).Model
$TYPE_OS_VIRTUEL = $False

IF ($TYPE_OS -eq "Virtual Machine" -or $TYPE_OS -eq "VMware7,1") {
$TYPE_OS_VIRTUEL = $True
}

IF ($TYPE_OS_VIRTUEL -eq $False ) {
powershell.exe "(Get-WmiObject Win32_physicalMemoryArray).MemoryDevices"
} ELSE {
Write-Host "Virtuel"
}
