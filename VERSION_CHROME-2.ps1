#Test de la version de Windows
$version= (Get-WmiObject Win32_OperatingSystem).Version
$length= $version.Length
$index= $version.IndexOf(".")
[int]$windows= $version.Remove($index,$length-2)  

$TEST_CLEE = (Test-Path -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome\")

IF ($TEST_CLEE) {
    IF ($windows -eq 10) {
    Get-ItemPropertyValue -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome\" -name "DisplayVersion"
    exit 1
    } ELSE {
    write-host "WIN7 `r`n"
    exit 1
    }
} ELSE {
    write-host "ABSENT `r`n"
    exit 2
}
