
$registryKey = "HKLM:\SOFTWARE\SBI\WINDOWS"
$valueName = "ALIMENTATION-FULL"

$value = Get-ItemProperty -Path $registryKey -Name $valueName

if ($value.$valueName -eq 1) {
    powercfg -change -standby-timeout-ac 0
    powercfg -change -hibernate-timeout-ac 0
    powercfg -change -standby-timeout-dc 0
    powercfg -change -hibernate-timeout-dc 0
    Write-Output "Plan d'alimentation désactivé"
} else {
    Write-Output "Clée de registre non renseignée"
}

<#
CREE LA CLEE SBI
  new-item -Path "HKLM:\SOFTWARE" -Name "SBI"
CREE LA CLEE WINDOWS DANS SBI
  new-item -Path "HKLM:\SOFTWARE\SBI" -Name "WINDOWS"
AJOUTER LA CLEE DWORD ALIMENTATION-FULL
  New-ItemProperty -Path "HKLM:\SOFTWARE\SBI\WINDOWS" -Name "ALIMENTATION-FULL" -Value "1" -PropertyType "DWORD"
#>
