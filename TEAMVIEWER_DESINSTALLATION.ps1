# Déclaration des variables

$REGISTRE_SBI = Test-Path -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI"
$REGISTRE_TEAMVIEWER = Test-Path -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI\TEAMVIEWER"
$REGISTREVALUE_TEAMVIEWER_PRESENT = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI\TEAMVIEWER\").PRESENT

If (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI\TEAMVIEWER' -Name PRESENT -ErrorAction SilentlyContinue) {
    $REGISTRE_TEAMVIEWER = $true
} Else {
    $REGISTRE_TEAMVIEWER = $false
}

# TEST/CREATION de la clée de registre SBI
IF($REGISTRE_SBI -eq $false) {
	New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\" -Name SBI
}
# TEST/CREATION de la clée de registre TEAMVIEWER
IF($REGISTRE_TEAMVIEWER -eq $false) {
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI\" -Name TEAMVIEWER
}
IF($REGISTRE_TEAMVIEWER -eq $false) {
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI\" -Name TEAMVIEWER
}

IF($REGISTREVALUE_TEAMVIEWER_PRESENT -eq 0) {
	cmd.exe /c Taskkill /F /IM TeamViewer.exe
	cmd.exe /c "C:\Program Files (x86)\TeamViewer\uninstall.exe" /S
	Set-Itemproperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI\TEAMVIEWER" -Name 'PRESENT' -value 1
	exit $REGISTREVALUE_TEAMVIEWER_PRESENT
}
