#Test de la version de Windows
$version= (Get-WmiObject Win32_OperatingSystem).Version
$length= $version.Length
$index= $version.IndexOf(".")
[int]$windows= $version.Remove($index,$length-2)  

IF ($windows -eq 10) {
$drive_type = (Get-PhysicalDisk | Select "MediaType").MediaType.Contains("SSD")
    if($drive_type) {
    write-host "SSD `r`n"
    } ELSE {
    write-host "HDD `r`n"
    }
} ELSE {
write-host ""
}
