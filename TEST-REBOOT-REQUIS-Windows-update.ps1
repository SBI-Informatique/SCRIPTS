#Test de la version de Windows
$version= (Get-WmiObject Win32_OperatingSystem).Version
$length= $version.Length
$index= $version.IndexOf(".")
[int]$windows= $version.Remove($index,$length-2)  

IF ($windows -eq 10) {
$TEST-REGISTRE = test-path -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
    if($TEST-REGISTRE) {
    write-host "REBOOT-REQUIS"
    exit 1
    } ELSE {
    write-host "OK"
    exit 0
    }
} ELSE {
$TEST-REGISTRE = test-path -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
    if($TEST-REGISTRE) {
    write-host "REBOOT-REQUIS"
    exit 1
    } ELSE {
    write-host "OK"
    exit 0
    }
}
}
