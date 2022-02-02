# Déclaration des variables
$TEST_PATH_SBI = Test-Path -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI"
$TEST_PATH_TEAMVIEWER = Test-Path -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI\TEAMVIEWER"

If (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI\TEAMVIEWER' -Name PRESENT -ErrorAction SilentlyContinue) {
    $REGISTRE_TEAMVIEWER = $true
} Else {
    $REGISTRE_TEAMVIEWER = $false
}

# TEST/CREATION de la clée de registre SBI
IF($TEST_PATH_SBI -eq $false) {
	New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\" -Name SBI
}

# TEST/CREATION de la clée de registre TEAMVIEWER
IF($TEST_PATH_TEAMVIEWER -eq $false) {
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI" -Name TEAMVIEWER
Set-Itemproperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI\TEAMVIEWER" -Name 'PRESENT' -value 1 -Type "DWORD"
$REGISTREVALUE_TEAMVIEWER_PRESENT = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI\TEAMVIEWER\").PRESENT
} ELSE {
$REGISTREVALUE_TEAMVIEWER_PRESENT = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI\TEAMVIEWER\").PRESENT
}

IF($REGISTREVALUE_TEAMVIEWER_PRESENT -eq 0) {
	cmd.exe /c Taskkill /F /IM TeamViewer.exe
	cmd.exe /c "C:\Program Files (x86)\TeamViewer\uninstall.exe" /S
	Set-Itemproperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\SBI\TEAMVIEWER" -Name 'PRESENT' -value 1
	exit $REGISTREVALUE_TEAMVIEWER_PRESENT
}
