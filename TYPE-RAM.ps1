#Test de la version de Windows
$version= (Get-WmiObject Win32_OperatingSystem).Version
$length= $version.Length
$index= $version.IndexOf(".")
[int]$windows= $version.Remove($index,$length-2)  

IF ($windows -eq 10) {
(Get-WmiObject Win32_PhysicalMemory).PartNumber | Format-Table -HideTableHeaders
exit 1
} ELSE {
write-host ""
exit 0
}
