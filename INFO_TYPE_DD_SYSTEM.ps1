#Test de la version de Windows
$version= (Get-CimInstance Win32_OperatingSystem).version
$length= $version.Length
$index= $version.IndexOf(".")
[int]$windows= $version.Remove($index,$length-2)  

#WINDOWS 10
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
