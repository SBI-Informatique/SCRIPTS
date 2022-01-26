New-Item -Path 'C\sbi\LISTE_COMPTE_ADMINISTRATEURS.txt' -ItemType File
Get-LocalGroupMember -Group "Administrateurs" | Select-Object Name | Format-Table -HideTableHead > C:\SBI\LISTE_COMPTE_ADMINISTRATEURS.txt
