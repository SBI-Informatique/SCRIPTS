$TYPE_OS = (get-wmiobject -computer LocalHost win32_computersystem).Model
$TYPE_OS_VIRTUEL = $false

IF ($TYPE_OS = "Virtual Machine" -or $TYPE_OS -eq "VMware7,1") {
$TYPE_OS_VIRTUEL = $True
}

IF ($TYPE_OS_VIRTUEL = $False ) {
powershell.exe "(Get-WmiObject Win32_physicalMemoryArray).MemoryDevices"
} ELSE {
Write-Host "Virtuel"
}
