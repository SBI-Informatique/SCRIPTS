$TargetFile = "https://sbi-informatique.zendesk.com/hc/fr/requests/new"
$ShortcutFile = "C:\Users\Public\Desktop\Ticket-SBI.lnk"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutFile)

    Import-Module BitsTransfer
    Start-BitsTransfer http://sbiinforkw.cluster020.hosting.ovh.net/Applications/TEAMVIEWER/SBI_LOGO_TICKET.ico C:/SBI/TEAMVIEWER/SBI_LOGO_TICKET.ico

    $Shortcut.TargetPath = $TargetFile
    $Shortcut.IconLocation = "C:/SBI/TEAMVIEWER/SBI_LOGO_TICKET.ico";
    $Shortcut.Save()
