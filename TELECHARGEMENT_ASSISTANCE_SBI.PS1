$path = "C:\SBI\TEAMVIEWER\Assistance_SBI.exe"
$TargetFile = "C:\SBI\TEAMVIEWER\Assistance_SBI.exe"
$ShortcutFile = "C:\Users\Public\Desktop\Assistance-SBI.lnk"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutFile)

If(!(test-path $path))
{
    Import-Module BitsTransfer
	mkdir C:\SBI\TEAMVIEWER\
	Start-BitsTransfer http://sbiinforkw.cluster020.hosting.ovh.net/Applications/TEAMVIEWER/Assistance_SBI.exe C:/SBI/TEAMVIEWER/Assistance_SBI.exe

}

    Start-BitsTransfer http://sbiinforkw.cluster020.hosting.ovh.net/Applications/TEAMVIEWER/SBI_LOGO.ico C:/SBI/TEAMVIEWER/SBI_LOGO.ico

    $Shortcut.TargetPath = $TargetFile
    $Shortcut.IconLocation = "C:/SBI/TEAMVIEWER/SBI_LOGO.ico";
    $Shortcut.Save()
