$TargetFile = "https://sbi-informatique.zendesk.com/hc/fr/requests/new"
$ShortcutFile = "C:\Users\Public\Desktop\Ticket-SBI.lnk"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutFile)
mkdir C:\SBI\TICKET

    Import-Module BitsTransfer
    Start-BitsTransfer http://sbiinforkw.cluster020.hosting.ovh.net/Applications/TICKET/SBI_LOGO_TICKET.ico C:/SBI/TICKET/SBI_LOGO_TICKET.ico

    $Shortcut.TargetPath = $TargetFile
    $Shortcut.IconLocation = "C:/SBI/TICKET/SBI_LOGO_TICKET.ico";
    $Shortcut.Save()
