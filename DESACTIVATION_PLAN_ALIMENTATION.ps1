
$registryKey = "HKLM:\SOFTWARE\SBI\WINDOWS"
$valueName = "ALIMENTATION-FULL"

$value = Get-ItemProperty -Path $registryKey -Name $valueName

if ($value.$valueName -eq 1) {
  Get-WmiObject -Class "Win32PowerPlan" | ForEach-Object {
      $plan = $
      if ($plan.IsActive -eq $true) {
          $guid = [guid]$plan.InstanceID
          powercfg -setdcvalueindex $guid.ToString() 4f971e89-eebd-4455-a8de-9e59040e7347 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
          powercfg -setacvalueindex $guid.ToString() 4f971e89-eebd-4455-a8de-9e59040e7347 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
      }
  }
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
