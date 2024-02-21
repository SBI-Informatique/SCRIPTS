# Définition du chemin de la clé de registre
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
# Nom de la propriété à vérifier
$propertyName = "HiberbootEnabled"

# Vérification de l'existence de la clé de registre et récupération de sa valeur
if (Test-Path $registryPath) {
    $propertyValue = (Get-ItemProperty -Path $registryPath -Name $propertyName).$propertyName
    Write-Output "$propertyValue"
} else {
    Write-Output "La clé de registre $registryPath n'existe pas."
}
