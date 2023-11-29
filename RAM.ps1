# Récupérer les informations sur les barrettes de RAM actuelles
$RAMModules = Get-WmiObject Win32_PhysicalMemory

# Créer une variable pour stocker les informations
$AllRAMInfo = ""

# Ligne de séparation au-dessus du résultat
$AllRAMInfo += "------`n"

# Parcourir chaque barrette de RAM
foreach ($RAMModule in $RAMModules) {
    $Manufacturer = $RAMModule.Manufacturer
    $PartNumber = $RAMModule.PartNumber
    $Speed = $RAMModule.Speed
    $CapacityBytes = $RAMModule.Capacity
    $DeviceLocator = $RAMModule.DeviceLocator

    # Convertir la capacité en gigaoctets (Go) pour une lecture plus conviviale
    $CapacityGB = [math]::Round($CapacityBytes / 1GB, 2)

    # Ajouter les informations pour cette barrette de RAM à la variable
    $AllRAMInfo += "Manufacturer : $Manufacturer`n"
    $AllRAMInfo += "Part Number : $PartNumber`n"
    $AllRAMInfo += "Speed : $Speed MHz`n"
    $AllRAMInfo += "Capacity : $CapacityGB Go`n"
    $AllRAMInfo += "DeviceLocator : $DeviceLocator`n"
    $AllRAMInfo += "------`n"
}

# Compter le nombre total d'emplacements de RAM
$TotalRAMSlots = ($RAMModules | Measure-Object).Count

# Exécutez la commande et stockez la sortie dans une variable
$memoryArrayInfo = Get-WmiObject Win32_PhysicalMemoryArray

# Initialisez une variable pour stocker la somme
$totalMemoryDevices = 0

# Parcourez chaque élément dans la colonne MemoryDevices et additionnez-les
foreach ($memoryArray in $memoryArrayInfo) {
    $totalMemoryDevices += $memoryArray.MemoryDevices
}

# Calculer le nombre d'emplacements de RAM restants
$RemainingRAMSlots = $totalMemoryDevices - $TotalRAMSlots

# Afficher l'ensemble des informations
$RAM = "$AllRAMInfo`Nombre d'emplacements de RAM restants : $RemainingRAMSlots`n------"

# Afficher le nombre d'emplacements de RAM restants
Write-Host $RAM
