#Test de la version de Windows
$version= (Get-WmiObject Win32_OperatingSystem).Version
$length= $version.Length
$index= $version.IndexOf(".")
[int]$windows= $version.Remove($index,$length-2)  

IF ($windows -eq 10) {
$drive_type = (Get-PhysicalDisk | Select "MediaType").MediaType.Contains("SSD")
    if($drive_type) {
    Get-ItemPropertyValue -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome\" -name "DisplayVersion"
    exit 1
    } ELSE {
    write-host "ABSENT `r`n"
    exit 2
    }
} ELSE {
$DiskScore = (Get-WmiObject -Class Win32_WinSAT).DiskScore
If ($DiskScore -gt 6.9) {
    write-host "SSD `r`n"
    exit 1
    } ELSE {
    write-host "HDD `r`n"
    exit 2
}
}
