#Test de la version de Windows
$version= (Get-WmiObject Win32_OperatingSystem).Version
$length= $version.Length
$index= $version.IndexOf(".")
[int]$windows= $version.Remove($index,$length-2)  

$User = $args[0]
$Password = $args[1]

IF ($windows -eq 10) {
New-LocalUser -Name $User -Description "Utilisateur administrateur SBI" -Password $Password
exit 1
} ELSE {
cmd.exe /c net user $User $Password /add
cmd.exe /c net user $User /active:yes
cmd.exe /c net localgroup administrateurs $User /add
exit 1
}
